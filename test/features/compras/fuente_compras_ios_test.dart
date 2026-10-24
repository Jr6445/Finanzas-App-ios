import 'dart:convert';

import 'package:finanzas/core/format/formato.dart';
import 'package:finanzas/features/compras/data/fuente_compras_ios.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lo mismo que escribe el Swift: un objeto JSON con todo como texto.
String _json(String id, {String monto = '12.50', String? comercio}) =>
    jsonEncode({
      'id': id,
      'comercio': comercio ?? 'SUPER SELECTOS ESCALON',
      'monto': monto,
      'tarjeta': 'Visa Agrícola',
      'fecha': '2026-10-24T17:30:00Z',
    });

void main() {
  group('interpretarMontoDeAtajos', () {
    test('formatos de región y símbolos', () {
      expect(interpretarMontoDeAtajos('12.5'), 1250);
      expect(interpretarMontoDeAtajos(r'$12.50'), 1250);
      expect(interpretarMontoDeAtajos(r'US$ 1,234.56'), 123456);
      expect(interpretarMontoDeAtajos(r'1.234,56 $'), 123456);
      expect(interpretarMontoDeAtajos('12,50'), 1250);
      expect(interpretarMontoDeAtajos('1,234'), 123400);
      expect(interpretarMontoDeAtajos('1.234.567'), 123456700);
      expect(interpretarMontoDeAtajos('7'), 700);
      expect(interpretarMontoDeAtajos(12.5), 1250);
      expect(interpretarMontoDeAtajos(0.1 + 0.2), 30);
    });

    test('sin números devuelve null', () {
      expect(interpretarMontoDeAtajos(''), isNull);
      expect(interpretarMontoDeAtajos(r'$'), isNull);
      expect(interpretarMontoDeAtajos(null), isNull);
    });
  });

  group('desdeJson', () {
    test('convierte lo que manda el App Intent', () {
      final c = FuenteComprasIOS.desdeJson(_json('A'))!;
      expect(c.id, 'A');
      expect(c.comercio, 'SUPER SELECTOS ESCALON');
      expect(c.montoCentavos, 1250);
      expect(c.tarjeta, 'Visa Agrícola');
      expect(c.fecha, DateTime.utc(2026, 10, 24, 17, 30).toLocal());
    });

    test('es tolerante con datos incompletos', () {
      final c = FuenteComprasIOS.desdeJson(
        jsonEncode({'id': 'B', 'monto': 'gratis'}),
      )!;
      expect(c.comercio, 'Comercio desconocido');
      expect(c.montoCentavos, 0);
      expect(c.tarjeta, 'Apple Pay');
    });

    test('descarta lo que no es JSON o no tiene id', () {
      expect(FuenteComprasIOS.desdeJson('no es json'), isNull);
      expect(FuenteComprasIOS.desdeJson('[1, 2]'), isNull);
      expect(FuenteComprasIOS.desdeJson(jsonEncode({'comercio': 'X'})), isNull);
    });
  });

  group('FuenteComprasIOS con UserDefaults simulado', () {
    test('lee y quita solo las compras importadas', () async {
      // setMockInitialValues recibe las claves sin el prefijo "flutter.".
      SharedPreferences.setMockInitialValues({
        FuenteComprasIOS.clave: [_json('A'), _json('B'), 'basura'],
      });
      final fuente = FuenteComprasIOS();

      final pendientes = await fuente.leerPendientes();
      expect(pendientes.map((c) => c.id), ['A', 'B']);

      await fuente.marcarImportadas({'A'});
      final prefs = await SharedPreferences.getInstance();
      // Queda solo B; la entrada ilegible se limpió.
      expect(prefs.getStringList(FuenteComprasIOS.clave), [_json('B')]);

      await fuente.marcarImportadas({'B'});
      expect(prefs.containsKey(FuenteComprasIOS.clave), isFalse);
    });

    test('sin compras pendientes devuelve una lista vacía', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await FuenteComprasIOS().leerPendientes(), isEmpty);
    });
  });
}
