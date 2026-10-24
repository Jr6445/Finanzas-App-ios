import 'package:flutter/cupertino.dart';

import '../../../core/format/formato.dart';
import '../../../core/theme/paleta.dart';
import '../domain/cuenta.dart';
import '../domain/estado_cuenta.dart';

IconData iconoTipoCuenta(TipoCuenta tipo) => switch (tipo) {
  TipoCuenta.debito => CupertinoIcons.creditcard,
  TipoCuenta.credito => CupertinoIcons.creditcard_fill,
  TipoCuenta.efectivo => CupertinoIcons.money_dollar,
  TipoCuenta.sinConfigurar => CupertinoIcons.exclamationmark,
};

/// Ícono de la cuenta en un círculo de su color pastel.
class IconoCuenta extends StatelessWidget {
  const IconoCuenta({super.key, required this.cuenta, this.tamano = 34});

  final Cuenta? cuenta;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final c = cuenta;
    return IconoTono(
      icono: c == null ? CupertinoIcons.question : iconoTipoCuenta(c.tipo),
      tono: tonoPastel(c?.color),
      tamano: tamano,
    );
  }
}

/// "en 12 días", "mañana", "hoy", "hace 3 días".
String enDias(DateTime fecha, DateTime ahora) {
  final dias = soloFecha(fecha).difference(soloFecha(ahora)).inDays;
  return switch (dias) {
    0 => 'hoy',
    1 => 'mañana',
    -1 => 'ayer',
    < 0 => 'hace ${-dias} días',
    _ => 'en $dias días',
  };
}

/// ¿Ya pasó la fecha límite de pago (sin contar el propio día)?
bool pagoVencido(EstadoCredito credito, DateTime ahora) =>
    credito.pendienteCentavos > 0 &&
    soloFecha(credito.fechaLimitePago).isBefore(soloFecha(ahora));

/// Etiqueta y monto principal de la cuenta: "Disponible $412.30" o
/// "Deuda $363.86".
(String, int) valorPrincipal(EstadoCuenta estado) =>
    (estado.cuenta.esCredito ? 'Deuda' : 'Disponible', estado.valorCentavos);
