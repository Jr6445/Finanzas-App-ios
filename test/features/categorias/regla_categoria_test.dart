import 'package:finanzas/features/categorias/domain/regla_categoria.dart';
import 'package:flutter_test/flutter_test.dart';

const _reglas = [
  ReglaCategoria(id: 1, patron: 'selectos', categoriaId: 10),
  ReglaCategoria(id: 2, patron: 'pupuseria', categoriaId: 20),
  ReglaCategoria(id: 3, patron: 'farmacia', categoriaId: 30),
  ReglaCategoria(id: 4, patron: 'Farmacia San Nicolás', categoriaId: 40),
];

void main() {
  test('ignora mayúsculas y tildes', () {
    expect(asignarCategoria('SUPER SELECTOS ESCALON', _reglas), 10);
    expect(asignarCategoria('Pupusería La Ceiba', _reglas), 20);
  });

  test('gana el patrón más largo sin importar el orden', () {
    expect(asignarCategoria('FARMACIA SAN NICOLAS 12', _reglas), 40);
    expect(asignarCategoria('Farmacias Económicas', _reglas), 30);
  });

  test('sin coincidencia devuelve null', () {
    expect(asignarCategoria('Ferretería Vidrí', _reglas), isNull);
  });
}
