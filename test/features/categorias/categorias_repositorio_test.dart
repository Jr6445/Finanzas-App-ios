import 'package:drift/native.dart';
import 'package:finanzas/core/db/base_datos.dart';
import 'package:finanzas/features/categorias/data/categorias_repositorio.dart';
import 'package:finanzas/features/compras/data/compras_repositorio.dart';
import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BaseDatos db;
  late ComprasRepositorio compras;
  late CategoriasRepositorio categorias;

  setUp(() {
    db = BaseDatos(NativeDatabase.memory());
    compras = ComprasRepositorio(db);
    categorias = CategoriasRepositorio(db);
  });
  tearDown(() => db.close());

  Compra compra(String id, String comercio, int? categoriaId) => Compra(
    id: id,
    comercio: comercio,
    montoCentavos: 500,
    tarjeta: 'Visa',
    categoriaId: categoriaId,
    fecha: DateTime(2026, 10, 24),
    origen: OrigenCompra.manual,
  );

  test('arranca con categorías y reglas de ejemplo', () async {
    expect(await categorias.observarCategorias().first, hasLength(10));
    expect(await categorias.obtenerReglas(), isNotEmpty);
  });

  test('borrar una categoría deja sus compras sin categoría y borra sus '
      'reglas', () async {
    final cafe = (await categorias.observarCategorias().first).firstWhere(
      (c) => c.nombre == 'Café',
    );
    await compras.guardar(compra('1', 'Starbucks', cafe.id));

    await categorias.borrarCategoria(cafe.id);

    expect((await compras.observarTodas().first).single.categoriaId, isNull);
    final reglas = await categorias.obtenerReglas();
    expect(reglas.where((r) => r.categoriaId == cafe.id), isEmpty);
  });

  test('una regla nueva categoriza solo las compras sin categoría', () async {
    final lista = await categorias.observarCategorias().first;
    final tiendas = lista.firstWhere((c) => c.nombre == 'Tiendas');
    final otros = lista.firstWhere((c) => c.nombre == 'Otros');
    await compras.guardar(compra('1', 'Ferretería Vidrí', null));
    await compras.guardar(compra('2', 'Vidrí Soyapango', otros.id));

    await categorias.guardarRegla(patron: 'vidri', categoriaId: tiendas.id);
    final n = await compras.categorizarSinCategoria(
      await categorias.obtenerReglas(),
    );

    expect(n, 1);
    final porId = {
      for (final c in await compras.observarTodas().first) c.id: c,
    };
    expect(porId['1']!.categoriaId, tiendas.id);
    expect(porId['2']!.categoriaId, otros.id); // la elegida a mano no cambia
  });

  test('guardar con el mismo id actualiza en lugar de duplicar', () async {
    await compras.guardar(compra('1', 'Uber', null));
    await compras.guardar(compra('1', 'Uber Eats', null));

    final todas = await compras.observarTodas().first;
    expect(todas.single.comercio, 'Uber Eats');
  });
}
