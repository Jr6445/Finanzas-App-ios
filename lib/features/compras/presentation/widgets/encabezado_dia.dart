import 'package:flutter/cupertino.dart';

import '../../../../core/format/formato.dart';
import '../../../../core/ui/tarjeta.dart';
import '../../domain/agrupacion.dart';

class EncabezadoDia extends StatelessWidget {
  const EncabezadoDia({super.key, required this.grupo});

  final GrupoDia grupo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            etiquetaDia(grupo.dia),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
        Text(
          formatearMonto(grupo.totalCentavos),
          style: Estilos.secundario(
            context,
            tamano: 15,
          ).copyWith(fontFeatures: Estilos.numeros),
        ),
      ],
    );
  }
}
