import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../application/categorias_providers.dart';
import 'estilo_categoria.dart';
import 'formulario_categoria_page.dart';

class CategoriasPage extends ConsumerWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider).value ?? const [];
    final reglas = ref.watch(reglasProvider).value ?? const [];

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Categorías'),
        previousPageTitle: 'Ajustes',
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => abrirModal(context, const FormularioCategoriaPage()),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            if (categorias.isNotEmpty)
              CupertinoListSection.insetGrouped(
                footer: const PieSeccion(
                  'Desliza a la izquierda para borrar. Las compras de una '
                  'categoría borrada quedan sin categoría.',
                ),
                children: [
                  for (final c in categorias)
                    DeslizarParaBorrar(
                      id: c.id,
                      titulo: '¿Borrar "${c.nombre}"?',
                      mensaje:
                          'Sus compras quedarán sin categoría y se borrarán '
                          'sus reglas.',
                      alBorrar: () => ref
                          .read(categoriasRepositorioProvider)
                          .borrarCategoria(c.id),
                      child: CupertinoListTile(
                        leading: IconoCategoria.de(c),
                        title: Text(c.nombre),
                        additionalInfo: Text(
                          _textoReglas(
                            reglas.where((r) => r.categoriaId == c.id).length,
                          ),
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => abrirModal(
                          context,
                          FormularioCategoriaPage(categoria: c),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _textoReglas(int n) => switch (n) {
    0 => '',
    1 => '1 regla',
    _ => '$n reglas',
  };
}
