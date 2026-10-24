import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formato.dart';
import '../../categorias/domain/categoria.dart';
import '../../categorias/domain/regla_categoria.dart';
import '../../compras/domain/compra.dart';

// Coma como separador y BOM UTF-8 al inicio: así Excel en español (El
// Salvador, con punto decimal) abre el archivo con columnas y tildes bien.
// `Csv.excel()` usa ";" que es para países con coma decimal.
final _csv = Csv(addBom: true);
final _fecha = DateFormat('yyyy-MM-dd HH:mm');

/// Todas las compras, de la más antigua a la más reciente.
String comprasACsv(List<Compra> compras, Map<int, Categoria> categorias) {
  final ordenadas = [...compras]..sort((a, b) => a.fecha.compareTo(b.fecha));
  return _csv.encode([
    ['Fecha', 'Comercio', 'Monto', 'Tarjeta', 'Categoría', 'Origen', 'Id'],
    for (final c in ordenadas)
      [
        _fecha.format(c.fecha),
        c.comercio,
        // Número sin "$" ni comas de miles, para que Excel lo sume.
        montoParaEditar(c.montoCentavos),
        c.tarjeta,
        categorias[c.categoriaId]?.nombre ?? '',
        switch (c.origen) {
          OrigenCompra.applePay => 'Apple Pay',
          OrigenCompra.manual => 'Manual',
        },
        c.id,
      ],
  ]);
}

/// Una fila por categoría con su presupuesto y sus reglas (separadas por
/// " | "), para poder reconstruir la configuración.
String categoriasACsv(
  List<Categoria> categorias,
  List<ReglaCategoria> reglas,
  Map<int, int> presupuestos,
) {
  return _csv.encode([
    ['Categoría', 'Ícono', 'Color', 'Presupuesto mensual', 'Reglas'],
    for (final c in categorias)
      [
        c.nombre,
        c.icono,
        c.color,
        presupuestos[c.id] == null ? '' : montoParaEditar(presupuestos[c.id]!),
        [
          for (final r in reglas)
            if (r.categoriaId == c.id) r.patron,
        ].join(' | '),
      ],
  ]);
}
