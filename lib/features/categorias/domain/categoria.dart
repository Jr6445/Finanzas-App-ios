/// Categoría de gasto, editable desde Ajustes.
class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
  });

  final int id;
  final String nombre;

  /// Claves que se traducen a ícono y color en `estilo_categoria.dart`.
  final String icono;
  final String color;
}
