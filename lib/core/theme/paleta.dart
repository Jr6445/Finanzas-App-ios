import 'package:flutter/cupertino.dart';

/// Un color pastel en tres intensidades, cada una con su versión clara y
/// oscura (CupertinoDynamicColor elige sola según el modo del sistema).
///
/// - [relleno]: fondo suave de íconos y "chips".
/// - [medio]: barras y gráficas.
/// - [tinta]: el ícono o texto encima de [relleno].
class TonoPastel {
  const TonoPastel({
    required this.relleno,
    required this.medio,
    required this.tinta,
  });

  final CupertinoDynamicColor relleno;
  final CupertinoDynamicColor medio;
  final CupertinoDynamicColor tinta;
}

// Atajo para no repetir CupertinoDynamicColor.withBrightness 66 veces.
TonoPastel _tono(
  int rellenoClaro,
  int medioClaro,
  int tintaClara,
  int rellenoOscuro,
  int medioOscuro,
  int tintaOscura,
) => TonoPastel(
  relleno: CupertinoDynamicColor.withBrightness(
    color: Color(rellenoClaro),
    darkColor: Color(rellenoOscuro),
  ),
  medio: CupertinoDynamicColor.withBrightness(
    color: Color(medioClaro),
    darkColor: Color(medioOscuro),
  ),
  tinta: CupertinoDynamicColor.withBrightness(
    color: Color(tintaClara),
    darkColor: Color(tintaOscura),
  ),
);

// Claves = las que se guardan en la base para cada categoría.
// dart format off
final tonosPastel = <String, TonoPastel>{
  //              ------------ claro ------------   ----------- oscuro -----------
  //              relleno     medio       tinta       relleno     medio       tinta
  'rojo':     _tono(0xFFFCE4E2, 0xFFF2A7A1, 0xFFC4524B, 0xFF3B2422, 0xFFD98A84, 0xFFF4A9A3),
  'naranja':  _tono(0xFFFDEBD8, 0xFFF6C394, 0xFFB86A24, 0xFF3B2E21, 0xFFD9A271, 0xFFF6C394),
  'amarillo': _tono(0xFFFBF2D0, 0xFFF0D98A, 0xFF937414, 0xFF383220, 0xFFCDB76A, 0xFFF0D98A),
  'verde':    _tono(0xFFDDF1E2, 0xFFA6DBB4, 0xFF3D8552, 0xFF1F3526, 0xFF7FBF90, 0xFFA6DBB4),
  'turquesa': _tono(0xFFD9F0EE, 0xFF9BD6D0, 0xFF2D7F79, 0xFF1C3533, 0xFF72B8B1, 0xFF9BD6D0),
  'azul':     _tono(0xFFDFEAFB, 0xFFA8C6F2, 0xFF3A6BB0, 0xFF1F2C40, 0xFF7FA4DB, 0xFFA8C6F2),
  'indigo':   _tono(0xFFE4E4F8, 0xFFB7B8EE, 0xFF5154A8, 0xFF26273F, 0xFF9192D6, 0xFFB7B8EE),
  'morado':   _tono(0xFFEEE3F8, 0xFFCFB3EE, 0xFF7A4CAB, 0xFF30253F, 0xFFAC8FD3, 0xFFCFB3EE),
  'rosa':     _tono(0xFFFAE3EE, 0xFFF1B1CE, 0xFFB04676, 0xFF3B2430, 0xFFD58AAD, 0xFFF1B1CE),
  'cafe':     _tono(0xFFF0E7DE, 0xFFD6C0A8, 0xFF85613F, 0xFF332B24, 0xFFB49A80, 0xFFD6C0A8),
  'gris':     _tono(0xFFECECF0, 0xFFC7C7CC, 0xFF6E6E73, 0xFF2C2C2E, 0xFF8E8E93, 0xFFC7C7CC),
};
// dart format on

TonoPastel tonoPastel(String? clave) =>
    tonosPastel[clave] ?? tonosPastel['gris']!;

/// Ícono dentro de un círculo pastel (estilo "tinted" de iOS 18).
class IconoTono extends StatelessWidget {
  const IconoTono({
    super.key,
    required this.icono,
    required this.tono,
    this.tamano = 34,
  });

  final IconData icono;
  final TonoPastel tono;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        // resolve() elige la variante clara u oscura según el contexto.
        color: CupertinoDynamicColor.resolve(tono.relleno, context),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icono,
        size: tamano * 0.5,
        color: CupertinoDynamicColor.resolve(tono.tinta, context),
      ),
    );
  }
}
