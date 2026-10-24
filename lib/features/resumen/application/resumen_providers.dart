import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/formato.dart';
import '../../compras/application/compras_providers.dart';
import '../../presupuestos/application/presupuestos_providers.dart';
import '../domain/resumen_mensual.dart';

/// El mes que se está viendo en Resumen.
///
/// Un Notifier es estado + los métodos que lo cambian (como un store de
/// Pinia en Vue). La UI llama `ref.read(mesSeleccionadoProvider.notifier)
/// .anterior()` y todo lo que hace `watch` del mes se recalcula.
class MesSeleccionado extends Notifier<DateTime> {
  @override
  DateTime build() => inicioMes(DateTime.now());

  void anterior() => state = sumarMeses(state, -1);

  void siguiente() {
    if (!esMesActual) state = sumarMeses(state, 1);
  }

  bool get esMesActual => state == inicioMes(DateTime.now());
}

final mesSeleccionadoProvider = NotifierProvider<MesSeleccionado, DateTime>(
  MesSeleccionado.new,
);

final resumenMensualProvider = Provider<AsyncValue<ResumenMensual>>((ref) {
  final mes = ref.watch(mesSeleccionadoProvider);
  final presupuestos = ref.watch(presupuestosProvider).value ?? const {};
  return ref
      .watch(comprasProvider)
      .whenData(
        (compras) => calcularResumen(
          compras: compras,
          mes: mes,
          presupuestos: presupuestos,
        ),
      );
});
