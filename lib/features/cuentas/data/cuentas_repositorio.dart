import 'package:drift/drift.dart';

import '../../../core/db/base_datos.dart';
import '../domain/cuenta.dart';
import '../domain/movimiento.dart';

/// Acceso a cuentas y movimientos.
class CuentasRepositorio {
  CuentasRepositorio(this._db);

  final BaseDatos _db;

  Stream<List<Cuenta>> observarCuentas() {
    final consulta = _db.select(_db.cuentas)
      ..orderBy([(c) => OrderingTerm.asc(c.nombre)]);
    return consulta.watch().map((filas) => filas.map(_aCuenta).toList());
  }

  Future<List<Cuenta>> obtenerCuentas() async =>
      (await _db.select(_db.cuentas).get()).map(_aCuenta).toList();

  /// Crea la cuenta (si `id` es 0) o la actualiza, y devuelve su id. Si
  /// cambió el nombre, lo actualiza también en sus compras.
  Future<int> guardarCuenta(Cuenta cuenta) {
    return _db.transaction(() async {
      if (cuenta.id == 0) {
        return _db.into(_db.cuentas).insert(_aCompanion(cuenta));
      }
      await (_db.update(
        _db.cuentas,
      )..where((c) => c.id.equals(cuenta.id))).write(_aCompanion(cuenta));
      await (_db.update(_db.compras)
            ..where((c) => c.cuentaId.equals(cuenta.id)))
          .write(ComprasCompanion(tarjeta: Value(cuenta.nombre)));
      return cuenta.id;
    });
  }

  /// Sus compras se conservan (sin cuenta) y sus movimientos quedan sin esta
  /// cuenta; una transferencia hacia otra cuenta sigue contando en esa otra.
  Future<void> borrarCuenta(int id) =>
      (_db.delete(_db.cuentas)..where((c) => c.id.equals(id))).go();

  /// La cuenta que corresponde al nombre que mandó Apple Pay. Si ninguna lo
  /// reconoce, crea una "Sin configurar" con ese nombre para no perder la
  /// compra.
  Future<Cuenta> cuentaParaNombreRecibido(String nombre) async {
    final existentes = await obtenerCuentas();
    for (final cuenta in existentes) {
      if (cuenta.reconoce(nombre)) return cuenta;
    }
    final nueva = Cuenta(
      id: 0,
      nombre: nombre,
      tipo: TipoCuenta.sinConfigurar,
      color: coloresCuentas[existentes.length % coloresCuentas.length],
      fechaSaldoInicial: DateTime.now(),
    );
    return nueva.copyWith(id: await guardarCuenta(nueva));
  }

  Stream<List<Movimiento>> observarMovimientos() {
    final consulta = _db.select(_db.movimientos)
      ..orderBy([(m) => OrderingTerm.desc(m.fecha)]);
    return consulta.watch().map((filas) => filas.map(_aMovimiento).toList());
  }

  Future<void> guardarMovimiento(Movimiento m) => _db
      .into(_db.movimientos)
      .insertOnConflictUpdate(
        MovimientosCompanion.insert(
          id: m.id,
          tipo: m.tipo,
          cuentaOrigenId: Value(m.cuentaOrigenId),
          cuentaDestinoId: Value(m.cuentaDestinoId),
          montoCentavos: m.montoCentavos,
          fecha: m.fecha,
          nota: Value(m.nota),
        ),
      );

  Future<void> borrarMovimiento(String id) =>
      (_db.delete(_db.movimientos)..where((m) => m.id.equals(id))).go();

  static CuentasCompanion _aCompanion(Cuenta c) => CuentasCompanion(
    nombre: Value(c.nombre),
    tipo: Value(c.tipo),
    color: Value(c.color),
    alias: Value(c.alias.join('\n')),
    saldoInicialCentavos: Value(c.saldoInicialCentavos),
    fechaSaldoInicial: Value(c.fechaSaldoInicial),
    limiteCentavos: Value(c.limiteCentavos),
    diaCorte: Value(c.diaCorte),
    diaPago: Value(c.diaPago),
    diasRecordatorio: Value(c.diasRecordatorio),
  );

  static Cuenta _aCuenta(CuentaFila f) => Cuenta(
    id: f.id,
    nombre: f.nombre,
    tipo: f.tipo,
    color: f.color,
    alias: [
      for (final a in f.alias.split('\n'))
        if (a.trim().isNotEmpty) a.trim(),
    ],
    saldoInicialCentavos: f.saldoInicialCentavos,
    fechaSaldoInicial: f.fechaSaldoInicial,
    limiteCentavos: f.limiteCentavos,
    diaCorte: f.diaCorte,
    diaPago: f.diaPago,
    diasRecordatorio: f.diasRecordatorio,
  );

  static Movimiento _aMovimiento(MovimientoFila f) => Movimiento(
    id: f.id,
    tipo: f.tipo,
    cuentaOrigenId: f.cuentaOrigenId,
    cuentaDestinoId: f.cuentaDestinoId,
    montoCentavos: f.montoCentavos,
    fecha: f.fecha,
    nota: f.nota,
  );
}
