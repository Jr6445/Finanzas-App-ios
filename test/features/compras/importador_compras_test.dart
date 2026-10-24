import 'package:drift/native.dart';
import 'package:finanzas/core/db/base_datos.dart';
import 'package:finanzas/features/categorias/data/categorias_repositorio.dart';
import 'package:finanzas/features/compras/application/importador_compras.dart';
import 'package:finanzas/features/compras/data/compras_repositorio.dart';
import 'package:finanzas/features/compras/data/fuente_compras.dart';
import 'package:finanzas/features/compras/data/fuente_compras_fake.dart';
import 'package:finanzas/features/compras/domain/compra_pendiente.dart';
import 'package:finanzas/features/cuentas/data/cuentas_repositorio.dart';
import 'package:finanzas/features/cuentas/domain/cuenta.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fuente que nunca limpia, para simular que la misma compra llega dos veces.
class _FuenteQueRepite implements FuenteCompras {
  @override
  Future<List<CompraPendiente>> leerPendientes() async => [
    CompraPendiente(
      id: 'abc',
      comercio: 'SUPER SELECTOS ESCALON',
      montoCentavos: 1250,
      tarjeta: 'Visa',
      fecha: DateTime(2026, 10, 24),
    ),
  ];

  @override
  Future<void> marcarImportadas(Set<String> ids) async {}
}

void main() {
  late BaseDatos db;
  late ComprasRepositorio compras;
  late CategoriasRepositorio categorias;
  late CuentasRepositorio cuentas;

  setUp(() {
    db = BaseDatos(NativeDatabase.memory());
    compras = ComprasRepositorio(db);
    categorias = CategoriasRepositorio(db);
    cuentas = CuentasRepositorio(db);
  });
  tearDown(() => db.close());

  ImportadorCompras importador(FuenteCompras fuente) => ImportadorCompras(
    fuente: fuente,
    compras: compras,
    categorias: categorias,
    cuentas: cuentas,
  );

  test('no duplica una compra importada dos veces y la categoriza', () async {
    final i = importador(_FuenteQueRepite());
    expect(await i.importarPendientes(), 1);
    expect(await i.importarPendientes(), 0);

    final guardadas = await compras.observarTodas().first;
    expect(guardadas, hasLength(1));
    final supermercado = (await categorias.observarCategorias().first)
        .firstWhere((c) => c.nombre == 'Supermercado');
    expect(guardadas.single.categoriaId, supermercado.id);
  });

  test(
    'crea una cuenta "Sin configurar" para una tarjeta desconocida',
    () async {
      await importador(_FuenteQueRepite()).importarPendientes();

      final lista = await cuentas.obtenerCuentas();
      expect(lista.single.nombre, 'Visa');
      expect(lista.single.tipo, TipoCuenta.sinConfigurar);
      final compra = (await compras.observarTodas().first).single;
      expect(compra.cuentaId, lista.single.id);
    },
  );

  test('reconoce la tarjeta por un nombre alternativo', () async {
    final id = await cuentas.guardarCuenta(
      Cuenta(
        id: 0,
        nombre: 'Visa Agrícola',
        tipo: TipoCuenta.debito,
        color: 'verde',
        alias: const ['VISA'],
        fechaSaldoInicial: DateTime(2026),
      ),
    );

    await importador(_FuenteQueRepite()).importarPendientes();

    final compra = (await compras.observarTodas().first).single;
    expect(compra.cuentaId, id);
    // Se guarda con el nombre de la cuenta, no con el que mandó Apple Pay.
    expect(compra.tarjeta, 'Visa Agrícola');
    expect(await cuentas.obtenerCuentas(), hasLength(1));
  });

  test(
    'la fuente fake se vacía tras importar y simula compras nuevas',
    () async {
      final fuente = FuenteComprasFake(cantidadInicial: 40);
      final i = importador(fuente);

      expect(await i.importarPendientes(), 40);
      expect(await fuente.leerPendientes(), isEmpty);

      fuente.simularCompraApplePay();
      expect(await i.importarPendientes(), 1);
    },
  );

  test('la fuente fake no genera compras en el futuro', () async {
    final ahora = DateTime(2026, 10, 24, 8);
    final pendientes = await FuenteComprasFake(ahora: ahora).leerPendientes();
    expect(pendientes.every((p) => !p.fecha.isAfter(ahora)), isTrue);
  });
}
