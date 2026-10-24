import 'package:flutter/widgets.dart';

/// Último sliver de un CustomScrollView: deja espacio para la barra de
/// pestañas y la barra de inicio del iPhone.
///
/// ListView suma solo ese margen (MediaQuery.padding), pero CustomScrollView
/// no; sin esto, la última fila queda escondida detrás de la barra de
/// pestañas translúcida.
class SliverEspacioFinal extends StatelessWidget {
  const SliverEspacioFinal({super.key});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 24),
  );
}
