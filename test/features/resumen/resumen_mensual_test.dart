import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:finanzas/features/resumen/domain/resumen_mensual.dart';
import 'package:flutter_test/flutter_test.dart';

Compra _compra(
  DateTime fecha,
  int centavos, {
  int? categoriaId,
  String tarjeta = 'Visa',
}) => Compra(
  id: '$fecha-$centavos',
  comercio: 'X',
  montoCentavos: centavos,
  tarjeta: tarjeta,
  categoriaId: categoriaId,
  fecha: fecha,
  origen: OrigenCompra.manual,
);

void main() {
  final compras = [
    _compra(DateTime(2026, 9, 30, 23), 5000, categoriaId: 1),
    _compra(DateTime(2026, 10, 1, 8), 1000, categoriaId: 1),
    _compra(DateTime(2026, 10, 1, 20), 2500, categoriaId: 2, tarjeta: 'MC'),
    _compra(DateTime(2026, 10, 31, 23, 59), 300),
    _compra(DateTime(2026, 11, 1), 9900, categoriaId: 1),
  ];

  test('solo cuenta las compras del mes', () {
    final r = calcularResumen(
      compras: compras,
      mes: DateTime(2026, 10, 15),
      presupuestos: const {},
    );

    expect(r.mes, DateTime(2026, 10));
    expect(r.totalCentavos, 3800);
    expect(r.cantidadCompras, 3);
    expect(r.totalMesAnteriorCentavos, 5000);
    expect(r.presupuestoTotalCentavos, isNull);
    expect(r.porDiaCentavos, hasLength(31));
    expect(r.porDiaCentavos[0], 3500);
    expect(r.porDiaCentavos[30], 300);
  });

  test('agrupa por categoría y por tarjeta, de mayor a menor', () {
    final r = calcularResumen(
      compras: compras,
      mes: DateTime(2026, 10),
      presupuestos: const {},
    );

    expect(r.porCategoria.map((g) => (g.categoriaId, g.totalCentavos)), [
      (2, 2500),
      (1, 1000),
      (null, 300),
    ]);
    expect(r.porTarjeta.map((t) => (t.tarjeta, t.totalCentavos)), [
      ('MC', 2500),
      ('Visa', 1300),
    ]);
  });

  test('incluye categorías con presupuesto aunque no tengan gasto', () {
    final r = calcularResumen(
      compras: compras,
      mes: DateTime(2026, 10),
      presupuestos: const {1: 2000, 7: 10000},
    );

    final porId = {for (final g in r.porCategoria) g.categoriaId: g};
    expect(porId[1]!.avance, 0.5);
    expect(porId[7]!.totalCentavos, 0);
    expect(porId[7]!.avance, 0);
    expect(porId[2]!.avance, isNull);
    expect(r.presupuestoTotalCentavos, 12000);
    // Solo cuenta el gasto de las categorías 1 y 7, no el de la 2 ni el
    // de las compras sin categoría.
    expect(r.gastadoConPresupuestoCentavos, 1000);
  });

  test('mes sin compras', () {
    final r = calcularResumen(
      compras: compras,
      mes: DateTime(2026, 2),
      presupuestos: const {},
    );
    expect(r.totalCentavos, 0);
    expect(r.porCategoria, isEmpty);
    expect(r.porDiaCentavos, hasLength(28));
  });
}
