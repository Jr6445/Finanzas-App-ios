import 'package:csv/csv.dart';
import 'package:finanzas/features/categorias/domain/categoria.dart';
import 'package:finanzas/features/categorias/domain/regla_categoria.dart';
import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:finanzas/features/cuentas/domain/cuenta.dart';
import 'package:finanzas/features/cuentas/domain/movimiento.dart';
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

  test('exporta movimientos con nombres de cuenta y ajustes negativos', () {
    final cuentas = {
      1: Cuenta(
        id: 1,
        nombre: 'Débito',
        tipo: TipoCuenta.debito,
        color: 'verde',
        fechaSaldoInicial: DateTime(2026),
      ),
      2: Cuenta(
        id: 2,
        nombre: 'Crédito',
        tipo: TipoCuenta.credito,
        color: 'azul',
        fechaSaldoInicial: DateTime(2026),
      ),
    };
    final texto = movimientosACsv([
      Movimiento(
        id: 'aj',
        tipo: TipoMovimiento.ajuste,
        cuentaDestinoId: 1,
        montoCentavos: -50,
        fecha: DateTime(2026, 10, 3),
      ),
      Movimiento(
        id: 'pago',
        tipo: TipoMovimiento.transferencia,
        cuentaOrigenId: 1,
        cuentaDestinoId: 2,
        montoCentavos: 15000,
        fecha: DateTime(2026, 10, 2),
        nota: 'Abono',
      ),
    ], cuentas);

    final filas = Csv().decode(texto.substring(1));
    expect(filas[1], [
      '2026-10-02 00:00',
      'Transferencia',
      'Débito',
      'Crédito',
      '150.00',
      'Abono',
      'pago',
    ]);
    // −$0.50 no debe perder el signo.
    expect(filas[2][4], '-0.50');
  });
}
