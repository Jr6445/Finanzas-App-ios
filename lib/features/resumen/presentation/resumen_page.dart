import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/formato.dart';
import '../../../core/ui/barra_progreso.dart';
import '../../../core/ui/dialogos.dart';
import '../../../core/ui/espacio_final.dart';
import '../../../core/ui/tarjeta.dart';
import '../../../core/ui/tocable.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../categorias/domain/categoria.dart';
import '../../categorias/presentation/estilo_categoria.dart';
import '../../compras/domain/filtro_compras.dart';
import '../application/resumen_providers.dart';
import '../domain/resumen_mensual.dart';
import 'detalle_compras_page.dart';
import 'widgets/avance_presupuesto.dart';
import 'widgets/grafica_dias.dart';

class ResumenPage extends ConsumerWidget {
  const ResumenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mes = ref.watch(mesSeleccionadoProvider);
    final selector = ref.read(mesSeleccionadoProvider.notifier);
    final resumen = ref.watch(resumenMensualProvider);
    final categorias = ref.watch(categoriasPorIdProvider);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Resumen'),
            border: null,
            backgroundColor: CupertinoColors.systemGroupedBackground,
          ),
          SliverToBoxAdapter(
            child: _SelectorMes(
              mes: mes,
              alAnterior: selector.anterior,
              alSiguiente: selector.esMesActual ? null : selector.siguiente,
            ),
          ),
          ...resumen.when(
            data: (r) => [
              SliverList.list(
                children: [
                  _Encabezado(resumen: r),
                  if (r.porCategoria.isNotEmpty)
                    _TarjetaCategorias(resumen: r, categorias: categorias),
                  if (r.totalCentavos > 0) ...[
                    _TarjetaDias(resumen: r),
                    _TarjetaTarjetas(resumen: r),
                  ],
                ],
              ),
              const SliverEspacioFinal(),
            ],
            loading: () => const [
              SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator()),
              ),
            ],
            error: (error, _) => [
              SliverFillRemaining(child: Center(child: Text('Error: $error'))),
            ],
          ),
        ],
      ),
    );
  }
}

/// ‹   Octubre 2026   › en una cápsula a todo lo ancho, con las flechas en
/// los extremos.
class _SelectorMes extends StatelessWidget {
  const _SelectorMes({
    required this.mes,
    required this.alAnterior,
    required this.alSiguiente,
  });

  final DateTime mes;
  final VoidCallback alAnterior;

  /// Null cuando ya es el mes actual (la flecha se atenúa).
  final VoidCallback? alSiguiente;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(
          context,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onPressed: alAnterior,
            child: const Icon(CupertinoIcons.chevron_left, size: 18),
          ),
          Expanded(
            child: Text(
              nombreMes(mes),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onPressed: alSiguiente,
            child: const Icon(CupertinoIcons.chevron_right, size: 18),
          ),
        ],
      ),
    );
  }
}

/// El total grande, sin tarjeta, directamente sobre el fondo.
class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.resumen});

  final ResumenMensual resumen;

  @override
  Widget build(BuildContext context) {
    final presupuesto = resumen.presupuestoTotalCentavos;
    final n = resumen.cantidadCompras;
    final anterior = resumen.totalMesAnteriorCentavos;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gastado en ${nombreMesCorto(resumen.mes)}',
            style: Estilos.secundario(context, tamano: 15),
          ),
          const SizedBox(height: 2),
          Text(
            formatearMonto(resumen.totalCentavos),
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.2,
              fontFeatures: Estilos.numeros,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            [
              if (n == 0) 'Sin compras' else n == 1 ? '1 compra' : '$n compras',
              // Se muestra el total del mes anterior en lugar de un "%
              // más/menos": a mitad de mes compararía un mes incompleto
              // contra uno completo y engañaría.
              if (anterior > 0)
                '${nombreMesCorto(sumarMeses(resumen.mes, -1))}: '
                    '${formatearMonto(anterior)}',
            ].join('  ·  '),
            style: Estilos.terciario(context),
          ),
          if (presupuesto != null && presupuesto > 0) ...[
            const SizedBox(height: 16),
            AvancePresupuesto(
              gastado: resumen.gastadoConPresupuestoCentavos,
              presupuesto: presupuesto,
              alto: 6,
              prefijo: 'En categorías con presupuesto: ',
            ),
          ],
        ],
      ),
    );
  }
}

class _TarjetaCategorias extends StatelessWidget {
  const _TarjetaCategorias({required this.resumen, required this.categorias});

  final ResumenMensual resumen;
  final Map<int, Categoria> categorias;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      titulo: 'Categorías',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (resumen.totalCentavos > 0) ...[
            BarraSegmentada(
              segmentos: [
                for (final g in resumen.porCategoria)
                  (
                    g.totalCentavos,
                    colorGraficaCategoria(context, categorias[g.categoriaId]),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          for (final g in resumen.porCategoria)
            _FilaCategoria(
              gasto: g,
              categoria: categorias[g.categoriaId],
              totalMes: resumen.totalCentavos,
              mes: resumen.mes,
            ),
        ],
      ),
    );
  }
}

class _FilaCategoria extends StatelessWidget {
  const _FilaCategoria({
    required this.gasto,
    required this.categoria,
    required this.totalMes,
    required this.mes,
  });

  final GastoCategoria gasto;
  final Categoria? categoria;
  final int totalMes;
  final DateTime mes;

  @override
  Widget build(BuildContext context) {
    final presupuesto = gasto.presupuestoCentavos;
    return Tocable(
      onTap: () => abrirPantalla(
        context,
        DetalleComprasPage(
          filtro: FiltroCategoria(gasto.categoriaId),
          mes: mes,
        ),
      ),
      child: Padding(
        // El espacio vertical va dentro de la fila para que toda el área
        // (no solo el texto) responda al toque.
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colorGraficaCategoria(context, categoria),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    categoria?.nombre ?? nombreSinCategoria,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                if (totalMes > 0)
                  Text(
                    formatearPorcentaje(gasto.totalCentavos / totalMes),
                    style: Estilos.terciario(context),
                  ),
                _MontoConFlecha(gasto.totalCentavos),
              ],
            ),
            if (presupuesto != null)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, right: 18),
                child: AvancePresupuesto(
                  gastado: gasto.totalCentavos,
                  presupuesto: presupuesto,
                  prefijo: 'Presupuesto: ',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Monto alineado a la derecha seguido de un chevron gris, que indica que la
/// fila abre otra pantalla.
class _MontoConFlecha extends StatelessWidget {
  const _MontoConFlecha(this.centavos);

  final int centavos;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            formatearMonto(centavos),
            textAlign: TextAlign.end,
            style: Estilos.monto(peso: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 6),
        Icon(
          CupertinoIcons.chevron_right,
          size: 12,
          color: CupertinoColors.tertiaryLabel.resolveFrom(context),
        ),
      ],
    );
  }
}

class _TarjetaDias extends StatelessWidget {
  const _TarjetaDias({required this.resumen});

  final ResumenMensual resumen;

  @override
  Widget build(BuildContext context) {
    // En el mes en curso, el promedio es sobre los días que ya pasaron.
    final hoy = DateTime.now();
    final esMesActual = inicioMes(hoy) == resumen.mes;
    final dias = esMesActual ? hoy.day : resumen.porDiaCentavos.length;
    final promedio = resumen.totalCentavos ~/ dias;

    return Tarjeta(
      titulo: 'Por día',
      detalle: 'Promedio ${formatearMonto(promedio)}',
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: GraficaDias(resumen: resumen, promedioCentavos: promedio),
    );
  }
}

class _TarjetaTarjetas extends StatelessWidget {
  const _TarjetaTarjetas({required this.resumen});

  final ResumenMensual resumen;

  @override
  Widget build(BuildContext context) {
    final gris = CupertinoDynamicColor.resolve(
      tonoPastel('indigo').medio,
      context,
    );
    final mayor = resumen.porTarjeta.first.totalCentavos;

    return Tarjeta(
      titulo: 'Cuentas',
      child: Column(
        children: [
          for (final t in resumen.porTarjeta)
            Tocable(
              onTap: () => abrirPantalla(
                context,
                DetalleComprasPage(
                  filtro: FiltroTarjeta(t.tarjeta),
                  mes: resumen.mes,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            t.tarjeta,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Text(
                          formatearPorcentaje(
                            t.totalCentavos / resumen.totalCentavos,
                          ),
                          style: Estilos.terciario(context),
                        ),
                        _MontoConFlecha(t.totalCentavos),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: BarraProgreso(
                        fraccion: t.totalCentavos / mayor,
                        color: gris,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
