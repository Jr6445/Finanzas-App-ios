import 'package:csv/csv.dart';
import 'package:finanzas/features/categorias/domain/categoria.dart';
import 'package:finanzas/features/categorias/domain/regla_categoria.dart';
import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:finanzas/features/exportar/domain/csv_exportacion.dart';
import 'package:flutter_test/flutter_test.dart';

const _cafe = Categoria(id: 3, nombre: 'Café', icono: 'cafe', color: 'cafe');

void main() {
  test('exporta compras con BOM, escapando comas y comillas', () {
    final texto = comprasACsv(
      [
        Compra(
          id: 'b',
          comercio: 'Café "El Volcán", Santa Tecla',
          montoCentavos: 123456,
          tarjeta: 'Visa',
          categoriaId: 3,
          fecha: DateTime(2026, 10, 24, 9, 5),
          origen: OrigenCompra.applePay,
        ),
        Compra(
          id: 'a',
          comercio: 'Uber',
          montoCentavos: 350,
          tarjeta: 'Efectivo',
          categoriaId: null,
          fecha: DateTime(2026, 10, 1),
          origen: OrigenCompra.manual,
        ),
      ],
      {3: _cafe},
    );

    expect(texto.codeUnitAt(0), 0xFEFF); // BOM UTF-8
    final filas = Csv().decode(texto.substring(1));
    expect(filas[0], [
      'Fecha',
      'Comercio',
      'Monto',
      'Tarjeta',
      'Categoría',
      'Origen',
      'Id',
    ]);
    // Ordenadas de la más antigua a la más reciente.
    expect(filas[1], [
      '2026-10-01 00:00',
      'Uber',
      '3.50',
      'Efectivo',
      '',
      'Manual',
      'a',
    ]);
    expect(filas[2][1], 'Café "El Volcán", Santa Tecla');
    expect(filas[2][2], '1234.56');
    expect(filas[2][5], 'Apple Pay');
  });

  test('exporta categorías con presupuesto y reglas', () {
    final texto = categoriasACsv(
      [_cafe],
      const [
        ReglaCategoria(id: 1, patron: 'starbucks', categoriaId: 3),
        ReglaCategoria(id: 2, patron: 'coffee', categoriaId: 3),
        ReglaCategoria(id: 3, patron: 'otro', categoriaId: 9),
      ],
      const {3: 4000},
    );
    final filas = Csv().decode(texto.substring(1));
    expect(filas[1], ['Café', 'cafe', 'cafe', '40.00', 'starbucks | coffee']);
  });
}
