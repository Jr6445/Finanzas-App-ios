import 'package:flutter/cupertino.dart';

import '../theme/paleta.dart';

/// Barra horizontal delgada que se llena según [fraccion] (0 a 1; lo que
/// pase de 1 se dibuja lleno).
class BarraProgreso extends StatelessWidget {
  const BarraProgreso({
    super.key,
    required this.fraccion,
    required this.color,
    this.alto = 4,
  });

  final double fraccion;
  final Color color;
  final double alto;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(alto / 2),
      child: SizedBox(
        height: alto,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoColors.quaternarySystemFill.resolveFrom(context),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraccion.clamp(0, 1).toDouble(),
              heightFactor: 1,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tono según el avance de un presupuesto: verde hasta 80%, naranja hasta
/// 100%, rojo si se pasó.
TonoPastel tonoAvance(double avance) => tonoPastel(
  avance > 1
      ? 'rojo'
      : avance >= 0.8
      ? 'naranja'
      : 'verde',
);

/// Una sola barra dividida en segmentos proporcionales, como la de
/// almacenamiento en Ajustes de iOS.
class BarraSegmentada extends StatelessWidget {
  const BarraSegmentada({super.key, required this.segmentos, this.alto = 10});

  /// (valor, color). Los valores se normalizan solos.
  final List<(int, Color)> segmentos;
  final double alto;

  @override
  Widget build(BuildContext context) {
    final visibles = segmentos.where((s) => s.$1 > 0).toList();
    if (visibles.isEmpty) return SizedBox(height: alto);
    return ClipRRect(
      borderRadius: BorderRadius.circular(alto / 2),
      child: SizedBox(
        height: alto,
        child: Row(
          // Sin stretch, los ColoredBox (que no tienen hijo) medirían 0 de alto.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < visibles.length; i++) ...[
              if (i > 0) const SizedBox(width: 2),
              // flex debe ser entero: los centavos sirven directamente.
              Expanded(
                flex: visibles[i].$1,
                child: ColoredBox(color: visibles[i].$2),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
