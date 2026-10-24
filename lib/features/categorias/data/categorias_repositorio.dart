import 'package:drift/drift.dart';

import '../../../core/db/base_datos.dart';
import '../domain/categoria.dart';
import '../domain/regla_categoria.dart';

/// Acceso a categorías y reglas automáticas.
class CategoriasRepositorio {
  CategoriasRepositorio(this._db);

  final BaseDatos _db;

  Stream<List<Categoria>> observarCategorias() {
    final consulta = _db.select(_db.categorias)
      ..orderBy([(c) => OrderingTerm.asc(c.nombre)]);
    return consulta.watch().map((filas) => filas.map(_aCategoria).toList());
  }

  /// Crea la categoría si [id] es null; si no, la actualiza.
  Future<void> guardarCategoria({
    int? id,
    required String nombre,
    required String icono,
    required String color,
  }) async {
    final datos = CategoriasCompanion(
      nombre: Value(nombre),
      icono: Value(icono),
      color: Value(color),
    );
    if (id == null) {
      await _db.into(_db.categorias).insert(datos);
    } else {
      await (_db.update(
        _db.categorias,
      )..where((c) => c.id.equals(id))).write(datos);
    }
  }

  /// Las compras de la categoría quedan sin categoría y sus reglas se borran
  /// (lo hacen las llaves foráneas: ON DELETE SET NULL / CASCADE).
  Future<void> borrarCategoria(int id) =>
      (_db.delete(_db.categorias)..where((c) => c.id.equals(id))).go();

  Stream<List<ReglaCategoria>> observarReglas() {
    final consulta = _db.select(_db.reglas)
      ..orderBy([(r) => OrderingTerm.asc(r.patron)]);
    return consulta.watch().map((filas) => filas.map(_aRegla).toList());
  }

  Future<List<ReglaCategoria>> obtenerReglas() async =>
      (await _db.select(_db.reglas).get()).map(_aRegla).toList();

  Future<void> guardarRegla({
    int? id,
    required String patron,
    required int categoriaId,
  }) async {
    final datos = ReglasCompanion(
      patron: Value(patron),
      categoriaId: Value(categoriaId),
    );
    if (id == null) {
      await _db.into(_db.reglas).insert(datos);
    } else {
      await (_db.update(
        _db.reglas,
      )..where((r) => r.id.equals(id))).write(datos);
    }
  }

  Future<void> borrarRegla(int id) =>
      (_db.delete(_db.reglas)..where((r) => r.id.equals(id))).go();

  static Categoria _aCategoria(CategoriaFila f) =>
      Categoria(id: f.id, nombre: f.nombre, icono: f.icono, color: f.color);

  static ReglaCategoria _aRegla(ReglaFila f) =>
      ReglaCategoria(id: f.id, patron: f.patron, categoriaId: f.categoriaId);
}
