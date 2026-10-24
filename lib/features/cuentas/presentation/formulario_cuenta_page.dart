import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/base_datos.dart' show coloresCuentas;
import '../../../core/format/formato.dart';
import '../../../core/theme/paleta.dart';
import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../../categorias/domain/regla_categoria.dart';
import '../application/cuentas_providers.dart';
import '../domain/cuenta.dart';

/// Crear ([cuenta] null) o editar una cuenta. Devuelve true si la cuenta se
/// borró.
class FormularioCuentaPage extends ConsumerStatefulWidget {
  const FormularioCuentaPage({super.key, this.cuenta});

  final Cuenta? cuenta;

  @override
  ConsumerState<FormularioCuentaPage> createState() =>
      _FormularioCuentaPageState();
}

class _FormularioCuentaPageState extends ConsumerState<FormularioCuentaPage> {
  late final TextEditingController _nombre;
  late final TextEditingController _saldo;
  late final TextEditingController _limite;
  late final TextEditingController _diaCorte;
  late final TextEditingController _diaPago;
  late final TextEditingController _alias;
  late TipoCuenta _tipo;
  late String _color;
  late int _diasRecordatorio;

  /// Saldo (o deuda) calculado hoy; si el usuario no lo cambia, se conserva
  /// el saldo inicial original.
  int? _valorActual;

  bool get _editando => widget.cuenta != null;

  @override
  void initState() {
    super.initState();
    final c = widget.cuenta;
    if (c != null) {
      _valorActual = ref
          .read(estadosCuentasProvider)
          .where((e) => e.cuenta.id == c.id)
          .firstOrNull
          ?.valorCentavos;
    }
    _nombre = TextEditingController(text: c?.nombre);
    _saldo = TextEditingController(
      text: _valorActual == null ? null : montoParaEditar(_valorActual!),
    );
    _limite = TextEditingController(
      text: c?.limiteCentavos == null
          ? null
          : montoParaEditar(c!.limiteCentavos!),
    );
    _diaCorte = TextEditingController(text: c?.diaCorte?.toString());
    _diaPago = TextEditingController(text: c?.diaPago?.toString());
    _alias = TextEditingController(text: c?.alias.join(', '));
    _tipo = c?.tipo ?? TipoCuenta.debito;
    _color =
        c?.color ??
        coloresCuentas[(ref.read(cuentasProvider).value?.length ?? 0) %
            coloresCuentas.length];
    _diasRecordatorio = c?.diasRecordatorio ?? 3;
  }

  @override
  void dispose() {
    for (final c in [_nombre, _saldo, _limite, _diaCorte, _diaPago, _alias]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Vacío cuenta como 0; null = texto inválido.
  int? _monto(TextEditingController c) =>
      c.text.trim().isEmpty ? 0 : parsearMonto(c.text);

  /// Vacío = sin día; -1 = inválido.
  int? _dia(TextEditingController c) {
    if (c.text.trim().isEmpty) return null;
    final dia = int.tryParse(c.text.trim());
    return dia != null && dia >= 1 && dia <= 31 ? dia : -1;
  }

  String? _error() {
    final nombre = normalizar(_nombre.text);
    if (nombre.isEmpty) return '';
    final repetido = (ref.read(cuentasProvider).value ?? const []).any(
      (c) => c.id != widget.cuenta?.id && normalizar(c.nombre) == nombre,
    );
    if (repetido) return 'Ya existe una cuenta con ese nombre.';
    if (_tipo == TipoCuenta.sinConfigurar) return 'Elige el tipo de cuenta.';
    if (_monto(_saldo) == null) return 'El saldo no es un monto válido.';
    if (_tipo == TipoCuenta.credito) {
      if (_monto(_limite) == null) return 'El límite no es un monto válido.';
      if (_dia(_diaCorte) == -1 || _dia(_diaPago) == -1) {
        return 'Los días deben ser números del 1 al 31.';
      }
    }
    return null;
  }

  Future<void> _guardar() async {
    final original = widget.cuenta;
    final credito = _tipo == TipoCuenta.credito;
    final valor = _monto(_saldo)!;
    // Si cambió el saldo escrito (o el tipo), ese valor es el nuevo punto
    // de partida a partir de ahora.
    final reiniciarSaldo =
        original == null || valor != _valorActual || _tipo != original.tipo;
    final ahora = DateTime.now();
    final limite = _monto(_limite)!;

    final base =
        original ??
        Cuenta(
          id: 0,
          nombre: '',
          tipo: _tipo,
          color: _color,
          fechaSaldoInicial: ahora,
        );
    await ref
        .read(cuentasRepositorioProvider)
        .guardarCuenta(
          base.copyWith(
            nombre: _nombre.text.trim(),
            tipo: _tipo,
            color: _color,
            alias: [
              for (final a in _alias.text.split(','))
                if (a.trim().isNotEmpty) a.trim(),
            ],
            saldoInicialCentavos: reiniciarSaldo
                ? valor
                : base.saldoInicialCentavos,
            fechaSaldoInicial: reiniciarSaldo ? ahora : base.fechaSaldoInicial,
            limiteCentavos: () => credito && limite > 0 ? limite : null,
            diaCorte: () => credito ? _dia(_diaCorte) : null,
            diaPago: () => credito ? _dia(_diaPago) : null,
            diasRecordatorio: _diasRecordatorio,
          ),
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _borrar() async {
    final confirmado = await confirmarBorrado(
      context,
      titulo: '¿Borrar "${widget.cuenta!.nombre}"?',
      mensaje:
          'Sus compras se conservan, pero dejarán de estar asociadas a una '
          'cuenta.',
    );
    if (!confirmado) return;
    await ref.read(cuentasRepositorioProvider).borrarCuenta(widget.cuenta!.id);
    // true = "se borró": el detalle de la cuenta también se cierra.
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(cuentasProvider);
    final error = _error();
    final credito = _tipo == TipoCuenta.credito;

    CupertinoTextFormFieldRow campoMonto(
      String etiqueta,
      TextEditingController c,
    ) => CupertinoTextFormFieldRow(
      prefix: Text(etiqueta),
      controller: c,
      placeholder: r'$0.00',
      textAlign: TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setState(() {}),
    );

    CupertinoTextFormFieldRow campoDia(
      String etiqueta,
      TextEditingController c,
    ) => CupertinoTextFormFieldRow(
      prefix: Text(etiqueta),
      controller: c,
      placeholder: '1 – 31',
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_editando ? 'Editar cuenta' : 'Nueva cuenta'),
        leading: BotonBarra(
          texto: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        trailing: BotonBarra(
          texto: 'Guardar',
          principal: true,
          onPressed: error == null ? _guardar : null,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSlidingSegmentedControl<TipoCuenta>(
                groupValue: _tipo == TipoCuenta.sinConfigurar ? null : _tipo,
                children: const {
                  TipoCuenta.debito: Text('Débito'),
                  TipoCuenta.credito: Text('Crédito'),
                  TipoCuenta.efectivo: Text('Efectivo'),
                },
                onValueChanged: (t) => setState(() => _tipo = t!),
              ),
            ),
            CupertinoFormSection.insetGrouped(
              footer: error == null || error.isEmpty ? null : PieSeccion(error),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: const Text('Nombre'),
                  controller: _nombre,
                  placeholder: 'Ej. Visa Agrícola',
                  textAlign: TextAlign.end,
                  textCapitalization: TextCapitalization.words,
                  autofocus: !_editando,
                  onChanged: (_) => setState(() {}),
                ),
                campoMonto(credito ? 'Deuda actual' : 'Saldo actual', _saldo),
                if (credito) campoMonto('Límite', _limite),
              ],
            ),
            if (credito)
              CupertinoFormSection.insetGrouped(
                header: const EncabezadoSeccion('Corte y pago'),
                footer: const PieSeccion(
                  'Con estos días la app calcula cuánto pagar de cada corte y '
                  'te avisa antes de la fecha límite.',
                ),
                children: [
                  campoDia('Día de corte', _diaCorte),
                  campoDia('Día límite de pago', _diaPago),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Aviso')),
                        CupertinoSlidingSegmentedControl<int>(
                          groupValue: _diasRecordatorio,
                          children: const {
                            0: Text('No'),
                            1: Text('1 día'),
                            3: Text('3 días'),
                            5: Text('5 días'),
                          },
                          onValueChanged: (d) =>
                              setState(() => _diasRecordatorio = d!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            CupertinoFormSection.insetGrouped(
              header: const EncabezadoSeccion('Nombres en Apple Pay'),
              footer: const PieSeccion(
                'Si la tarjeta llega desde Atajos con otro nombre (p. ej. '
                '"Visa ••4821"), escríbelo aquí, separado por comas, para '
                'que sus compras se asocien a esta cuenta.',
              ),
              children: [
                CupertinoTextFormFieldRow(
                  controller: _alias,
                  placeholder: 'Opcional',
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  for (final MapEntry(key: clave, value: tono)
                      in tonosPastel.entries)
                    GestureDetector(
                      onTap: () => setState(() => _color = clave),
                      child: Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: clave == _color
                                ? CupertinoColors.systemGrey3.resolveFrom(
                                    context,
                                  )
                                : const Color(0x00000000),
                          ),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: CupertinoDynamicColor.resolve(
                              tono.medio,
                              context,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_editando)
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    title: Center(
                      child: Text(
                        'Borrar cuenta',
                        style: TextStyle(
                          color: CupertinoColors.systemRed.resolveFrom(context),
                        ),
                      ),
                    ),
                    onTap: _borrar,
                  ),
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
