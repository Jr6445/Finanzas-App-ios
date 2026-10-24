import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/format/formato.dart';
import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../application/cuentas_providers.dart';
import '../domain/cuenta.dart';
import '../domain/movimiento.dart';
import 'estilo_cuenta.dart';
import 'selector_cuenta_page.dart';

/// Registrar o editar un depósito o una transferencia (incluye pagar una
/// tarjeta de crédito desde otra cuenta).
class FormularioMovimientoPage extends ConsumerStatefulWidget {
  const FormularioMovimientoPage({
    super.key,
    this.tipo = TipoMovimiento.deposito,
    this.movimiento,
    this.origenId,
    this.destinoId,
  });

  final TipoMovimiento tipo;
  final Movimiento? movimiento;
  final int? origenId;
  final int? destinoId;

  @override
  ConsumerState<FormularioMovimientoPage> createState() =>
      _FormularioMovimientoPageState();
}

class _FormularioMovimientoPageState
    extends ConsumerState<FormularioMovimientoPage> {
  late final TextEditingController _monto;
  late final TextEditingController _nota;
  late DateTime _fecha;
  int? _origenId;
  int? _destinoId;

  Movimiento? get _original => widget.movimiento;
  TipoMovimiento get _tipo => _original?.tipo ?? widget.tipo;
  bool get _esTransferencia => _tipo == TipoMovimiento.transferencia;

  @override
  void initState() {
    super.initState();
    final m = _original;
    _monto = TextEditingController(
      text: m == null ? null : montoParaEditar(m.montoCentavos),
    );
    _nota = TextEditingController(text: m?.nota);
    _fecha = m?.fecha ?? DateTime.now();
    _origenId = m?.cuentaOrigenId ?? widget.origenId;
    _destinoId = m?.cuentaDestinoId ?? widget.destinoId;
    // Al pagar una tarjeta se propone pagar desde la primera cuenta de
    // débito, que es lo más común.
    if (_esTransferencia && _origenId == null) {
      _origenId = ref
          .read(cuentasProvider)
          .value
          ?.where((c) => c.tipo == TipoCuenta.debito && c.id != _destinoId)
          .firstOrNull
          ?.id;
    }
  }

  @override
  void dispose() {
    _monto.dispose();
    _nota.dispose();
    super.dispose();
  }

  bool get _valido =>
      (parsearMonto(_monto.text) ?? 0) > 0 &&
      _destinoId != null &&
      (!_esTransferencia || (_origenId != null && _origenId != _destinoId));

  Future<void> _elegir({required bool origen}) async {
    final elegida = await abrirPantalla<Cuenta>(
      context,
      SelectorCuentaPage(
        titulo: origen ? 'Desde' : (_esTransferencia ? 'Hacia' : 'Cuenta'),
        seleccionada: origen ? _origenId : _destinoId,
        excluir: _esTransferencia ? (origen ? _destinoId : _origenId) : null,
      ),
    );
    if (elegida == null) return;
    setState(() {
      if (origen) {
        _origenId = elegida.id;
      } else {
        _destinoId = elegida.id;
      }
    });
  }

  Future<void> _elegirFecha() {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 280,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _fecha,
            maximumDate: DateTime.now().add(const Duration(days: 1)),
            onDateTimeChanged: (f) => setState(() => _fecha = f),
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    await ref
        .read(cuentasRepositorioProvider)
        .guardarMovimiento(
          Movimiento(
            id: _original?.id ?? const Uuid().v4(),
            tipo: _tipo,
            cuentaOrigenId: _esTransferencia ? _origenId : null,
            cuentaDestinoId: _destinoId,
            montoCentavos: parsearMonto(_monto.text)!,
            fecha: _fecha,
            nota: _nota.text.trim(),
          ),
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _borrar() async {
    final confirmado = await confirmarBorrado(
      context,
      titulo: '¿Borrar este movimiento?',
    );
    if (!confirmado) return;
    await ref.read(cuentasRepositorioProvider).borrarMovimiento(_original!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cuentas = ref.watch(cuentasPorIdProvider);
    final destino = cuentas[_destinoId];
    final esPago = _esTransferencia && (destino?.esCredito ?? false);
    final titulo = switch (_tipo) {
      TipoMovimiento.deposito => 'Depósito',
      TipoMovimiento.transferencia when esPago => 'Pagar tarjeta',
      TipoMovimiento.transferencia => 'Transferencia',
      TipoMovimiento.ajuste => 'Ajuste',
    };

    CupertinoListTile filaCuenta(String etiqueta, int? id, bool origen) =>
        CupertinoListTile(
          leading: IconoCuenta(cuenta: cuentas[id], tamano: 30),
          title: Text(etiqueta),
          additionalInfo: Text(cuentas[id]?.nombre ?? 'Elegir'),
          trailing: const CupertinoListTileChevron(),
          onTap: () => _elegir(origen: origen),
        );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(titulo),
        leading: BotonBarra(
          texto: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        trailing: BotonBarra(
          texto: 'Guardar',
          principal: true,
          onPressed: _valido ? _guardar : null,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoFormSection.insetGrouped(
              children: [
                CupertinoTextFormFieldRow(
                  prefix: Text(esPago ? 'Abono' : 'Monto'),
                  controller: _monto,
                  placeholder: r'$0.00',
                  textAlign: TextAlign.end,
                  autofocus: _original == null,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                CupertinoTextFormFieldRow(
                  prefix: const Text('Nota'),
                  controller: _nota,
                  placeholder: _esTransferencia ? 'Opcional' : 'Ej. Salario',
                  textAlign: TextAlign.end,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                if (_esTransferencia) filaCuenta('Desde', _origenId, true),
                filaCuenta(
                  _esTransferencia ? 'Hacia' : 'Cuenta',
                  _destinoId,
                  false,
                ),
                CupertinoListTile(
                  title: const Text('Fecha'),
                  additionalInfo: Text(formatearFechaHora(_fecha)),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _elegirFecha,
                ),
              ],
            ),
            if (esPago)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PieSeccion(
                  'El abono baja la deuda de la tarjeta y el saldo de la '
                  'cuenta desde la que pagas. No cuenta como gasto.',
                ),
              ),
            if (_original != null)
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    title: Center(
                      child: Text(
                        'Borrar movimiento',
                        style: TextStyle(
                          color: CupertinoColors.systemRed.resolveFrom(context),
                        ),
                      ),
                    ),
                    onTap: _borrar,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
