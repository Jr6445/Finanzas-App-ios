import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// `true` solo cuando la app corre en un iPhone/iPad de verdad.
///
/// No usamos `defaultTargetPlatform` ni `Theme.of(context).platform`: como
/// forzamos la apariencia iOS y device_preview simula un iPhone, ambos dirían
/// "iOS" aunque estemos en Windows. `kIsWeb` va primero porque `Platform`
/// (de dart:io) lanza una excepción en el navegador.
final bool esIOSReal = !kIsWeb && Platform.isIOS;
