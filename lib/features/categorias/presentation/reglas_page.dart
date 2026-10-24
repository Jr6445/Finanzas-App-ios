import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../application/categorias_providers.dart';
import 'estilo_categoria.dart';
import 'formulario_regla_page.dart';

class ReglasPage extends ConsumerWidget {
  const ReglasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reglas = ref.watch(reglasProvider).value ?? const [];
    final categorias = ref.watch(categoriasPorIdProvider);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Reglas automáticas'),
        previousPageTitle: 'Ajustes',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => abrirModal(context, const FormularioReglaPage()),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: const EncabezadoSeccion('Si el comercio contiene…'),
              footer: const PieSeccion(
                'Se aplican a las compras de Apple Pay al importarlas y a las '
                'compras sin categoría al guardar una regla. No importan '
                'mayúsculas ni tildes; si coinciden varias, gana el texto más '
                'largo.',
              ),
              children: [
                if (reglas.isEmpty)
                  const CupertinoListTile(title: Text('No hay reglas')),
                for (final r in reglas)
                  DeslizarParaBorrar(
                    id: r.id,
                    titulo: '¿Borrar la regla "${r.patron}"?',
                    alBorrar: () => ref
                        .read(categoriasRepositorioProvider)
                        .borrarRegla(r.id),
                    child: CupertinoListTile(
                      leading: IconoCategoria.de(categorias[r.categoriaId]),
                      title: Text('“${r.patron}”'),
                      additionalInfo: Text(
                        categorias[r.categoriaId]?.nombre ?? '',
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          abrirModal(context, FormularioReglaPage(regla: r)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
