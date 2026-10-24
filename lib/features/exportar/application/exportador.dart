import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../categorias/application/categorias_providers.dart';
import '../../categorias/data/categorias_repositorio.dart';
import '../../compras/application/compras_providers.dart';
import '../../compras/data/compras_repositorio.dart';
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
  });

  final ComprasRepositorio compras;
  final CategoriasRepositorio categorias;
  final PresupuestosRepositorio presupuestos;

  Future<List<File>> generarArchivos({DateTime? ahora}) async {
    // `.first` toma el valor actual del stream y se desuscribe.
    final listaCompras = await compras.observarTodas().first;
    final listaCategorias = await categorias.observarCategorias().first;
    final reglas = await categorias.obtenerReglas();
    final mapaPresupuestos = await presupuestos.observar().first;

    final dir = await getTemporaryDirectory();
    final fecha = DateFormat('yyyy-MM-dd').format(ahora ?? DateTime.now());
    final porId = {for (final c in listaCategorias) c.id: c};

    final archivoCompras = File('${dir.path}/finanzas_compras_$fecha.csv');
    final archivoCategorias = File(
      '${dir.path}/finanzas_categorias_$fecha.csv',
    );
    await archivoCompras.writeAsString(comprasACsv(listaCompras, porId));
    await archivoCategorias.writeAsString(
      categoriasACsv(listaCategorias, reglas, mapaPresupuestos),
    );
    return [archivoCompras, archivoCategorias];
  }
}

final exportadorProvider = Provider<Exportador>(
  (ref) => Exportador(
    compras: ref.watch(comprasRepositorioProvider),
    categorias: ref.watch(categoriasRepositorioProvider),
    presupuestos: ref.watch(presupuestosRepositorioProvider),
  ),
);
