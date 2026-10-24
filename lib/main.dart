import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/platform/plataforma.dart';

Future<void> main() async {
  // device_preview 3 instala su propio "binding" (el objeto raíz que conecta
  // Flutter con la plataforma), por eso debe llamarse ANTES que cualquier otra
  // cosa. Solo en debug y fuera del iPhone real; en release no hace nada.
  if (kDebugMode && !esIOSReal) {
    DevicePreview.enable();
    unawaited(
      DevicePreview.maybeController?.applyPreset(DevicePresets.iPhone16),
    );
  }

  WidgetsFlutterBinding.ensureInitialized();
  // Carga los nombres de días y meses en español para DateFormat.
  await initializeDateFormatting('es');

  // ProviderScope es el contenedor de Riverpod: equivale al
  // IServiceProvider de .NET, donde viven todas las instancias de providers.
  runApp(const ProviderScope(child: FinanzasApp()));
}
