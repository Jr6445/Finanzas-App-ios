import '../../../core/format/formato.dart';
import 'compra.dart';

/// Las compras de un mismo día, para mostrarlas como una sección.
class GrupoDia {
  const GrupoDia({required this.dia, required this.compras});

  final DateTime dia;
  final List<Compra> compras;

  int get totalCentavos =>
      compras.fold(0, (total, compra) => total + compra.montoCentavos);
}

/// Agrupa por día, con los días y las compras de cada día del más reciente
/// al más antiguo.
List<GrupoDia> agruparPorDia(List<Compra> compras) {
  final ordenadas = [...compras]..sort((a, b) => b.fecha.compareTo(a.fecha));

  final grupos = <DateTime, List<Compra>>{};
  for (final compra in ordenadas) {
    grupos.putIfAbsent(soloFecha(compra.fecha), () => []).add(compra);
  }
  // Un Map literal de Dart conserva el orden de inserción (como un
  // LinkedHashMap), así que los días ya salen ordenados.
  return [
    for (final MapEntry(key: dia, value: lista) in grupos.entries)
      GrupoDia(dia: dia, compras: lista),
  ];
}
