import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ajustes/presentation/ajustes_page.dart';
import '../features/compras/application/compras_providers.dart';
import '../features/compras/presentation/lista_compras_page.dart';
import '../features/cuentas/application/cuentas_providers.dart';
import '../features/cuentas/application/servicio_recordatorios.dart';
import '../features/cuentas/domain/estado_cuenta.dart';
import '../features/cuentas/domain/recordatorios.dart';
import '../features/cuentas/presentation/cuentas_page.dart';
import '../features/resumen/presentation/resumen_page.dart';

/// Pestañas principales de la app. También importa las compras pendientes
/// al abrir la app y al volver a primer plano, y mantiene al día los
/// recordatorios de pago.
class HomeTabs extends ConsumerStatefulWidget {
  const HomeTabs({super.key});

  @override
  ConsumerState<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends ConsumerState<HomeTabs> {
  late final AppLifecycleListener _ciclo;
  Timer? _esperaRecordatorios;

  @override
  void initState() {
    super.initState();
    // onResume se llama al volver a primer plano (p. ej. después de pagar
    // con Apple Pay y regresar a la app).
    _ciclo = AppLifecycleListener(onResume: _importar);
    _importar();
  }

  @override
  void dispose() {
    _ciclo.dispose();
    _esperaRecordatorios?.cancel();
    super.dispose();
  }

  void _importar() => ref.read(importadorComprasProvider).importarPendientes();

  /// Reprograma los avisos cuando cambian saldos o cortes. Espera un momento
  /// para no reprogramar varias veces seguidas mientras se cargan los datos
  /// (como un debounce en Vue).
  void _programarRecordatorios(List<EstadoCuenta> estados) {
    _esperaRecordatorios?.cancel();
    _esperaRecordatorios = Timer(const Duration(seconds: 2), () {
      ref
          .read(servicioRecordatoriosProvider)
          .programar(calcularRecordatorios(estados, DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen reacciona a cambios sin reconstruir la pantalla.
    ref.listen(
      estadosCuentasProvider,
      (_, estados) => _programarRecordatorios(estados),
    );

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Compras',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_pie),
            label: 'Resumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.creditcard),
            label: 'Cuentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
      // Cada CupertinoTabView tiene su propia pila de navegación, como en
      // iOS: cambiar de pestaña no pierde dónde estabas en la otra.
      tabBuilder: (context, indice) => CupertinoTabView(
        builder: (context) => switch (indice) {
          0 => const ListaComprasPage(),
          1 => const ResumenPage(),
          2 => const CuentasPage(),
          _ => const AjustesPage(),
        },
      ),
    );
  }
}
