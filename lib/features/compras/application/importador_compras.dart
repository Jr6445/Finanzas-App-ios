import '../../categorias/data/categorias_repositorio.dart';
import '../../categorias/domain/regla_categoria.dart';
import '../../cuentas/data/cuentas_repositorio.dart';
import '../../cuentas/domain/cuenta.dart';
import '../data/compras_repositorio.dart';
import '../data/fuente_compras.dart';
import '../domain/compra.dart';

/// Pasa las compras pendientes de la [FuenteCompras] al repositorio,
/// asignándoles categoría con las reglas y la cuenta según el nombre de la
/// tarjeta. Es el "caso de uso" de importar.
class ImportadorCompras {
  ImportadorCompras({
    required this.fuente,
    required this.compras,
    required this.categorias,
    required this.cuentas,
  });

  final FuenteCompras fuente;
  final ComprasRepositorio compras;
  final CategoriasRepositorio categorias;
  final CuentasRepositorio cuentas;

  Future<int>? _enCurso;

  /// Devuelve cuántas compras nuevas se importaron. Si ya hay una
  /// importación corriendo (p. ej. al abrir y volver a primer plano casi a la
  /// vez), devuelve esa misma en lugar de lanzar otra.
  Future<int> importarPendientes() {
    return _enCurso ??= _importar().whenComplete(() => _enCurso = null);
  }

  Future<int> _importar() async {
    final pendientes = await fuente.leerPendientes();
    if (pendientes.isEmpty) return 0;

    final reglas = await categorias.obtenerReglas();
    // Varias compras suelen venir de la misma tarjeta: se busca una vez.
    final cuentaPorNombre = <String, Cuenta>{};
    final nuevas = <Compra>[];
    for (final p in pendientes) {
      final cuenta = cuentaPorNombre[p.tarjeta] ??= await cuentas
          .cuentaParaNombreRecibido(p.tarjeta);
      nuevas.add(
        Compra(
          id: p.id,
          comercio: p.comercio,
          montoCentavos: p.montoCentavos,
          tarjeta: cuenta.nombre,
          cuentaId: cuenta.id,
          categoriaId: asignarCategoria(p.comercio, reglas),
          fecha: p.fecha,
          origen: OrigenCompra.applePay,
        ),
      );
    }
    final insertadas = await compras.importar(nuevas);
    // Solo se limpian después de guardar: si algo falla antes, las compras
    // siguen pendientes y se reintentan la próxima vez.
    await fuente.marcarImportadas({for (final p in pendientes) p.id});
    return insertadas;
  }
}
