import 'package:drift/drift.dart';

import '../../features/compras/domain/compra.dart';
import '../../features/cuentas/domain/cuenta.dart';
import '../../features/cuentas/domain/movimiento.dart';

// Cada clase describe una tabla, como una entidad con Fluent API en EF Core.
// drift genera a partir de ellas las consultas tipadas y una clase de fila
// por tabla. @DataClassName pone a esas filas un nombre que no choque con los
// modelos de dominio (Compra, Categoria...).

@DataClassName('CategoriaFila')
class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();

  /// Clave del ícono y del color (ver estilo_categoria.dart). Se guarda una
  /// clave y no el código del ícono para que Flutter pueda eliminar del
  /// .ipa los íconos que no se usan ("tree shaking").
  TextColumn get icono => text()();
  TextColumn get color => text()();
}

@DataClassName('ReglaFila')
class Reglas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patron => text()();
  IntColumn get categoriaId =>
      integer().references(Categorias, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('CompraFila')
class Compras extends Table {
  TextColumn get id => text()();
  TextColumn get comercio => text()();
  IntColumn get montoCentavos => integer()();
  TextColumn get tarjeta => text()();

  /// Null = sin categoría (ninguna regla coincidió o se borró la categoría).
  IntColumn get categoriaId => integer().nullable().references(
    Categorias,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get fecha => dateTime()();
  IntColumn get origen => intEnum<OrigenCompra>()();

  /// v3. Null si se borró la cuenta (la compra conserva el nombre en
  /// [tarjeta]).
  IntColumn get cuentaId => integer().nullable().references(
    Cuentas,
    #id,
    onDelete: KeyAction.setNull,
  )();

  @override
  Set<Column> get primaryKey => {id};
}

/// Presupuesto mensual de una categoría; se repite igual cada mes. Una
/// categoría sin fila aquí no tiene presupuesto.
@DataClassName('PresupuestoFila')
class Presupuestos extends Table {
  IntColumn get categoriaId =>
      integer().references(Categorias, #id, onDelete: KeyAction.cascade)();
  IntColumn get montoCentavos => integer()();

  @override
  Set<Column> get primaryKey => {categoriaId};
}

/// v3. Cuentas y tarjetas (ver features/cuentas/domain/cuenta.dart).
@DataClassName('CuentaFila')
class Cuentas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();
  IntColumn get tipo => intEnum<TipoCuenta>()();
  TextColumn get color => text()();

  /// Nombres alternativos, uno por línea.
  TextColumn get alias => text().withDefault(const Constant(''))();
  IntColumn get saldoInicialCentavos =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get fechaSaldoInicial => dateTime()();
  IntColumn get limiteCentavos => integer().nullable()();
  IntColumn get diaCorte => integer().nullable()();
  IntColumn get diaPago => integer().nullable()();
  IntColumn get diasRecordatorio => integer().withDefault(const Constant(3))();
}

/// v3. Depósitos, transferencias y ajustes.
@DataClassName('MovimientoFila')
class Movimientos extends Table {
  TextColumn get id => text()();
  IntColumn get tipo => intEnum<TipoMovimiento>()();

  // SET NULL y no CASCADE: si borras la débito, el pago que hiciste desde
  // ella a la crédito debe seguir bajando la deuda de la crédito.
  IntColumn get cuentaOrigenId => integer().nullable().references(
    Cuentas,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get cuentaDestinoId => integer().nullable().references(
    Cuentas,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get montoCentavos => integer()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get nota => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
