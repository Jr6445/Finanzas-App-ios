import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ajustes/presentation/ajustes_page.dart';
import '../features/compras/application/compras_providers.dart';
import '../features/compras/presentation/lista_compras_page.dart';
import '../features/resumen/presentation/resumen_page.dart';

/// Pestañas principales de la app. También se encarga de importar las compras
/// pendientes al abrir la app y cada vez que vuelve a primer plano.
class HomeTabs extends ConsumerStatefulWidget {
  const HomeTabs({super.key});

  @override
  ConsumerState<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends ConsumerState<HomeTabs> {
  late final AppLifecycleListener _ciclo;

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
    super.dispose();
  }

  void _importar() => ref.read(importadorComprasProvider).importarPendientes();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.creditcard),
            label: 'Compras',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_pie),
            label: 'Resumen',
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
          _ => const AjustesPage(),
        },
      ),
    );
  }
}
