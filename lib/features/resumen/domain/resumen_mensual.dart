import '../../../core/format/formato.dart';
import '../../compras/domain/compra.dart';

/// Lo gastado en una categoría durante el mes. [categoriaId] null = compras
/// sin categoría.
class GastoCategoria {
  const GastoCategoria({
    required this.categoriaId,
    required this.totalCentavos,
    this.presupuestoCentavos,
  });

  final int? categoriaId;
  final int totalCentavos;
  final int? presupuestoCentavos;

  /// Fracción del presupuesto usada (1.0 = justo en el límite), o null si la
  /// categoría no tiene presupuesto.
  double? get avance {
    final p = presupuestoCentavos;
    return p == null || p <= 0 ? null : totalCentavos / p;
  }
}

class GastoTarjeta {
  const GastoTarjeta({required this.tarjeta, required this.totalCentavos});

  final String tarjeta;
  final int totalCentavos;
}

class ResumenMensual {
  const ResumenMensual({
    required this.mes,
    required this.totalCentavos,
    required this.cantidadCompras,
    required this.totalMesAnteriorCentavos,
    required this.presupuestoTotalCentavos,
    required this.porCategoria,
    required this.porTarjeta,
    required this.porDiaCentavos,
  });

  final DateTime mes;
  final int totalCentavos;
  final int cantidadCompras;
  final int totalMesAnteriorCentavos;

  /// Suma de todos los presupuestos, o null si no hay ninguno.
  final int? presupuestoTotalCentavos;

  /// Lo gastado solo en categorías con presupuesto: es lo que se compara
  /// contra [presupuestoTotalCentavos] (comparar el gasto total sería
  /// injusto si solo algunas categorías tienen presupuesto).
  int get gastadoConPresupuestoCentavos => porCategoria
      .where((g) => g.presupuestoCentavos != null)
      .fold(0, (total, g) => total + g.totalCentavos);

  /// De mayor a menor gasto. Incluye las categorías con presupuesto aunque
  /// no tengan gasto, para ver cuánto queda disponible.
  final List<GastoCategoria> porCategoria;
  final List<GastoTarjeta> porTarjeta;

  /// Un elemento por día del mes: `porDiaCentavos[0]` es el día 1.
  final List<int> porDiaCentavos;
}

/// Calcula el resumen de [mes] a partir de todas las compras. Se hace en
/// memoria y no con SQL porque, para una persona, son unos pocos miles de
/// filas como mucho, y así la lógica es una función pura fácil de probar.
ResumenMensual calcularResumen({
  required List<Compra> compras,
  required DateTime mes,
  required Map<int, int> presupuestos,
}) {
  final inicio = inicioMes(mes);
  final anterior = sumarMeses(inicio, -1);
  bool enMes(Compra c, DateTime m) =>
      c.fecha.year == m.year && c.fecha.month == m.month;

  final delMes = compras.where((c) => enMes(c, inicio)).toList();
  final totalAnterior = compras
      .where((c) => enMes(c, anterior))
      .fold(0, (total, c) => total + c.montoCentavos);

  final porCategoria = <int?, int>{
    // Las categorías con presupuesto aparecen aunque no tengan gasto.
    for (final id in presupuestos.keys) id: 0,
  };
  final porTarjeta = <String, int>{};
  final porDia = List.filled(diasDelMes(inicio), 0);
  var total = 0;

  for (final c in delMes) {
    total += c.montoCentavos;
    porCategoria[c.categoriaId] =
        (porCategoria[c.categoriaId] ?? 0) + c.montoCentavos;
    porTarjeta[c.tarjeta] = (porTarjeta[c.tarjeta] ?? 0) + c.montoCentavos;
    porDia[c.fecha.day - 1] += c.montoCentavos;
  }

  return ResumenMensual(
    mes: inicio,
    totalCentavos: total,
    cantidadCompras: delMes.length,
    totalMesAnteriorCentavos: totalAnterior,
    presupuestoTotalCentavos: presupuestos.isEmpty
        ? null
        : presupuestos.values.fold<int>(0, (a, b) => a + b),
    porCategoria: [
      for (final MapEntry(key: id, value: gasto) in porCategoria.entries)
        GastoCategoria(
          categoriaId: id,
          totalCentavos: gasto,
          presupuestoCentavos: presupuestos[id],
        ),
    ]..sort((a, b) => b.totalCentavos.compareTo(a.totalCentavos)),
    porTarjeta: [
      for (final MapEntry(key: tarjeta, value: gasto) in porTarjeta.entries)
        GastoTarjeta(tarjeta: tarjeta, totalCentavos: gasto),
    ]..sort((a, b) => b.totalCentavos.compareTo(a.totalCentavos)),
    porDiaCentavos: porDia,
  );
}
