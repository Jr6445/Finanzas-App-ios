import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/format/formato.dart';
import '../domain/compra_pendiente.dart';
import 'fuente_compras.dart';

/// Lee las compras que dejó el App Intent "Registrar compra" (ver
/// ios/Runner/AppDelegate.swift).
///
/// El Swift guarda un arreglo de textos JSON en UserDefaults con la clave
/// "flutter.compras_pendientes". shared_preferences antepone "flutter." a
/// todas sus claves, así que aquí la clave es solo "compras_pendientes".
class FuenteComprasIOS implements FuenteCompras {
  static const clave = 'compras_pendientes';

  @override
  Future<List<CompraPendiente>> leerPendientes() async {
    final prefs = await _prefsActualizadas();
    return (prefs.getStringList(clave) ?? const [])
        .map(desdeJson)
        .nonNulls
        .toList();
  }

  @override
  Future<void> marcarImportadas(Set<String> ids) async {
    // Se vuelve a leer justo antes de escribir para conservar las compras
    // que el App Intent haya agregado mientras importábamos.
    final prefs = await _prefsActualizadas();
    final restantes = (prefs.getStringList(clave) ?? const <String>[]).where((
      texto,
    ) {
      final compra = desdeJson(texto);
      // Las entradas ilegibles también se descartan aquí.
      return compra != null && !ids.contains(compra.id);
    }).toList();

    if (restantes.isEmpty) {
      await prefs.remove(clave);
    } else {
      await prefs.setStringList(clave, restantes);
    }
  }

  /// shared_preferences guarda en caché lo que leyó al iniciar. El App Intent
  /// escribe directo en UserDefaults sin pasar por ese caché, así que hay que
  /// pedirle que vuelva a leer.
  Future<SharedPreferences> _prefsActualizadas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs;
  }

  /// Convierte una entrada del App Intent. Es tolerante: si falta el
  /// comercio o el monto no se entiende, igual importa la compra (con
  /// "Comercio desconocido" o $0.00) para que puedas corregirla a mano en
  /// lugar de perderla. Solo devuelve null si no es JSON o no trae id.
  static CompraPendiente? desdeJson(String texto) {
    final Map<String, dynamic> datos;
    try {
      final decodificado = jsonDecode(texto);
      if (decodificado is! Map<String, dynamic>) return null;
      datos = decodificado;
    } on FormatException {
      return null;
    }
    final id = datos['id'];
    if (id is! String || id.isEmpty) return null;

    String campoTexto(String campo) => switch (datos[campo]) {
      final String s => s.trim(),
      _ => '',
    };
    final comercio = campoTexto('comercio');
    final tarjeta = campoTexto('tarjeta');

    return CompraPendiente(
      id: id,
      comercio: comercio.isEmpty ? 'Comercio desconocido' : comercio,
      montoCentavos: interpretarMontoDeAtajos(datos['monto']) ?? 0,
      tarjeta: tarjeta.isEmpty ? 'Apple Pay' : tarjeta,
      // El Swift manda la hora en UTC ("...Z"); toLocal() la pasa a la hora
      // del iPhone.
      fecha:
          DateTime.tryParse(campoTexto('fecha'))?.toLocal() ?? DateTime.now(),
    );
  }
}
