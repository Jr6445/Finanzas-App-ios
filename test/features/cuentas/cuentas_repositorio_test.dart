import 'package:drift/native.dart';
import 'package:finanzas/core/db/base_datos.dart';
import 'package:finanzas/features/compras/data/compras_repositorio.dart';
import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:finanzas/features/cuentas/data/cuentas_repositorio.dart';
import 'package:finanzas/features/cuentas/domain/cuenta.dart';
import 'package:finanzas/features/cuentas/domain/movimiento.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late BaseDatos db;
  late CuentasRepositorio cuentas;
  late ComprasRepositorio compras;

  setUp(() {
    db = BaseDatos(NativeDatabase.memory());
    cuentas = CuentasRepositorio(db);
    compras = ComprasRepositorio(db);
  });
  tearDown(() => db.close());

  Cuenta nueva(String nombre, TipoCuenta tipo) => Cuenta(
    id: 0,
    nombre: nombre,
    tipo: tipo,
    color: 'azul',
    fechaSaldoInicial: DateTime(2026),
  );

  test('renombrar la cuenta actualiza el nombre en sus compras', () async {
    final id = await cuentas.guardarCuenta(nueva('Visa', TipoCuenta.debito));
    await compras.guardar(
      Compra(
        id: 'a',
        comercio: 'Uber',
        montoCentavos: 500,
        tarjeta: 'Visa',
        cuentaId: id,
        categoriaId: null,
        fecha: DateTime(2026, 10, 1),
        origen: OrigenCompra.manual,
      ),
    );

    final cuenta = (await cuentas.obtenerCuentas()).single;
    await cuentas.guardarCuenta(cuenta.copyWith(nombre: 'Visa Agrícola'));

    expect(
      (await compras.observarTodas().first).single.tarjeta,
      'Visa Agrícola',
    );
  });

  test('guarda nombres alternativos y datos de crédito', () async {
    await cuentas.guardarCuenta(
      nueva('MC', TipoCuenta.credito).copyWith(
        alias: ['Mastercard ••1234', 'MC Cuscatlán'],
        limiteCentavos: () => 100000,
        diaCorte: () => 15,
        diaPago: () => 5,
        diasRecordatorio: 2,
      ),
    );
    final c = (await cuentas.obtenerCuentas()).single;
    expect(c.alias, ['Mastercard ••1234', 'MC Cuscatlán']);
    expect((c.limiteCentavos, c.diaCorte, c.diaPago), (100000, 15, 5));
    expect(c.diasRecordatorio, 2);
  });

  test('borrar una cuenta conserva sus compras y la transferencia sigue '
      'contando en la otra cuenta', () async {
    final debito = await cuentas.guardarCuenta(
      nueva('Débito', TipoCuenta.debito),
    );
    final credito = await cuentas.guardarCuenta(
      nueva('Crédito', TipoCuenta.credito),
    );
    await compras.guardar(
      Compra(
        id: 'a',
        comercio: 'X',
        montoCentavos: 100,
        tarjeta: 'Débito',
        cuentaId: debito,
        categoriaId: null,
        fecha: DateTime(2026, 10, 1),
        origen: OrigenCompra.manual,
      ),
    );
    await cuentas.guardarMovimiento(
      Movimiento(
        id: 'pago',
        tipo: TipoMovimiento.transferencia,
        cuentaOrigenId: debito,
        cuentaDestinoId: credito,
        montoCentavos: 5000,
        fecha: DateTime(2026, 10, 2),
      ),
    );

    await cuentas.borrarCuenta(debito);

    final compra = (await compras.observarTodas().first).single;
    expect(compra.cuentaId, isNull);
    expect(compra.tarjeta, 'Débito');
    final pago = (await cuentas.observarMovimientos().first).single;
    expect(pago.cuentaOrigenId, isNull);
    expect(pago.cuentaDestinoId, credito);
  });

  test('migración v2 -> v3: crea una cuenta por tarjeta y asocia las '
      'compras', () async {
    // Una base como la de la fase 3 (esquema copiado de una base v2 real).
    final v2 = BaseDatos(
      NativeDatabase.memory(
        setup: (Database raw) {
          raw.execute('''
            CREATE TABLE "categorias" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "nombre" TEXT NOT NULL UNIQUE, "icono" TEXT NOT NULL, "color" TEXT NOT NULL);
            CREATE TABLE "reglas" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "patron" TEXT NOT NULL, "categoria_id" INTEGER NOT NULL REFERENCES categorias (id) ON DELETE CASCADE);
            CREATE TABLE "compras" ("id" TEXT NOT NULL, "comercio" TEXT NOT NULL, "monto_centavos" INTEGER NOT NULL, "tarjeta" TEXT NOT NULL, "categoria_id" INTEGER NULL REFERENCES categorias (id) ON DELETE SET NULL, "fecha" INTEGER NOT NULL, "origen" INTEGER NOT NULL, PRIMARY KEY ("id"));
            CREATE TABLE "presupuestos" ("categoria_id" INTEGER NOT NULL REFERENCES categorias (id) ON DELETE CASCADE, "monto_centavos" INTEGER NOT NULL, PRIMARY KEY ("categoria_id"));
            INSERT INTO compras VALUES ('a', 'Super', 1000, 'Visa Agrícola', NULL, 1790000000, 0);
            INSERT INTO compras VALUES ('b', 'Uber', 500, 'Visa Agrícola', NULL, 1790000100, 0);
            INSERT INTO compras VALUES ('c', 'Siman', 9000, 'Mastercard', NULL, 1790000200, 1);
            PRAGMA user_version = 2;
          ''');
        },
      ),
    );
    addTearDown(v2.close);

    final lista = await CuentasRepositorio(v2).obtenerCuentas();
    expect(lista.map((c) => c.nombre).toSet(), {'Visa Agrícola', 'Mastercard'});
    expect(lista.every((c) => c.tipo == TipoCuenta.sinConfigurar), isTrue);

    final porNombre = {for (final c in lista) c.nombre: c.id};
    final migradas = await ComprasRepositorio(v2).observarTodas().first;
    expect(migradas, hasLength(3));
    for (final c in migradas) {
      expect(c.cuentaId, porNombre[c.tarjeta]);
    }
    final version = await v2.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 3);
  });
}
