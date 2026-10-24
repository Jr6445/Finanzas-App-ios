import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/dialogos.dart';
import '../../../core/ui/espacio_final.dart';
import '../application/compras_providers.dart';
import '../data/fuente_compras_fake.dart';
import 'formulario_compra_page.dart';
import 'widgets/sliver_compras_por_dia.dart';

/// ConsumerWidget = StatelessWidget con acceso a Riverpod mediante `ref`.
/// `ref.watch` hace que el widget se reconstruya cuando cambia el provider.
class ListaComprasPage extends ConsumerWidget {
  const ListaComprasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grupos = ref.watch(comprasPorDiaProvider);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      // Una CustomScrollView con "slivers" (pedazos de una lista que se
      // desplazan juntos) permite el título grande de iOS que se encoge y el
      // "jalar para refrescar".
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Compras'),
            border: null,
            backgroundColor: CupertinoColors.systemGroupedBackground,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () =>
                  abrirModal(context, const FormularioCompraPage()),
              child: const Icon(CupertinoIcons.plus_circle_fill, size: 28),
            ),
          ),
          CupertinoSliverRefreshControl(onRefresh: () => _refrescar(ref)),
          ...grupos.when(
            data: (grupos) => [
              if (grupos.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Todavía no hay compras')),
                )
              else
                SliverComprasPorDia(grupos: grupos),
              const SliverEspacioFinal(),
            ],
            loading: () => const [
              SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator()),
              ),
            ],
            error: (error, _) => [
              SliverFillRemaining(
                child: Center(child: Text('Error al cargar compras: $error')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _refrescar(WidgetRef ref) async {
    // Con la fuente fake, jalar la lista simula un pago con Apple Pay.
    final fuente = ref.read(fuenteComprasProvider);
    if (fuente is FuenteComprasFake) fuente.simularCompraApplePay();
    await ref.read(importadorComprasProvider).importarPendientes();
  }
}
