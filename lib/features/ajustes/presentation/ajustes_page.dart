import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/paleta.dart';
import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../categorias/presentation/categorias_page.dart';
import '../../categorias/presentation/reglas_page.dart';
import '../../exportar/application/exportador.dart';
import '../../presupuestos/application/presupuestos_providers.dart';
import '../../presupuestos/presentation/presupuestos_page.dart';

class AjustesPage extends ConsumerStatefulWidget {
  const AjustesPage({super.key});

  @override
  ConsumerState<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends ConsumerState<AjustesPage> {
  bool _exportando = false;

  Future<void> _exportar() async {
    setState(() => _exportando = true);
    try {
      final archivos = await ref.read(exportadorProvider).generarArchivos();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            for (final a in archivos) XFile(a.path, mimeType: 'text/csv'),
          ],
          subject: 'Respaldo de Finanzas',
        ),
      );
    } catch (e) {
      if (mounted) {
        await showCupertinoDialog<void>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('No se pudo exportar'),
            content: Text('$e'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ref.watch(categoriasProvider).value?.length;
    final reglas = ref.watch(reglasProvider).value?.length;
    final presupuestos = ref.watch(presupuestosProvider).value?.length;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Ajustes'),
            border: null,
            backgroundColor: CupertinoColors.systemGroupedBackground,
          ),
          SliverList.list(
            children: [
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    leading: IconoTono(
                      icono: CupertinoIcons.square_grid_2x2,
                      tono: tonoPastel('morado'),
                      tamano: 30,
                    ),
                    title: const Text('Categorías'),
                    additionalInfo: Text('${categorias ?? ''}'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => abrirPantalla(context, const CategoriasPage()),
                  ),
                  CupertinoListTile(
                    leading: IconoTono(
                      icono: CupertinoIcons.wand_stars,
                      tono: tonoPastel('amarillo'),
                      tamano: 30,
                    ),
                    title: const Text('Reglas automáticas'),
                    additionalInfo: Text('${reglas ?? ''}'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => abrirPantalla(context, const ReglasPage()),
                  ),
                  CupertinoListTile(
                    leading: IconoTono(
                      icono: CupertinoIcons.chart_bar,
                      tono: tonoPastel('verde'),
                      tamano: 30,
                    ),
                    title: const Text('Presupuestos'),
                    additionalInfo: Text('${presupuestos ?? ''}'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () =>
                        abrirPantalla(context, const PresupuestosPage()),
                  ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                header: const EncabezadoSeccion('Respaldo'),
                footer: const PieSeccion(
                  'Genera cuatro archivos CSV (compras, categorías, cuentas y '
                  'movimientos) que puedes '
                  'guardar en Archivos o enviarte por correo. Se abren en '
                  'Excel o Numbers.',
                ),
                children: [
                  CupertinoListTile(
                    leading: IconoTono(
                      icono: CupertinoIcons.square_arrow_up,
                      tono: tonoPastel('azul'),
                      tamano: 30,
                    ),
                    title: const Text('Exportar a CSV'),
                    trailing: _exportando
                        ? const CupertinoActivityIndicator()
                        : null,
                    onTap: _exportando ? null : _exportar,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
