import 'package:drift/native.dart';
import 'package:finanzas/core/db/base_datos.dart';
import 'package:finanzas/features/categorias/data/categorias_repositorio.dart';
import 'package:finanzas/features/presupuestos/data/presupuestos_repositorio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BaseDatos db;
  late PresupuestosRepositorio presupuestos;
  late CategoriasRepositorio categorias;

  setUp(() {
    db = BaseDatos(NativeDatabase.memory());
    presupuestos = PresupuestosRepositorio(db);
    categorias = CategoriasRepositorio(db);
  });
  tearDown(() => db.close());

  test('fijar, cambiar y quitar un presupuesto', () async {
    final id = (await categorias.observarCategorias().first).first.id;

    await presupuestos.fijar(id, 10000);
    await presupuestos.fijar(id, 15000);
    expect(await presupuestos.observar().first, {id: 15000});

    await presupuestos.quitar(id);
    expect(await presupuestos.observar().first, isEmpty);
  });

  test('se borra junto con su categoría', () async {
    final id = (await categorias.observarCategorias().first).first.id;
    await presupuestos.fijar(id, 10000);

    await categorias.borrarCategoria(id);

    expect(await presupuestos.observar().first, isEmpty);
  });
}
