import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/format/formato.dart';
import '../../../../core/theme/paleta.dart';
import '../../domain/resumen_mensual.dart';

/// Barras finas con el gasto de cada día y una línea punteada con el
/// promedio, al estilo de "Tiempo en pantalla". Al tocar una barra se ve el
/// monto de ese día.
class GraficaDias extends StatelessWidget {
  const GraficaDias({
    super.key,
    required this.resumen,
    required this.promedioCentavos,
  });

  final ResumenMensual resumen;
  final int promedioCentavos;

  @override
  Widget build(BuildContext context) {
    final azul = CupertinoDynamicColor.resolve(
      tonoPastel('azul').medio,
      context,
    );
    final terciario = CupertinoColors.tertiaryLabel.resolveFrom(context);
    final dias = resumen.porDiaCentavos;

    return SizedBox(
      height: 150,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              if (promedioCentavos > 0)
                HorizontalLine(
                  y: promedioCentavos / 100,
                  color: terciario,
                  strokeWidth: 1,
                  dashArray: const [3, 3],
                ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (valor, meta) {
                  final dia = valor.toInt() + 1;
                  // Una etiqueta por semana, como en las apps de Apple.
                  if (dia % 7 != 1) return const SizedBox.shrink();
                  return SideTitleWidget(
                    meta: meta,
                    space: 6,
                    child: Text(
                      '$dia',
                      style: TextStyle(fontSize: 11, color: terciario),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(10),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              getTooltipColor: (_) => CupertinoColors.systemBackground
                  .resolveFrom(context)
                  .withValues(alpha: 0.95),
              getTooltipItem: (grupo, _, _, _) => BarTooltipItem(
                '${formatearMonto(dias[grupo.x])}\n',
                TextStyle(
                  color: CupertinoColors.label.resolveFrom(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '${grupo.x + 1} de ${nombreMesCorto(resumen.mes)}',
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel.resolveFrom(
                        context,
                      ),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < dias.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: dias[i] / 100,
                    color: azul,
                    width: 5,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
