import 'package:finanzas/core/format/formato.dart';
import 'package:finanzas/features/compras/domain/agrupacion.dart';
import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Compra _compra(String id, DateTime fecha, int centavos) => Compra(
  id: id,
  comercio: 'X',
  montoCentavos: centavos,
  tarjeta: 'Visa',
  categoriaId: null,
  fecha: fecha,
  origen: OrigenCompra.manual,
);

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  test('agrupa por día, del más reciente al más antiguo, con totales', () {
    final grupos = agruparPorDia([
      _compra('a', DateTime(2026, 10, 20, 9), 1000),
      _compra('b', DateTime(2026, 10, 22, 8), 250),
      _compra('c', DateTime(2026, 10, 20, 18), 499),
    ]);

    expect(grupos.map((g) => g.dia), [
      DateTime(2026, 10, 22),
      DateTime(2026, 10, 20),
    ]);
    expect(grupos[1].compras.map((c) => c.id), ['c', 'a']);
    expect(grupos[1].totalCentavos, 1499);
  });

  test('etiquetas de día y formato de monto', () {
    final ahora = DateTime(2026, 10, 24, 12);
    expect(etiquetaDia(DateTime(2026, 10, 24, 8), ahora: ahora), 'Hoy');
    expect(etiquetaDia(DateTime(2026, 10, 23), ahora: ahora), 'Ayer');
    expect(
      etiquetaDia(DateTime(2026, 10, 22), ahora: ahora),
      'Jueves 22 de octubre',
    );
    expect(
      etiquetaDia(DateTime(2025, 12, 31), ahora: ahora),
      'Miércoles 31 de diciembre de 2025',
    );
    expect(formatearMonto(123456), r'$1,234.56');
  });

  test('parsea montos escritos a mano', () {
    expect(parsearMonto('12'), 1200);
    expect(parsearMonto('12.5'), 1250);
    expect(parsearMonto('12,50'), 1250);
    expect(parsearMonto(r'$1,234.56'), 123456);
    expect(parsearMonto(' 0.99 '), 99);
    expect(parsearMonto(''), isNull);
    expect(parsearMonto('12.345'), isNull);
    expect(parsearMonto('abc'), isNull);
    expect(montoParaEditar(1205), '12.05');
  });
}
