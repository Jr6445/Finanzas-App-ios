import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../../core/format/formato.dart';
import '../../categorias/domain/categoria.dart';
import '../../categorias/domain/regla_categoria.dart';
import '../../compras/domain/compra.dart';
import '../../cuentas/domain/cuenta.dart';
import '../../cuentas/domain/estado_cuenta.dart';
import '../../cuentas/domain/movimiento.dart';

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

/// Una fila por cuenta con su configuración y su saldo (o deuda) actual.
String cuentasACsv(List<EstadoCuenta> estados) {
  return _csv.encode([
    [
      'Cuenta',
      'Tipo',
      'Saldo o deuda actual',
      'Límite',
      'Día de corte',
      'Día de pago',
      'Aviso (días antes)',
      'Nombres en Apple Pay',
      'Saldo inicial',
      'Fecha del saldo inicial',
    ],
    for (final e in estados)
      [
        e.cuenta.nombre,
        e.cuenta.tipo.etiqueta,
        _montoConSigno(e.valorCentavos),
        e.cuenta.limiteCentavos == null
            ? ''
            : montoParaEditar(e.cuenta.limiteCentavos!),
        e.cuenta.diaCorte ?? '',
        e.cuenta.diaPago ?? '',
        e.cuenta.esCredito ? e.cuenta.diasRecordatorio : '',
        e.cuenta.alias.join(' | '),
        _montoConSigno(e.cuenta.saldoInicialCentavos),
        _fecha.format(e.cuenta.fechaSaldoInicial),
      ],
  ]);
}

/// Depósitos, transferencias y ajustes, del más antiguo al más reciente.
String movimientosACsv(List<Movimiento> movimientos, Map<int, Cuenta> cuentas) {
  final ordenados = [...movimientos]
    ..sort((a, b) => a.fecha.compareTo(b.fecha));
  return _csv.encode([
    ['Fecha', 'Tipo', 'Desde', 'Hacia', 'Monto', 'Nota', 'Id'],
    for (final m in ordenados)
      [
        _fecha.format(m.fecha),
        switch (m.tipo) {
          TipoMovimiento.deposito => 'Depósito',
          TipoMovimiento.transferencia => 'Transferencia',
          TipoMovimiento.ajuste => 'Ajuste',
        },
        cuentas[m.cuentaOrigenId]?.nombre ?? '',
        cuentas[m.cuentaDestinoId]?.nombre ?? '',
        _montoConSigno(m.montoCentavos),
        m.nota,
        m.id,
      ],
  ]);
}

/// [montoParaEditar] no maneja negativos (−0.50 saldría "0.50").
String _montoConSigno(int centavos) =>
    '${centavos < 0 ? '-' : ''}${montoParaEditar(centavos.abs())}';
