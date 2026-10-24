import 'dart:math';

import '../../../core/format/formato.dart';
import '../../compras/domain/compra.dart';
import 'cuenta.dart';
import 'movimiento.dart';

// Todo se calcula sobre el "valor" de la cuenta:
//   - débito / efectivo: el saldo (dinero que tienes),
//   - crédito: la deuda (dinero que debes).
// Así una compra resta en débito pero suma en crédito, y un pago (entrada de
// dinero) suma en débito pero resta en crédito.

/// Una línea del historial de la cuenta: una compra o un movimiento, con
/// cuánto cambió el valor de la cuenta.
class EntradaCuenta {
  const EntradaCuenta.compra(Compra this.compra, this.efectoCentavos)
    : movimiento = null;

  const EntradaCuenta.movimiento(
    Movimiento this.movimiento,
    this.efectoCentavos,
  ) : compra = null;

  final Compra? compra;
  final Movimiento? movimiento;

  /// Cuánto cambió el valor (saldo o deuda) de la cuenta.
  final int efectoCentavos;

  DateTime get fecha => compra?.fecha ?? movimiento!.fecha;

  String get id => compra?.id ?? movimiento!.id;
}

/// El estado de una tarjeta de crédito respecto a sus cortes.
class EstadoCredito {
  const EstadoCredito({
    required this.ultimoCorte,
    required this.proximoCorte,
    required this.fechaLimitePago,
    required this.saldoAlCorteCentavos,
    required this.abonadoDesdeCorteCentavos,
    required this.cicloActualCentavos,
  });

  final DateTime ultimoCorte;
  final DateTime proximoCorte;

  /// Hasta cuándo pagar lo del [ultimoCorte].
  final DateTime fechaLimitePago;

  /// Lo que debías al cerrar el último corte.
  final int saldoAlCorteCentavos;

  /// Pagos hechos después del último corte.
  final int abonadoDesdeCorteCentavos;

  /// Compras hechas después del último corte (entran en el próximo).
  final int cicloActualCentavos;

  /// Lo que falta pagar del último corte.
  int get pendienteCentavos =>
      max(0, saldoAlCorteCentavos - abonadoDesdeCorteCentavos);
}

class EstadoCuenta {
  const EstadoCuenta({
    required this.cuenta,
    required this.valorCentavos,
    required this.gastadoMesCentavos,
    required this.entradas,
    this.credito,
  });

  final Cuenta cuenta;

  /// Saldo (débito, efectivo) o deuda (crédito).
  final int valorCentavos;

  /// Compras de esta cuenta en el mes en curso.
  final int gastadoMesCentavos;

  /// Historial, del más reciente al más antiguo.
  final List<EntradaCuenta> entradas;

  /// Solo en crédito con día de corte y de pago configurados.
  final EstadoCredito? credito;

  /// Crédito disponible (límite − deuda), si hay límite.
  int? get disponibleCentavos {
    final limite = cuenta.limiteCentavos;
    return cuenta.esCredito && limite != null ? limite - valorCentavos : null;
  }
}

/// Calcula el estado de [cuenta] a partir de todas las compras y
/// movimientos (filtra solo los suyos).
EstadoCuenta calcularEstado({
  required Cuenta cuenta,
  required List<Compra> compras,
  required List<Movimiento> movimientos,
  required DateTime ahora,
}) {
  final entradas = <EntradaCuenta>[
    for (final c in compras)
      if (c.cuentaId == cuenta.id)
        EntradaCuenta.compra(
          c,
          cuenta.esCredito ? c.montoCentavos : -c.montoCentavos,
        ),
    for (final m in movimientos)
      if (_efectoMovimiento(cuenta, m) case final efecto?)
        EntradaCuenta.movimiento(m, efecto),
  ]..sort((a, b) => b.fecha.compareTo(a.fecha));

  final inicioMesActual = inicioMes(ahora);
  final gastadoMes = entradas
      .where((e) => e.compra != null && !e.fecha.isBefore(inicioMesActual))
      .fold(0, (t, e) => t + e.compra!.montoCentavos);

  return EstadoCuenta(
    cuenta: cuenta,
    valorCentavos: _valorAntesDe(cuenta, entradas, null),
    gastadoMesCentavos: gastadoMes,
    entradas: entradas,
    credito: _estadoCredito(cuenta, entradas, ahora),
  );
}

/// Efecto de un movimiento sobre el valor de la cuenta, o null si no la
/// toca.
int? _efectoMovimiento(Cuenta cuenta, Movimiento m) {
  // Entrar dinero sube el saldo de débito y baja la deuda de crédito.
  final entrada = cuenta.esCredito ? -m.montoCentavos : m.montoCentavos;
  return switch (m.tipo) {
    TipoMovimiento.ajuste when m.cuentaDestinoId == cuenta.id =>
      m.montoCentavos,
    TipoMovimiento.deposito when m.cuentaDestinoId == cuenta.id => entrada,
    TipoMovimiento.transferencia when m.cuentaDestinoId == cuenta.id => entrada,
    TipoMovimiento.transferencia when m.cuentaOrigenId == cuenta.id => -entrada,
    _ => null,
  };
}

/// Valor de la cuenta con lo ocurrido antes de [limite] (null = todo). Lo
/// anterior a [Cuenta.fechaSaldoInicial] no cuenta: ya estaba incluido en
/// el saldo inicial que escribió el usuario.
int _valorAntesDe(
  Cuenta cuenta,
  List<EntradaCuenta> entradas,
  DateTime? limite,
) {
  var valor = cuenta.saldoInicialCentavos;
  for (final e in entradas) {
    if (!e.fecha.isAfter(cuenta.fechaSaldoInicial)) continue;
    if (limite != null && !e.fecha.isBefore(limite)) continue;
    valor += e.efectoCentavos;
  }
  return valor;
}

EstadoCredito? _estadoCredito(
  Cuenta cuenta,
  List<EntradaCuenta> entradas,
  DateTime ahora,
) {
  final diaCorte = cuenta.diaCorte;
  final diaPago = cuenta.diaPago;
  if (!cuenta.esCredito || diaCorte == null || diaPago == null) return null;

  final ultimo = ultimoCorte(ahora, diaCorte);
  // El día del corte cuenta completo: lo que pasa a partir del día
  // siguiente ya es del ciclo nuevo.
  final finCorte = DateTime(ultimo.year, ultimo.month, ultimo.day + 1);

  var abonado = 0;
  var ciclo = 0;
  for (final e in entradas) {
    if (e.fecha.isBefore(finCorte)) continue;
    if (e.compra != null) ciclo += e.compra!.montoCentavos;
    final m = e.movimiento;
    // Pagos = dinero que entra a la tarjeta (no cuentan los ajustes).
    if (m != null && m.tipo != TipoMovimiento.ajuste && e.efectoCentavos < 0) {
      abonado -= e.efectoCentavos;
    }
  }

  return EstadoCredito(
    ultimoCorte: ultimo,
    proximoCorte: fechaConDia(ultimo.year, ultimo.month + 1, diaCorte),
    fechaLimitePago: fechaLimitePago(ultimo, diaPago),
    saldoAlCorteCentavos: _valorAntesDe(cuenta, entradas, finCorte),
    abonadoDesdeCorteCentavos: abonado,
    cicloActualCentavos: ciclo,
  );
}

/// La fecha con ese día del mes; si el mes es más corto (día 31 en
/// noviembre), el último día del mes. DateTime corrige solo los meses
/// fuera de rango (mes 13 = enero del año siguiente).
DateTime fechaConDia(int anio, int mes, int dia) {
  final primero = DateTime(anio, mes);
  return DateTime(primero.year, primero.month, min(dia, diasDelMes(primero)));
}

/// El corte más reciente que ya ocurrió (hoy cuenta si hoy es día de corte).
DateTime ultimoCorte(DateTime ahora, int diaCorte) {
  final hoy = soloFecha(ahora);
  final esteMes = fechaConDia(hoy.year, hoy.month, diaCorte);
  return esteMes.isAfter(hoy)
      ? fechaConDia(hoy.year, hoy.month - 1, diaCorte)
      : esteMes;
}

/// El día de pago que sigue al [corte]: el mismo mes si el día de pago es
/// posterior al corte (corte 5, pago 25), si no, el mes siguiente (corte 15,
/// pago 5).
DateTime fechaLimitePago(DateTime corte, int diaPago) => diaPago > corte.day
    ? fechaConDia(corte.year, corte.month, diaPago)
    : fechaConDia(corte.year, corte.month + 1, diaPago);
