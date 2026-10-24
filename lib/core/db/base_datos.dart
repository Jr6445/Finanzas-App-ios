import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/compras/domain/compra.dart';
import '../../features/cuentas/domain/cuenta.dart';
import '../../features/cuentas/domain/movimiento.dart';
import 'semillas.dart';
import 'tablas.dart';

// `part` incluye el archivo que genera build_runner (como una partial class
// de C#). Se regenera con: dart run build_runner build
part 'base_datos.g.dart';

@DriftDatabase(
  tables: [Categorias, Reglas, Compras, Presupuestos, Cuentas, Movimientos],
)
class BaseDatos extends _$BaseDatos {
  /// Sin parámetro abre el archivo SQLite de la app; los tests pasan una base
  /// en memoria.
  BaseDatos([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'finanzas'));

  /// Súbelo cada vez que cambies las tablas y agrega el paso en `onUpgrade`.
  /// Como las migraciones de EF, pero escritas a mano: la app instalada en tu
  /// iPhone tiene la versión vieja y la actualiza al abrir.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _sembrar();
    },
    onUpgrade: (m, desde, hasta) async {
      // v2 (fase 3): presupuestos por categoría.
      if (desde < 2) await m.createTable(presupuestos);
      // v3 (fase 6): cuentas y movimientos.
      if (desde < 3) {
        await m.createTable(cuentas);
        await m.createTable(movimientos);
        await m.addColumn(compras, compras.cuentaId);
        await _crearCuentasDesdeCompras();
      }
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

  /// v3: una cuenta "Sin configurar" por cada tarjeta que ya aparece en las
  /// compras, y cada compra queda asociada a la suya. El saldo arranca hoy,
  /// así las compras viejas no se restan dos veces cuando el usuario escriba
  /// el saldo real.
  Future<void> _crearCuentasDesdeCompras() async {
    final consulta = selectOnly(compras, distinct: true)
      ..addColumns([compras.tarjeta]);
    final nombres = await consulta
        .map((fila) => fila.read(compras.tarjeta)!)
        .get();
    final ahora = DateTime.now();
    for (final (i, nombre) in nombres.where((n) => n.isNotEmpty).indexed) {
      final id = await into(cuentas).insert(
        CuentasCompanion.insert(
          nombre: nombre,
          tipo: TipoCuenta.sinConfigurar,
          color: coloresCuentas[i % coloresCuentas.length],
          fechaSaldoInicial: ahora,
        ),
      );
      await (update(compras)..where((c) => c.tarjeta.equals(nombre))).write(
        ComprasCompanion(cuentaId: Value(id)),
      );
    }
  }
}

/// Colores que se van asignando a las cuentas creadas automáticamente.
const coloresCuentas = [
  'azul',
  'morado',
  'verde',
  'naranja',
  'rosa',
  'turquesa',
  'indigo',
  'amarillo',
  'rojo',
  'cafe',
];

/// Una sola conexión para toda la app. En los tests se reemplaza con
/// `baseDatosProvider.overrideWithValue(BaseDatos(NativeDatabase.memory()))`.
final baseDatosProvider = Provider<BaseDatos>((ref) {
  final db = BaseDatos();
  ref.onDispose(db.close);
  return db;
});
