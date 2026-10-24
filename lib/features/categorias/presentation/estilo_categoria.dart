import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/paleta.dart';
import '../domain/categoria.dart';

export '../../../core/theme/paleta.dart' show tonosPastel, tonoPastel;

// La base guarda claves de texto; aquí se traducen a íconos y colores.
// Los mapas son `const` para que el compilador sepa exactamente qué íconos
// se usan y pueda quitar los demás del .ipa.

const iconosCategoria = <String, IconData>{
  'carrito': Icons.shopping_cart_rounded,
  'restaurante': Icons.restaurant_rounded,
  'cafe': Icons.local_cafe_rounded,
  'gasolina': Icons.local_gas_station_rounded,
  'farmacia': Icons.local_pharmacy_rounded,
  'salud': Icons.favorite_rounded,
  'bolsa': Icons.shopping_bag_rounded,
  'ropa': Icons.checkroom_rounded,
  'recibo': Icons.receipt_long_rounded,
  'luz': Icons.lightbulb_rounded,
  'agua': Icons.water_drop_rounded,
  'internet': Icons.wifi_rounded,
  'telefono': Icons.phone_iphone_rounded,
  'carro': Icons.directions_car_rounded,
  'bus': Icons.directions_bus_rounded,
  'viaje': Icons.flight_rounded,
  'pelicula': Icons.movie_rounded,
  'suscripcion': Icons.subscriptions_rounded,
  'deporte': Icons.fitness_center_rounded,
  'casa': Icons.home_rounded,
  'herramienta': Icons.build_rounded,
  'educacion': Icons.school_rounded,
  'bebe': Icons.child_friendly_rounded,
  'mascota': Icons.pets_rounded,
  'regalo': Icons.card_giftcard_rounded,
  'belleza': Icons.spa_rounded,
  'banco': Icons.account_balance_rounded,
  'categoria': Icons.category_rounded,
};

const nombreSinCategoria = 'Sin categoría';

/// Ícono de la categoría en un círculo pastel. Sin ícono/color (o
/// categoría null) muestra "sin categoría" en gris.
class IconoCategoria extends StatelessWidget {
  const IconoCategoria({
    super.key,
    required this.icono,
    required this.color,
    this.tamano = 34,
  });

  /// Constructor con nombre: Dart no tiene sobrecarga, así que se usan
  /// constructores con nombre (`IconoCategoria.de(...)`) en su lugar.
  IconoCategoria.de(Categoria? categoria, {super.key, this.tamano = 34})
    : icono = categoria?.icono,
      color = categoria?.color;

  final String? icono;
  final String? color;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return IconoTono(
      icono: iconosCategoria[icono] ?? Icons.question_mark_rounded,
      tono: tonoPastel(color),
      tamano: tamano,
    );
  }
}

/// Color de la categoría para barras y gráficas.
Color colorGraficaCategoria(BuildContext context, Categoria? categoria) =>
    CupertinoDynamicColor.resolve(tonoPastel(categoria?.color).medio, context);
