import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/formato.dart';
import '../../../core/theme/paleta.dart';
import '../../../core/ui/espacio_final.dart';
import '../../../core/ui/tarjeta.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../categorias/presentation/estilo_categoria.dart';
import '../../compras/application/compras_providers.dart';
import '../../compras/domain/agrupacion.dart';
import '../../compras/domain/filtro_compras.dart';
import '../../compras/presentation/widgets/sliver_compras_por_dia.dart';
import '../../presupuestos/application/presupuestos_providers.dart';
import 'widgets/avance_presupuesto.dart';

/// Las compras de un mes para una categoría o una tarjeta, agrupadas por
/// día. Se abre al tocar una fila en Resumen. Se actualiza sola si editas o
/// borras una compra desde aquí.
class DetalleComprasPage extends ConsumerWidget {
  const DetalleComprasPage({
    super.key,
    required this.filtro,
    required this.mes,
  });

  final FiltroCompras filtro;
  final DateTime mes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compras = ref.watch(comprasProvider).value ?? const [];
    final categorias = ref.watch(categoriasPorIdProvider);
    final presupuestos = ref.watch(presupuestosProvider).value ?? const {};

    final filtradas = comprasDelMes(compras, mes, filtro);
    final grupos = agruparPorDia(filtradas);
    final total = filtradas.fold(0, (t, c) => t + c.montoCentavos);
    final totalMes = compras
        .where((c) => c.fecha.year == mes.year && c.fecha.month == mes.month)
        .fold(0, (t, c) => t + c.montoCentavos);

    // Dart 3: un switch que devuelve un "record" (tupla con nombre) y
    // desestructura los campos de cada tipo de filtro.
    final (titulo, icono, presupuesto) = switch (filtro) {
      FiltroCategoria(:final categoriaId) => (
        categorias[categoriaId]?.nombre ?? nombreSinCategoria,
        IconoCategoria.de(categorias[categoriaId], tamano: 48),
        presupuestos[categoriaId],
      ),
      FiltroTarjeta(:final tarjeta) => (
        tarjeta,
        IconoTono(
          icono: CupertinoIcons.creditcard,
          tono: tonoPastel('indigo'),
          tamano: 48,
        ),
        null,
      ),
    };
    final n = filtradas.length;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(titulo),
            previousPageTitle: 'Resumen',
            border: null,
            backgroundColor: CupertinoColors.systemGroupedBackground,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      icono,
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombreMes(mes),
                              style: Estilos.secundario(context, tamano: 15),
                            ),
                            Text(
                              formatearMonto(total),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                                fontFeatures: Estilos.numeros,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    [
                      n == 1 ? '1 compra' : '$n compras',
                      if (totalMes > 0)
                        '${formatearPorcentaje(total / totalMes)} del mes',
                    ].join('  ·  '),
                    style: Estilos.terciario(context),
                  ),
                  if (presupuesto != null) ...[
                    const SizedBox(height: 14),
                    AvancePresupuesto(
                      gastado: total,
                      presupuesto: presupuesto,
                      alto: 6,
                      prefijo: 'Presupuesto: ',
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (grupos.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Sin compras en ${nombreMesCorto(mes)}',
                  style: Estilos.secundario(context, tamano: 15),
                ),
              ),
            )
          else
            SliverComprasPorDia(grupos: grupos),
          const SliverEspacioFinal(),
        ],
      ),
    );
  }
}
