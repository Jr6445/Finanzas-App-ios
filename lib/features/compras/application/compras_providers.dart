import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/base_datos.dart';
import '../../../core/platform/plataforma.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../cuentas/application/cuentas_providers.dart';
import '../data/compras_repositorio.dart';
import '../data/fuente_compras.dart';
import '../data/fuente_compras_fake.dart';
import '../data/fuente_compras_ios.dart';
import '../domain/agrupacion.dart';
import '../domain/compra.dart';
import 'importador_compras.dart';

// Un Provider de Riverpod es como un registro AddSingleton en el contenedor
// de .NET, pero cada uno declara sus dependencias con ref.watch(...). Si una
// dependencia cambia, Riverpod recalcula todo lo que depende de ella (similar
// a un `computed` de Vue).

/// En el iPhone, las compras del App Intent; en Windows, Chrome o Android,
/// datos de prueba.
final fuenteComprasProvider = Provider<FuenteCompras>(
  (ref) => esIOSReal ? FuenteComprasIOS() : FuenteComprasFake(),
);

final comprasRepositorioProvider = Provider<ComprasRepositorio>(
  (ref) => ComprasRepositorio(ref.watch(baseDatosProvider)),
);

final importadorComprasProvider = Provider<ImportadorCompras>((ref) {
  return ImportadorCompras(
    fuente: ref.watch(fuenteComprasProvider),
    compras: ref.watch(comprasRepositorioProvider),
    categorias: ref.watch(categoriasRepositorioProvider),
    cuentas: ref.watch(cuentasRepositorioProvider),
  );
});

/// Todas las compras, actualizadas en vivo. Un StreamProvider expone el
/// stream como `AsyncValue` (cargando / datos / error).
final comprasProvider = StreamProvider<List<Compra>>((ref) {
  return ref.watch(comprasRepositorioProvider).observarTodas();
});

final comprasPorDiaProvider = Provider<AsyncValue<List<GrupoDia>>>((ref) {
  return ref.watch(comprasProvider).whenData(agruparPorDia);
});
