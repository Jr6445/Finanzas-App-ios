import 'package:drift/drift.dart';

import '../../../core/db/base_datos.dart';

/// Presupuestos mensuales: categoriaId -> monto en centavos.
class PresupuestosRepositorio {
  PresupuestosRepositorio(this._db);

  final BaseDatos _db;

  Stream<Map<int, int>> observar() => _db
      .select(_db.presupuestos)
      .watch()
      .map((filas) => {for (final f in filas) f.categoriaId: f.montoCentavos});

  Future<void> fijar(int categoriaId, int montoCentavos) => _db
      .into(_db.presupuestos)
      .insertOnConflictUpdate(
        // categoriaId va en Value(...) porque drift trata una llave primaria
        // INTEGER como el "rowid" de SQLite, que podría autogenerarse.
        PresupuestosCompanion.insert(
          categoriaId: Value(categoriaId),
          montoCentavos: montoCentavos,
        ),
      );

  Future<void> quitar(int categoriaId) => (_db.delete(
    _db.presupuestos,
  )..where((p) => p.categoriaId.equals(categoriaId))).go();
}
