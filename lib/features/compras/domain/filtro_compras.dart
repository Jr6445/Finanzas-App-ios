import 'compra.dart';

/// Criterio para ver un subconjunto de compras.
///
/// `sealed` es como una unión discriminada: solo existen las subclases de este
/// archivo, y un `switch` sobre un FiltroCompras obliga a cubrirlas todas
/// (el compilador avisa si falta una), parecido al pattern matching de C#.
sealed class FiltroCompras {
  const FiltroCompras();

  bool incluye(Compra compra);
}

/// Compras de una categoría. [categoriaId] null = "Sin categoría".
class FiltroCategoria extends FiltroCompras {
  const FiltroCategoria(this.categoriaId);

  final int? categoriaId;

  @override
  bool incluye(Compra compra) => compra.categoriaId == categoriaId;
}

class FiltroTarjeta extends FiltroCompras {
  const FiltroTarjeta(this.tarjeta);

  final String tarjeta;

  @override
  bool incluye(Compra compra) => compra.tarjeta == tarjeta;
}

/// Las compras de [mes] que cumplen [filtro].
List<Compra> comprasDelMes(
  List<Compra> compras,
  DateTime mes,
  FiltroCompras filtro,
) => [
  for (final c in compras)
    if (c.fecha.year == mes.year &&
        c.fecha.month == mes.month &&
        filtro.incluye(c))
      c,
];
