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
    this.cuentaId,
  });

  /// Para compras de Apple Pay es el id que generó el App Intent; así, si la
  /// misma compra se importa dos veces, se detecta como duplicada.
  final String id;
  final String comercio;
  final int montoCentavos;

  /// Nombre de la cuenta. Se guarda copiado (y se actualiza si renombras la
  /// cuenta) para que el Resumen y los filtros no necesiten la tabla de
  /// cuentas.
  final String tarjeta;

  /// Cuenta con la que se pagó; null en compras de una cuenta borrada.
  final int? cuentaId;

  /// Null = sin categoría.
  final int? categoriaId;
  final DateTime fecha;
  final OrigenCompra origen;
}
