/// Se guarda en la base como número: NO cambies el orden; agrega al final.
enum TipoMovimiento {
  /// Entra dinero de fuera (salario, transferencia de otra persona...).
  deposito,

  /// Pasa dinero entre tus cuentas: pagar la tarjeta de crédito desde la
  /// débito, retirar efectivo...
  transferencia,

  /// Corrige el saldo (o la deuda) para que coincida con el banco.
  ajuste,
}

/// Todo lo que mueve dinero y no es una compra. Las transferencias no son
/// gasto: el gasto ya se contó cuando se hizo la compra.
class Movimiento {
  const Movimiento({
    required this.id,
    required this.tipo,
    this.cuentaOrigenId,
    this.cuentaDestinoId,
    required this.montoCentavos,
    required this.fecha,
    this.nota = '',
  });

  final String id;
  final TipoMovimiento tipo;

  /// Solo en transferencias: la cuenta de donde sale el dinero.
  final int? cuentaOrigenId;

  /// La cuenta que recibe el depósito, la transferencia o el ajuste.
  final int? cuentaDestinoId;

  /// Siempre positivo, salvo en ajustes: ahí es cuánto cambia el saldo (o la
  /// deuda) y puede ser negativo.
  final int montoCentavos;
  final DateTime fecha;
  final String nota;
}
