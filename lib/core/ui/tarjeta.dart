import 'package:flutter/cupertino.dart';

/// Tarjeta blanca (gris oscuro en modo oscuro) de esquinas suaves, como las
/// de la app Salud. Opcionalmente con título y un texto a la derecha.
class Tarjeta extends StatelessWidget {
  const Tarjeta({
    super.key,
    this.titulo,
    this.detalle,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final String? titulo;
  final String? detalle;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: padding,
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(
          context,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (titulo != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Text(titulo!, style: Estilos.tituloTarjeta)),
                if (detalle != null)
                  Text(detalle!, style: Estilos.secundario(context)),
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

/// Título pequeño y gris sobre una sección de lista, como en Ajustes de iOS.
class EncabezadoSeccion extends StatelessWidget {
  const EncabezadoSeccion(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) => Text(
    texto.toUpperCase(),
    style: Estilos.secundario(
      context,
      tamano: 12,
    ).copyWith(fontWeight: FontWeight.w400, letterSpacing: 0.2),
  );
}

/// Texto explicativo pequeño y gris debajo de una sección de lista.
class PieSeccion extends StatelessWidget {
  const PieSeccion(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) =>
      Text(texto, style: Estilos.secundario(context).copyWith(height: 1.35));
}

/// Estilos de texto compartidos, para que todas las pantallas usen la misma
/// escala (inspirada en la tipografía de iOS).
abstract final class Estilos {
  static const tituloTarjeta = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );

  static const numeros = [FontFeature.tabularFigures()];

  static TextStyle secundario(BuildContext context, {double tamano = 13}) =>
      TextStyle(
        fontSize: tamano,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
        letterSpacing: -0.1,
      );

  static TextStyle terciario(BuildContext context, {double tamano = 13}) =>
      TextStyle(
        fontSize: tamano,
        color: CupertinoColors.tertiaryLabel.resolveFrom(context),
      );

  static TextStyle monto({double tamano = 15, FontWeight? peso}) => TextStyle(
    fontSize: tamano,
    fontWeight: peso,
    fontFeatures: numeros,
    letterSpacing: -0.2,
  );
}
