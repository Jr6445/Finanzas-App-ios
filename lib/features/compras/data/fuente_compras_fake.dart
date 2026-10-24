import 'dart:math';

import '../domain/compra_pendiente.dart';
import 'fuente_compras.dart';

/// Genera compras de prueba con comercios de El Salvador.
///
/// Al crearse deja como "pendientes" unas [cantidadInicial] compras de los
/// últimos 30 días. Los ids son fijos (`fake-0`, `fake-1`, ...) para que
/// reimportarlas no cree duplicados. [simularCompraApplePay] agrega una
/// compra nueva, como si acabaras de pagar con el iPhone.
class FuenteComprasFake implements FuenteCompras {
  FuenteComprasFake({
    int semilla = 42,
    int cantidadInicial = 40,
    DateTime? ahora,
  }) : _random = Random(semilla) {
    _pendientes.addAll(
      _generarHistorial(cantidadInicial, ahora ?? DateTime.now()),
    );
  }

  final Random _random;
  final List<CompraPendiente> _pendientes = [];

  static const _tarjetas = [
    'Visa Agrícola',
    'Mastercard Cuscatlán',
    'Visa BAC Credomatic',
  ];

  // (comercio, monto mínimo, monto máximo en dólares, peso de frecuencia)
  static const _comercios = <(String, int, int, int)>[
    ('Super Selectos Escalón', 15, 120, 4),
    ('Walmart Santa Elena', 20, 150, 2),
    ('La Despensa de Don Juan', 10, 80, 2),
    ('PriceSmart Merliot', 40, 250, 1),
    ('Pollo Campero', 6, 25, 3),
    ('Pizza Hut', 12, 35, 1),
    ("Wendy's", 6, 18, 1),
    ('Pupusería La Ceiba', 3, 12, 2),
    ('Starbucks Multiplaza', 4, 9, 2),
    ('The Coffee Cup', 3, 8, 1),
    ('Puma Energy', 15, 45, 2),
    ('Texaco', 15, 45, 1),
    ('Gasolinera Uno', 15, 45, 1),
    ('Farmacia San Nicolás', 5, 60, 1),
    ('Farmacias Económicas', 5, 50, 1),
    ('Siman Galerías', 25, 150, 1),
    ('Claro', 20, 40, 1),
    ('Tigo', 15, 30, 1),
    ('Cinépolis La Gran Vía', 8, 25, 1),
    ('Uber', 3, 12, 2),
  ];

  @override
  Future<List<CompraPendiente>> leerPendientes() async =>
      List.unmodifiable(_pendientes);

  @override
  Future<void> marcarImportadas(Set<String> ids) async {
    _pendientes.removeWhere((p) => ids.contains(p.id));
  }

  /// Agrega una compra "recién hecha" a las pendientes.
  void simularCompraApplePay() {
    final ahora = DateTime.now();
    _pendientes.add(
      _generarCompra('fake-nueva-${ahora.microsecondsSinceEpoch}', ahora),
    );
  }

  List<CompraPendiente> _generarHistorial(int cantidad, DateTime ahora) {
    return List.generate(cantidad, (i) {
      final hoy = DateTime(ahora.year, ahora.month, ahora.day);
      var fecha = hoy
          .subtract(Duration(days: _random.nextInt(30)))
          .add(
            Duration(
              hours: 7 + _random.nextInt(15),
              minutes: _random.nextInt(60),
            ),
          );
      // Una compra de "hoy" no puede ser a una hora que aún no ha pasado.
      if (fecha.isAfter(ahora)) fecha = fecha.subtract(const Duration(days: 1));
      return _generarCompra('fake-$i', fecha);
    });
  }

  CompraPendiente _generarCompra(String id, DateTime fecha) {
    final (comercio, minimo, maximo, _) = _elegirComercio();
    final centavos =
        minimo * 100 + _random.nextInt((maximo - minimo) * 100 + 1);
    return CompraPendiente(
      id: id,
      comercio: comercio,
      montoCentavos: centavos,
      tarjeta: _tarjetas[_random.nextInt(_tarjetas.length)],
      fecha: fecha,
    );
  }

  /// Elige un comercio al azar respetando los pesos (el súper sale más
  /// seguido que el cine).
  (String, int, int, int) _elegirComercio() {
    final pesoTotal = _comercios.fold(0, (total, c) => total + c.$4);
    var valor = _random.nextInt(pesoTotal);
    for (final comercio in _comercios) {
      valor -= comercio.$4;
      if (valor < 0) return comercio;
    }
    return _comercios.last;
  }
}
