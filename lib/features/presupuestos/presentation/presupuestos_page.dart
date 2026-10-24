import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/formato.dart';
import '../../../core/ui/tarjeta.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../categorias/domain/categoria.dart';
import '../../categorias/presentation/estilo_categoria.dart';
import '../application/presupuestos_providers.dart';

class PresupuestosPage extends ConsumerWidget {
  const PresupuestosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider).value ?? const [];
    final presupuestos = ref.watch(presupuestosProvider).value ?? const {};
    final total = presupuestos.values.fold(0, (a, b) => a + b);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Presupuestos'),
        previousPageTitle: 'Ajustes',
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: const EncabezadoSeccion('Mensual por categoría'),
              footer: PieSeccion(
                'El presupuesto se repite cada mes. En Resumen verás cuánto '
                'llevas gastado de cada uno.'
                '${total > 0 ? '\nTotal: ${formatearMonto(total)} al mes.' : ''}',
              ),
              children: [
                for (final c in categorias)
                  CupertinoListTile(
                    leading: IconoCategoria.de(c),
                    title: Text(c.nombre),
                    additionalInfo: Text(
                      presupuestos[c.id] == null
                          ? 'Sin presupuesto'
                          : formatearMonto(presupuestos[c.id]!),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _editar(context, ref, c, presupuestos[c.id]),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editar(
    BuildContext context,
    WidgetRef ref,
    Categoria categoria,
    int? actual,
  ) async {
    final nuevo = await showCupertinoDialog<int>(
      context: context,
      builder: (_) =>
          _DialogoPresupuesto(categoria: categoria.nombre, actual: actual),
    );
    if (nuevo == null) return;
    final repositorio = ref.read(presupuestosRepositorioProvider);
    if (nuevo == 0) {
      await repositorio.quitar(categoria.id);
    } else {
      await repositorio.fijar(categoria.id, nuevo);
    }
  }
}

/// Devuelve el monto en centavos, 0 para quitar el presupuesto, o null si
/// se canceló.
class _DialogoPresupuesto extends StatefulWidget {
  const _DialogoPresupuesto({required this.categoria, required this.actual});

  final String categoria;
  final int? actual;

  @override
  State<_DialogoPresupuesto> createState() => _DialogoPresupuestoState();
}

class _DialogoPresupuestoState extends State<_DialogoPresupuesto> {
  late final TextEditingController _monto = TextEditingController(
    text: widget.actual == null ? null : montoParaEditar(widget.actual!),
  );

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monto = parsearMonto(_monto.text);
    return CupertinoAlertDialog(
      title: Text(widget.categoria),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: CupertinoTextField(
          controller: _monto,
          placeholder: r'Presupuesto mensual ($)',
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        if (widget.actual != null)
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('Quitar'),
          ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: monto == null || monto <= 0
              ? null
              : () => Navigator.pop(context, monto),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
