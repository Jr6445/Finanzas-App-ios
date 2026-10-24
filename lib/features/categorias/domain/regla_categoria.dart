/// "Si el nombre del comercio contiene [patron], la compra es de la
/// categoría [categoriaId]".
class ReglaCategoria {
  const ReglaCategoria({
    required this.id,
    required this.patron,
    required this.categoriaId,
  });

  final int id;
  final String patron;
  final int categoriaId;
}

/// Devuelve la categoría de la regla que coincide, o null si ninguna.
///
/// No distingue mayúsculas ni tildes: "SUPER SELECTOS" y "Pupusería"
/// coinciden con "selectos" y "pupuseria". Si coinciden varias, gana el
/// patrón más largo (el más específico), así el orden de las reglas no
/// importa: "farmacia san nicolas" le gana a "farmacia".
int? asignarCategoria(String comercio, List<ReglaCategoria> reglas) {
  final nombre = normalizar(comercio);
  ReglaCategoria? mejor;
  for (final regla in reglas) {
    final patron = normalizar(regla.patron);
    if (patron.isEmpty || !nombre.contains(patron)) continue;
    if (mejor == null || patron.length > normalizar(mejor.patron).length) {
      mejor = regla;
    }
  }
  return mejor?.categoriaId;
}

bool coincide(String comercio, String patron) {
  final p = normalizar(patron);
  return p.isNotEmpty && normalizar(comercio).contains(p);
}

String normalizar(String texto) {
  const conTilde = 'áéíóúüñ';
  const sinTilde = 'aeiouun';
  final buffer = StringBuffer();
  for (final letra in texto.toLowerCase().trim().split('')) {
    final i = conTilde.indexOf(letra);
    buffer.write(i >= 0 ? sinTilde[i] : letra);
  }
  return buffer.toString();
}
