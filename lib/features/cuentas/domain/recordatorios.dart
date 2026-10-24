import 'package:intl/intl.dart';

import '../../../core/format/formato.dart';
import 'estado_cuenta.dart';

/// Una notificación local por programar.
class Recordatorio {
  const Recordatorio({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.cuerpo,
  });

  /// Se usa el id de la cuenta: una notificación por tarjeta.
  final int id;
  final DateTime fecha;
  final String titulo;
  final String cuerpo;
}

/// Hora del día a la que llega el aviso.
const horaRecordatorio = 9;

/// Avisos de pago para las tarjetas de crédito con algo pendiente del último
/// corte. Si la hora del aviso ya pasó, no se programa (para no avisar tarde
/// cada vez que se abre la app).
List<Recordatorio> calcularRecordatorios(
  List<EstadoCuenta> estados,
  DateTime ahora,
) {
  final formatoDia = DateFormat("d 'de' MMMM", 'es');
  final recordatorios = <Recordatorio>[];
  for (final estado in estados) {
    final credito = estado.credito;
    final dias = estado.cuenta.diasRecordatorio;
    if (credito == null || credito.pendienteCentavos <= 0 || dias <= 0) {
      continue;
    }
    final limite = credito.fechaLimitePago;
    final fecha = DateTime(
      limite.year,
      limite.month,
      limite.day - dias,
      horaRecordatorio,
    );
    if (!fecha.isAfter(ahora)) continue;

    recordatorios.add(
      Recordatorio(
        id: estado.cuenta.id,
        fecha: fecha,
        titulo: 'Pagar ${estado.cuenta.nombre}',
        cuerpo:
            'Pendiente ${formatearMonto(credito.pendienteCentavos)}; '
            'vence el ${formatoDia.format(limite)}.',
      ),
    );
  }
  return recordatorios;
}
