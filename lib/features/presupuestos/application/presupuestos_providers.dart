import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/base_datos.dart';
import '../data/presupuestos_repositorio.dart';

final presupuestosRepositorioProvider = Provider<PresupuestosRepositorio>(
  (ref) => PresupuestosRepositorio(ref.watch(baseDatosProvider)),
);

/// categoriaId -> presupuesto mensual en centavos.
final presupuestosProvider = StreamProvider<Map<int, int>>(
  (ref) => ref.watch(presupuestosRepositorioProvider).observar(),
);
