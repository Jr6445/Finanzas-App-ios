import 'package:flutter/cupertino.dart';

import '../../../../core/format/formato.dart';
import '../../../../core/ui/barra_progreso.dart';
import '../../../../core/ui/tarjeta.dart';

/// Barra de avance del presupuesto con "quedan $X de $Y" o "$X por encima".
class AvancePresupuesto extends StatelessWidget {
  const AvancePresupuesto({
    super.key,
    required this.gastado,
    required this.presupuesto,
    this.alto = 4,
    this.prefijo = '',
  });

  final int gastado;
  final int presupuesto;
  final double alto;
  final String prefijo;

  @override
  Widget build(BuildContext context) {
    final avance = gastado / presupuesto;
    final tono = tonoAvance(avance);
    final restante = presupuesto - gastado;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarraProgreso(
          fraccion: avance,
          color: CupertinoDynamicColor.resolve(tono.medio, context),
          alto: alto,
        ),
        const SizedBox(height: 6),
        Text(
          restante >= 0
              ? '${prefijo}quedan ${formatearMonto(restante)} de '
                    '${formatearMonto(presupuesto)}'
              : '$prefijo${formatearMonto(-restante)} por encima de '
                    '${formatearMonto(presupuesto)}',
          style: restante >= 0
              ? Estilos.terciario(context, tamano: 12)
              : TextStyle(
                  fontSize: 12,
                  color: CupertinoDynamicColor.resolve(tono.tinta, context),
                ),
        ),
      ],
    );
  }
}
