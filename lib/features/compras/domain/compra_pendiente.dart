/// Una compra recibida de fuera de la app (App Intent de Atajos o la fuente
/// fake) que todavía no se ha importado. Aún no tiene categoría: se le asigna
/// al importarla, según las reglas.
class CompraPendiente {
  const CompraPendiente({
    required this.id,
    required this.comercio,
    required this.montoCentavos,
    required this.tarjeta,
    required this.fecha,
  });

  final String id;
  final String comercio;
  final int montoCentavos;
  final String tarjeta;
  final DateTime fecha;
}
