import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/categorias_providers.dart';
import 'estilo_categoria.dart';

/// Resultado del selector. Es una clase (y no un `int?` directo) para poder
/// distinguir "eligió Sin categoría" (id null) de "regresó sin elegir"
/// (el Navigator devuelve null).
class CategoriaElegida {
  const CategoriaElegida(this.id);

  final int? id;
}

class SelectorCategoriaPage extends ConsumerWidget {
  const SelectorCategoriaPage({
    super.key,
    required this.seleccionada,
    this.permitirNinguna = false,
  });

  final int? seleccionada;
  final bool permitirNinguna;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasProvider).value ?? const [];

    Widget opcion(int? id, String nombre, Widget icono) => CupertinoListTile(
      leading: icono,
      title: Text(nombre),
      trailing: id == seleccionada
          ? const Icon(CupertinoIcons.check_mark, size: 20)
          : null,
      onTap: () => Navigator.pop(context, CategoriaElegida(id)),
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Categoría')),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                if (permitirNinguna)
                  opcion(
                    null,
                    nombreSinCategoria,
                    const IconoCategoria(icono: null, color: null),
                  ),
                for (final c in categorias)
                  opcion(c.id, c.nombre, IconoCategoria.de(c)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
