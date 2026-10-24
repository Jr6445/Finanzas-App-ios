import 'package:drift/drift.dart';

import '../../../core/db/base_datos.dart';
import '../../categorias/domain/regla_categoria.dart';
import '../domain/compra.dart';

/// Acceso a las compras guardadas en SQLite.
class ComprasRepositorio {
  ComprasRepositorio(this._db);

  final BaseDatos _db;

  /// Emite la lista completa cada vez que cambia la tabla (como un
  /// IObservable de .NET o un `watch` de Vue): drift vuelve a correr la
  /// consulta sola después de cada insert/update/delete.
  Stream<List<Compra>> observarTodas() {
    final consulta = _db.select(_db.compras)
      ..orderBy([(c) => OrderingTerm.desc(c.fecha)]);
    return consulta.watch().map((filas) => filas.map(_aCompra).toList());
  }

  /// Inserta las compras cuyo id todavía no existe y devuelve cuántas
  /// insertó. Una compra repetida se ignora.
  Future<int> importar(List<Compra> compras) {
    if (compras.isEmpty) return Future.value(0);
    // transaction = todo o nada, como un TransactionScope.
    return _db.transaction(() async {
      final existentes =
          await (_db.selectOnly(_db.compras)
                ..addColumns([_db.compras.id])
                ..where(_db.compras.id.isIn(compras.map((c) => c.id))))
              .map((fila) => fila.read(_db.compras.id)!)
              .get();
      final nuevas = compras.where((c) => !existentes.contains(c.id)).toList();
      await _db.batch((b) {
        b.insertAll(
          _db.compras,
          nuevas.map(_aCompanion),
          mode: InsertMode.insertOrIgnore,
        );
      });
      return nuevas.length;
    });
  }

  /// Crea la compra o, si ya existe una con el mismo id, la reemplaza.
  Future<void> guardar(Compra compra) =>
      _db.into(_db.compras).insertOnConflictUpdate(_aCompanion(compra));

  Future<void> borrar(String id) =>
      (_db.delete(_db.compras)..where((c) => c.id.equals(id))).go();

  /// Asigna categoría con las reglas a las compras que no tienen. No toca
  /// las que ya tienen categoría, para no deshacer cambios hechos a mano.
  /// Devuelve cuántas se categorizaron.
  Future<int> categorizarSinCategoria(List<ReglaCategoria> reglas) {
    return _db.transaction(() async {
      final sinCategoria = await (_db.select(
        _db.compras,
      )..where((c) => c.categoriaId.isNull())).get();
      var actualizadas = 0;
      for (final fila in sinCategoria) {
        final categoriaId = asignarCategoria(fila.comercio, reglas);
        if (categoriaId == null) continue;
        await (_db.update(_db.compras)..where((c) => c.id.equals(fila.id)))
            .write(ComprasCompanion(categoriaId: Value(categoriaId)));
        actualizadas++;
      }
      return actualizadas;
    });
  }

  static Compra _aCompra(CompraFila fila) => Compra(
    id: fila.id,
    comercio: fila.comercio,
    montoCentavos: fila.montoCentavos,
    tarjeta: fila.tarjeta,
    categoriaId: fila.categoriaId,
    fecha: fila.fecha,
    origen: fila.origen,
  );

  static ComprasCompanion _aCompanion(Compra c) => ComprasCompanion.insert(
    id: c.id,
    comercio: c.comercio,
    montoCentavos: c.montoCentavos,
    tarjeta: c.tarjeta,
    categoriaId: Value(c.categoriaId),
    fecha: c.fecha,
    origen: c.origen,
  );
}
