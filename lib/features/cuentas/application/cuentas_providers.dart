import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/base_datos.dart';
import '../../compras/application/compras_providers.dart';
import '../data/cuentas_repositorio.dart';
import '../domain/cuenta.dart';
import '../domain/estado_cuenta.dart';
import '../domain/movimiento.dart';

final cuentasRepositorioProvider = Provider<CuentasRepositorio>(
  (ref) => CuentasRepositorio(ref.watch(baseDatosProvider)),
);

final cuentasProvider = StreamProvider<List<Cuenta>>(
  (ref) => ref.watch(cuentasRepositorioProvider).observarCuentas(),
);

final movimientosProvider = StreamProvider<List<Movimiento>>(
  (ref) => ref.watch(cuentasRepositorioProvider).observarMovimientos(),
);

final cuentasPorIdProvider = Provider<Map<int, Cuenta>>((ref) {
  final cuentas = ref.watch(cuentasProvider).value ?? const [];
  return {for (final c in cuentas) c.id: c};
});

/// Saldo, deuda y cortes de cada cuenta. Se recalcula solo cuando cambia una
/// cuenta, una compra o un movimiento.
final estadosCuentasProvider = Provider<List<EstadoCuenta>>((ref) {
  final cuentas = ref.watch(cuentasProvider).value ?? const [];
  final compras = ref.watch(comprasProvider).value ?? const [];
  final movimientos = ref.watch(movimientosProvider).value ?? const [];
  final ahora = DateTime.now();
  return [
    for (final cuenta in cuentas)
      calcularEstado(
        cuenta: cuenta,
        compras: compras,
        movimientos: movimientos,
        ahora: ahora,
      ),
  ];
});
