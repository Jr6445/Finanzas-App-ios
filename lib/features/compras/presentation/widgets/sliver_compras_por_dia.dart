import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/dialogos.dart';
import '../../../categorias/application/categorias_providers.dart';
import '../../application/compras_providers.dart';
import '../../domain/agrupacion.dart';
import '../formulario_compra_page.dart';
import 'compra_tile.dart';
import 'encabezado_dia.dart';

/// Lista de compras agrupadas por día, con tocar para editar y deslizar para
/// borrar. La usan la pantalla de Compras y el detalle por categoría o
/// tarjeta. Es un "sliver" para poder ir dentro de un CustomScrollView.
class SliverComprasPorDia extends ConsumerWidget {
  const SliverComprasPorDia({super.key, required this.grupos});

  final List<GrupoDia> grupos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasPorIdProvider);

    return SliverList.builder(
      itemCount: grupos.length,
      itemBuilder: (context, i) => CupertinoListSection.insetGrouped(
        header: EncabezadoDia(grupo: grupos[i]),
        children: [
          for (final compra in grupos[i].compras)
            DeslizarParaBorrar(
              id: compra.id,
              titulo: '¿Borrar compra?',
              mensaje: compra.comercio,
              alBorrar: () =>
                  ref.read(comprasRepositorioProvider).borrar(compra.id),
              child: CompraTile(
                compra: compra,
                categoria: categorias[compra.categoriaId],
                onTap: () =>
                    abrirModal(context, FormularioCompraPage(compra: compra)),
              ),
            ),
        ],
      ),
    );
  }
}
