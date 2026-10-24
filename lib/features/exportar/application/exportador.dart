import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../categorias/application/categorias_providers.dart';
import '../../categorias/data/categorias_repositorio.dart';
import '../../compras/application/compras_providers.dart';
import '../../compras/data/compras_repositorio.dart';
import '../../cuentas/application/cuentas_providers.dart';
import '../../cuentas/data/cuentas_repositorio.dart';
import '../../cuentas/domain/estado_cuenta.dart';
import '../../presupuestos/application/presupuestos_providers.dart';
import '../../presupuestos/data/presupuestos_repositorio.dart';
import '../domain/csv_exportacion.dart';

/// Genera los archivos CSV de respaldo en la carpeta temporal. Después la UI
/// los entrega a la hoja "Compartir" de iOS (Guardar en Archivos, AirDrop,
/// correo...).
class Exportador {
  Exportador({
    required this.compras,
    required this.categorias,
    required this.presupuestos,
    required this.cuentas,
  });

  final ComprasRepositorio compras;
  final CategoriasRepositorio categorias;
  final PresupuestosRepositorio presupuestos;
  final CuentasRepositorio cuentas;

  Future<List<File>> generarArchivos({DateTime? ahora}) async {
    final momento = ahora ?? DateTime.now();
    // `.first` toma el valor actual del stream y se desuscribe.
    final listaCompras = await compras.observarTodas().first;
    final listaCategorias = await categorias.observarCategorias().first;
    final reglas = await categorias.obtenerReglas();
    final mapaPresupuestos = await presupuestos.observar().first;
    final listaCuentas = await cuentas.obtenerCuentas();
    final movimientos = await cuentas.observarMovimientos().first;

    final dir = await getTemporaryDirectory();
    final fecha = DateFormat('yyyy-MM-dd').format(momento);
    Future<File> escribir(String nombre, String contenido) async {
      final archivo = File('${dir.path}/finanzas_${nombre}_$fecha.csv');
      await archivo.writeAsString(contenido);
      return archivo;
    }

    return [
      await escribir(
        'compras',
        comprasACsv(listaCompras, {for (final c in listaCategorias) c.id: c}),
      ),
      await escribir(
        'categorias',
        categoriasACsv(listaCategorias, reglas, mapaPresupuestos),
      ),
      await escribir(
        'cuentas',
        cuentasACsv([
          for (final cuenta in listaCuentas)
            calcularEstado(
              cuenta: cuenta,
              compras: listaCompras,
              movimientos: movimientos,
              ahora: momento,
            ),
        ]),
      ),
      await escribir(
        'movimientos',
        movimientosACsv(movimientos, {for (final c in listaCuentas) c.id: c}),
      ),
    ];
  }
}

final exportadorProvider = Provider<Exportador>(
  (ref) => Exportador(
    compras: ref.watch(comprasRepositorioProvider),
    categorias: ref.watch(categoriasRepositorioProvider),
    presupuestos: ref.watch(presupuestosRepositorioProvider),
    cuentas: ref.watch(cuentasRepositorioProvider),
  ),
);
