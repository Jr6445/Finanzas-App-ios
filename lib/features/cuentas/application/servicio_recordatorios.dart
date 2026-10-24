import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/platform/plataforma.dart';
import '../domain/recordatorios.dart';

/// Programa las notificaciones locales de pago. Fuera del iPhone no hace
/// nada (en Windows no hay a quién avisar).
abstract interface class ServicioRecordatorios {
  /// Reemplaza todos los avisos programados por [recordatorios].
  Future<void> programar(List<Recordatorio> recordatorios);
}

class RecordatoriosNulos implements ServicioRecordatorios {
  const RecordatoriosNulos();

  @override
  Future<void> programar(List<Recordatorio> recordatorios) async {}
}

/// Notificaciones locales: las programa la propia app en el iPhone, sin
/// servidor ni push, por eso funcionan con un Apple ID gratis.
class RecordatoriosIOS implements ServicioRecordatorios {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _iniciado = false;

  @override
  Future<void> programar(List<Recordatorio> recordatorios) async {
    if (!_iniciado) {
      await _plugin.initialize(
        settings: const InitializationSettings(
          // El permiso se pide después, solo cuando hay algo que avisar.
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      _iniciado = true;
    }

    await _plugin.cancelAll();
    if (recordatorios.isEmpty) return;

    // iOS solo muestra el diálogo de permiso la primera vez.
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, sound: true);

    for (final r in recordatorios) {
      await _plugin.zonedSchedule(
        id: r.id,
        // Se convierte el instante a UTC: así no hace falta conocer la zona
        // horaria del iPhone y la hora local sigue siendo la correcta.
        scheduledDate: tz.TZDateTime.from(r.fecha, tz.UTC),
        notificationDetails: const NotificationDetails(
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: r.titulo,
        body: r.cuerpo,
      );
    }
  }
}

final servicioRecordatoriosProvider = Provider<ServicioRecordatorios>(
  (ref) => esIOSReal ? RecordatoriosIOS() : const RecordatoriosNulos(),
);
