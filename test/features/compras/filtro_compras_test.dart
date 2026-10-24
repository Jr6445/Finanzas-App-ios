import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:finanzas/features/compras/domain/filtro_compras.dart';
import 'package:flutter_test/flutter_test.dart';

Compra _compra(
  String id,
  DateTime fecha, {
  int? categoriaId,
  String? tarjeta,
}) => Compra(
  id: id,
  comercio: 'X',
  montoCentavos: 100,
  tarjeta: tarjeta ?? 'Visa',
  categoriaId: categoriaId,
  fecha: fecha,
  origen: OrigenCompra.manual,
);

void main() {
  final compras = [
    _compra('a', DateTime(2026, 10, 3), categoriaId: 1),
    _compra('b', DateTime(2026, 10, 9), categoriaId: 2, tarjeta: 'MC'),
    _compra('c', DateTime(2026, 10, 20)),
    _compra('d', DateTime(2026, 9, 30), categoriaId: 1),
  ];
  final octubre = DateTime(2026, 10);

  test('por categoría solo del mes', () {
    final r = comprasDelMes(compras, octubre, const FiltroCategoria(1));
    expect(r.map((c) => c.id), ['a']);
  });

  test('"Sin categoría" es el filtro con id null', () {
    final r = comprasDelMes(compras, octubre, const FiltroCategoria(null));
    expect(r.map((c) => c.id), ['c']);
  });

  test('por tarjeta', () {
    expect(
      comprasDelMes(
        compras,
        octubre,
        const FiltroTarjeta('Visa'),
      ).map((c) => c.id),
      ['a', 'c'],
    );
    expect(
      comprasDelMes(
        compras,
        octubre,
        const FiltroTarjeta('MC'),
      ).map((c) => c.id),
      ['b'],
    );
  });
}
