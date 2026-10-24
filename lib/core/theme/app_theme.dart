import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Tema con apariencia iOS en modo claro y oscuro.
///
/// `platform: TargetPlatform.iOS` hace que los widgets Material se comporten
/// como en iOS (transiciones, rebote al hacer scroll, tipografía), aunque la
/// app corra en Windows o Chrome.
abstract final class AppTheme {
  static ThemeData claro() => _base(Brightness.light);

  static ThemeData oscuro() => _base(Brightness.dark);

  static ThemeData _base(Brightness brillo) {
    final oscuro = brillo == Brightness.dark;
    // Azul del sistema de iOS (más claro en modo oscuro, como hace Apple).
    final azul = oscuro ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);

    return ThemeData(
      platform: TargetPlatform.iOS,
      brightness: brillo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: azul,
        primary: azul,
        brightness: brillo,
      ),
      // Fondo "agrupado" de iOS (el gris de Ajustes).
      scaffoldBackgroundColor: oscuro ? Colors.black : const Color(0xFFF2F2F7),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brillo,
        primaryColor: CupertinoColors.systemBlue,
      ),
    );
  }
}
