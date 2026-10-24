import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/format/formato.dart';
import '../../../core/ui/dialogos.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../categorias/domain/regla_categoria.dart';
import '../../categorias/presentation/estilo_categoria.dart';
import '../../categorias/presentation/selector_categoria_page.dart';
import '../application/compras_providers.dart';
import '../domain/compra.dart';

/// Crear ([compra] null) o editar una compra.
class FormularioCompraPage extends ConsumerStatefulWidget {
  const FormularioCompraPage({super.key, this.compra});

  final Compra? compra;

  @override
  ConsumerState<FormularioCompraPage> createState() =>
      _FormularioCompraPageState();
}

class _FormularioCompraPageState extends ConsumerState<FormularioCompraPage> {
  late final TextEditingController _comercio;
  late final TextEditingController _monto;
  late final TextEditingController _tarjeta;
  late DateTime _fecha;
  int? _categoriaId;

  /// Mientras el usuario no elija categoría a mano, se sugiere con las
  /// reglas conforme escribe el comercio.
  late bool _categoriaElegida;

  bool get _editando => widget.compra != null;

  bool get _valido =>
      _comercio.text.trim().isNotEmpty &&
      (parsearMonto(_monto.text) ?? 0) > 0 &&
      _tarjeta.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final c = widget.compra;
    _comercio = TextEditingController(text: c?.comercio);
    _monto = TextEditingController(
      text: c == null ? null : montoParaEditar(c.montoCentavos),
    );
    _tarjeta = TextEditingController(text: c?.tarjeta);
    _fecha = c?.fecha ?? DateTime.now();
    _categoriaId = c?.categoriaId;
    _categoriaElegida = _editando;
  }

  @override
  void dispose() {
    _comercio.dispose();
    _monto.dispose();
    _tarjeta.dispose();
    super.dispose();
  }

  void _alCambiarComercio(String texto) {
    setState(() {
      if (!_categoriaElegida) {
        final reglas = ref.read(reglasProvider).value ?? const [];
        _categoriaId = asignarCategoria(texto, reglas);
      }
    });
  }

  Future<void> _elegirCategoria() async {
    final elegida = await abrirPantalla<CategoriaElegida>(
      context,
      SelectorCategoriaPage(seleccionada: _categoriaId, permitirNinguna: true),
    );
    if (elegida == null) return;
    setState(() {
      _categoriaId = elegida.id;
      _categoriaElegida = true;
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
            onDateTimeChanged: (fecha) => setState(() => _fecha = fecha),
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    final original = widget.compra;
    await ref
        .read(comprasRepositorioProvider)
        .guardar(
          Compra(
            id: original?.id ?? const Uuid().v4(),
            comercio: _comercio.text.trim(),
            montoCentavos: parsearMonto(_monto.text)!,
            tarjeta: _tarjeta.text.trim(),
            categoriaId: _categoriaId,
            fecha: _fecha,
            origen: original?.origen ?? OrigenCompra.manual,
          ),
        );
    // `mounted` = el widget sigue en pantalla. Después de un `await` siempre
    // hay que revisarlo antes de usar el context.
    if (mounted) Navigator.pop(context);
  }

  Future<void> _borrar() async {
    final confirmado = await confirmarBorrado(
      context,
      titulo: '¿Borrar compra?',
    );
    if (!confirmado) return;
    await ref.read(comprasRepositorioProvider).borrar(widget.compra!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoria = ref.watch(categoriasPorIdProvider)[_categoriaId];
    final tarjetas = ref.watch(tarjetasConocidasProvider);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_editando ? 'Editar compra' : 'Nueva compra'),
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
                  prefix: const Text('Comercio'),
                  controller: _comercio,
                  placeholder: 'Ej. Super Selectos',
                  textAlign: TextAlign.end,
                  textCapitalization: TextCapitalization.words,
                  autofocus: !_editando,
                  onChanged: _alCambiarComercio,
                ),
                CupertinoTextFormFieldRow(
                  prefix: const Text('Monto'),
                  controller: _monto,
                  placeholder: r'$0.00',
                  textAlign: TextAlign.end,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                CupertinoTextFormFieldRow(
                  prefix: const Text('Tarjeta'),
                  controller: _tarjeta,
                  placeholder: 'Ej. Efectivo',
                  textAlign: TextAlign.end,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            if (tarjetas.isNotEmpty)
              _SugerenciasTarjeta(
                tarjetas: tarjetas,
                alElegir: (t) => setState(() => _tarjeta.text = t),
              ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: IconoCategoria.de(categoria),
                  title: const Text('Categoría'),
                  additionalInfo: Text(categoria?.nombre ?? nombreSinCategoria),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _elegirCategoria,
                ),
                CupertinoListTile(
                  title: const Text('Fecha'),
                  additionalInfo: Text(formatearFechaHora(_fecha)),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _elegirFecha,
                ),
              ],
            ),
            if (_editando)
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    title: Center(
                      child: Text(
                        'Borrar compra',
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

/// Fila de "chips" con las tarjetas ya usadas, para no escribirlas cada vez.
class _SugerenciasTarjeta extends StatelessWidget {
  const _SugerenciasTarjeta({required this.tarjetas, required this.alElegir});

  final List<String> tarjetas;
  final ValueChanged<String> alElegir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final t in {'Efectivo', ...tarjetas})
            GestureDetector(
              onTap: () => alElegir(t),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(
                    context,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(t, style: const TextStyle(fontSize: 14)),
              ),
            ),
        ],
      ),
    );
  }
}
