import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/base_datos.dart';
import '../data/categorias_repositorio.dart';
import '../domain/categoria.dart';
import '../domain/regla_categoria.dart';

final categoriasRepositorioProvider = Provider<CategoriasRepositorio>(
  (ref) => CategoriasRepositorio(ref.watch(baseDatosProvider)),
);

final categoriasProvider = StreamProvider<List<Categoria>>(
  (ref) => ref.watch(categoriasRepositorioProvider).observarCategorias(),
);

/// Para buscar rápido la categoría de cada compra en la lista.
final categoriasPorIdProvider = Provider<Map<int, Categoria>>((ref) {
  final categorias = ref.watch(categoriasProvider).value ?? const [];
  return {for (final c in categorias) c.id: c};
});

final reglasProvider = StreamProvider<List<ReglaCategoria>>(
  (ref) => ref.watch(categoriasRepositorioProvider).observarReglas(),
);
