import 'package:drift/native.dart';
import 'package:finanzas/app.dart';
import 'package:finanzas/core/db/base_datos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  testWidgets('muestra la lista de compras con datos fake', (tester) async {
    final db = BaseDatos(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [baseDatosProvider.overrideWithValue(db)],
        child: const FinanzasApp(),
      ),
    );
    // Los widget tests usan un reloj falso. El trabajo de SQLite (crear
    // tablas, importar las compras fake) avanza un paso en cada pump(), y
    // runAsync deja pasar tiempo real entre pasos.
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }

    expect(find.text('Compras'), findsWidgets);
    expect(find.byType(CupertinoListTile), findsWidgets);

    // Desmontar la app cancela los streams de drift; si no, cerrar la base
    // se queda esperando y el test nunca termina.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(db.close);
  });
}
