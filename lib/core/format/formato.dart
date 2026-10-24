import 'package:intl/intl.dart';

// Formato de dólar como se usa en El Salvador: $1,234.56
final _moneda = NumberFormat.currency(locale: 'en_US', symbol: r'$');
final _diaSemana = DateFormat("EEEE d 'de' MMMM", 'es');
final _diaSemanaConAnio = DateFormat("EEEE d 'de' MMMM 'de' y", 'es');
final _fechaHora = DateFormat('d MMM y, h:mm a', 'es');

/// Los montos se guardan en centavos (`int`) para evitar errores de redondeo
/// de `double` (Dart no tiene un tipo `decimal` como C#).
String formatearMonto(int centavos) => _moneda.format(centavos / 100);

/// Centavos a texto editable sin símbolo: 1250 -> "12.50".
String montoParaEditar(int centavos) =>
    '${centavos ~/ 100}.${(centavos % 100).toString().padLeft(2, '0')}';

/// Texto escrito por el usuario a centavos: "12.5", "12,50", "$1,234.56".
/// Devuelve null si no es un monto válido.
int? parsearMonto(String texto) {
  var limpio = texto.replaceAll(RegExp(r'[\s$]'), '');
  // Una coma sin punto se toma como decimal ("12,50"); si hay punto, las
  // comas son separadores de miles ("1,234.56").
  limpio = limpio.contains('.')
      ? limpio.replaceAll(',', '')
      : limpio.replaceAll(',', '.');
  final partes = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(limpio);
  if (partes == null) return null;
  final decimales = (partes[2] ?? '').padRight(2, '0');
  return int.parse(partes[1]!) * 100 + int.parse(decimales);
}

/// Interpreta el monto que manda Atajos, que puede venir como número o como
/// texto con el formato de la región: "12.5", "$12.50", "US$ 1,234.56",
/// "1.234,56 $", "12,50". Más tolerante que [parsearMonto], que valida lo
/// que el usuario teclea. Devuelve null si no hay ningún número.
int? interpretarMontoDeAtajos(Object? valor) {
  if (valor is num) return (valor * 100).round();
  if (valor is! String) return null;

  // Deja solo dígitos y separadores: "US$ 1,234.56" -> "1,234.56".
  final limpio = valor.replaceAll(RegExp(r'[^0-9.,]'), '');
  if (!limpio.contains(RegExp(r'\d'))) return null;

  // El último separador es el decimal si: hay de los dos tipos ("1.234,56"),
  // o aparece una sola vez seguido de 1-2 dígitos ("12,5"). Si no, son miles
  // ("1,234" o "1.234.567").
  final ultimo = limpio.lastIndexOf(RegExp('[.,]'));
  var enteros = limpio;
  var decimales = '';
  if (ultimo >= 0) {
    final separador = limpio[ultimo];
    final despues = limpio.substring(ultimo + 1);
    final hayAmbos = limpio.contains('.') && limpio.contains(',');
    final apariciones = separador.allMatches(limpio).length;
    if (hayAmbos || (apariciones == 1 && despues.length <= 2)) {
      enteros = limpio.substring(0, ultimo);
      decimales = despues;
    }
  }
  if (decimales.length > 2) return null;
  enteros = enteros.replaceAll(RegExp('[.,]'), '');
  return int.parse(enteros.isEmpty ? '0' : enteros) * 100 +
      int.parse(decimales.padRight(2, '0'));
}

String formatearFechaHora(DateTime fecha) => _fechaHora.format(fecha);

DateTime soloFecha(DateTime fecha) =>
    DateTime(fecha.year, fecha.month, fecha.day);

/// "Hoy", "Ayer" o "Jueves 22 de octubre" (con año si no es el actual).
String etiquetaDia(DateTime dia, {DateTime? ahora}) {
  final hoy = soloFecha(ahora ?? DateTime.now());
  final fecha = soloFecha(dia);
  if (fecha == hoy) return 'Hoy';
  if (fecha == DateTime(hoy.year, hoy.month, hoy.day - 1)) return 'Ayer';

  final formato = fecha.year == hoy.year ? _diaSemana : _diaSemanaConAnio;
  return _capitalizar(formato.format(fecha));
}

/// Primer día del mes a las 00:00. Se usa como "identificador" del mes.
DateTime inicioMes(DateTime fecha) => DateTime(fecha.year, fecha.month);

/// DateTime normaliza los desbordes: el mes 13 de 2026 es enero de 2027 y el
/// día 0 es el último del mes anterior.
DateTime sumarMeses(DateTime mes, int meses) =>
    DateTime(mes.year, mes.month + meses);

int diasDelMes(DateTime mes) => DateTime(mes.year, mes.month + 1, 0).day;

/// "Octubre 2026"
String nombreMes(DateTime mes) => _capitalizar(_mesAnio.format(mes));

/// "octubre"
String nombreMesCorto(DateTime mes) => _mes.format(mes);

/// Porcentaje entero: 0.256 -> "26%".
String formatearPorcentaje(double fraccion) => '${(fraccion * 100).round()}%';

final _mesAnio = DateFormat('MMMM y', 'es');
final _mes = DateFormat('MMMM', 'es');

String _capitalizar(String texto) =>
    texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);
