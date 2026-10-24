import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'shell/home_tabs.dart';

/// En debug se puede forzar el tema para probar ambos desde Windows:
/// `flutter run -d windows --dart-define=TEMA=claro` (u `oscuro`).
const _temaForzado = String.fromEnvironment('TEMA');

class FinanzasApp extends StatelessWidget {
  const FinanzasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos MaterialApp (no CupertinoApp) porque trae localizaciones y
    // widgets que necesitaremos (diálogos, Dismissible, selectores de fecha).
    // La apariencia iOS viene de ThemeData(platform: iOS) + widgets Cupertino.
    return MaterialApp(
      title: 'Finanzas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro(),
      darkTheme: AppTheme.oscuro(),
      themeMode: switch (_temaForzado) {
        'claro' => ThemeMode.light,
        'oscuro' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      // Incluye Material, Cupertino y Widgets en español.
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // MaterialApp no define un estilo de texto por defecto (lo pone el
      // widget Material, que no usamos con pantallas Cupertino). Sin esto,
      // cualquier Text suelto sale rojo con subrayado amarillo de error.
      builder: (context, child) => DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: child!,
      ),
      home: const HomeTabs(),
    );
  }
}
