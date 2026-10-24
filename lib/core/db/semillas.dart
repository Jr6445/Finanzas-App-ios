/// Datos con los que arranca la base la primera vez. Después, todo se puede
/// editar desde Ajustes.
const categoriasIniciales = <({String nombre, String icono, String color})>[
  (nombre: 'Supermercado', icono: 'carrito', color: 'verde'),
  (nombre: 'Restaurantes', icono: 'restaurante', color: 'naranja'),
  (nombre: 'Café', icono: 'cafe', color: 'cafe'),
  (nombre: 'Combustible', icono: 'gasolina', color: 'rojo'),
  (nombre: 'Salud', icono: 'farmacia', color: 'turquesa'),
  (nombre: 'Tiendas', icono: 'bolsa', color: 'rosa'),
  (nombre: 'Servicios', icono: 'recibo', color: 'indigo'),
  (nombre: 'Transporte', icono: 'carro', color: 'azul'),
  (nombre: 'Entretenimiento', icono: 'pelicula', color: 'morado'),
  (nombre: 'Otros', icono: 'categoria', color: 'gris'),
];

/// (patrón, nombre de la categoría)
const reglasIniciales = <(String, String)>[
  ('selectos', 'Supermercado'),
  ('walmart', 'Supermercado'),
  ('despensa', 'Supermercado'),
  ('pricesmart', 'Supermercado'),
  ('campero', 'Restaurantes'),
  ('pizza', 'Restaurantes'),
  ('wendy', 'Restaurantes'),
  ('pupuseria', 'Restaurantes'),
  ('starbucks', 'Café'),
  ('coffee', 'Café'),
  ('puma', 'Combustible'),
  ('texaco', 'Combustible'),
  ('gasolinera', 'Combustible'),
  ('farmacia', 'Salud'),
  ('siman', 'Tiendas'),
  ('claro', 'Servicios'),
  ('tigo', 'Servicios'),
  ('cinepolis', 'Entretenimiento'),
  ('uber', 'Transporte'),
];
