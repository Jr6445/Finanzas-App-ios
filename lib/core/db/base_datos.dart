import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/compras/domain/compra.dart';
import 'semillas.dart';
import 'tablas.dart';

// `part` incluye el archivo que genera build_runner (como una partial class
// de C#). Se regenera con: dart run build_runner build
part 'base_datos.g.dart';

@DriftDatabase(tables: [Categorias, Reglas, Compras, Presupuestos])
class BaseDatos extends _$BaseDatos {
  /// Sin parámetro abre el archivo SQLite de la app; los tests pasan una base
  /// en memoria.
  BaseDatos([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'finanzas'));

  /// Súbelo cada vez que cambies las tablas y agrega el paso en `onUpgrade`.
  /// Como las migraciones de EF, pero escritas a mano: la app instalada en tu
  /// iPhone tiene la versión vieja y la actualiza al abrir.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _sembrar();
    },
    onUpgrade: (m, desde, hasta) async {
      // v2 (fase 3): presupuestos por categoría.
      if (desde < 2) await m.createTable(presupuestos);
    },
    // SQLite no respeta las llaves foráneas (ni el ON DELETE) si no se activa.
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );

  Future<void> _sembrar() async {
    final ids = <String, int>{};
    for (final c in categoriasIniciales) {
      ids[c.nombre] = await into(categorias).insert(
        CategoriasCompanion.insert(
          nombre: c.nombre,
          icono: c.icono,
          color: c.color,
        ),
      );
    }
    await batch((b) {
      b.insertAll(reglas, [
        for (final (patron, categoria) in reglasIniciales)
          ReglasCompanion.insert(patron: patron, categoriaId: ids[categoria]!),
      ]);
    });
  }
}

/// Una sola conexión para toda la app. En los tests se reemplaza con
/// `baseDatosProvider.overrideWithValue(BaseDatos(NativeDatabase.memory()))`.
final baseDatosProvider = Provider<BaseDatos>((ref) {
  final db = BaseDatos();
  ref.onDispose(db.close);
  return db;
});
