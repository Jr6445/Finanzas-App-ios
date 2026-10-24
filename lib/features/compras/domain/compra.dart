/// De dónde vino la compra.
enum OrigenCompra { applePay, manual }

/// Una compra ya registrada en la app.
///
/// Es inmutable (todos los campos `final`), como un `record` de C#. Para
/// editarla, el formulario crea una nueva con el mismo [id].
class Compra {
  const Compra({
    required this.id,
    required this.comercio,
    required this.montoCentavos,
    required this.tarjeta,
    required this.categoriaId,
    required this.fecha,
    required this.origen,
  });

  /// Para compras de Apple Pay es el id que generó el App Intent; así, si la
  /// misma compra se importa dos veces, se detecta como duplicada.
  final String id;
  final String comercio;
  final int montoCentavos;
  final String tarjeta;

  /// Null = sin categoría.
  final int? categoriaId;
  final DateTime fecha;
  final OrigenCompra origen;
}
