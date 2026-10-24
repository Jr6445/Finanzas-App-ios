import '../../categorias/domain/regla_categoria.dart';

/// Se guarda en la base como número (su posición): NO cambies el orden ni
/// insertes valores en medio; agrega los nuevos al final.
enum TipoCuenta {
  debito('Débito'),
  credito('Crédito'),
  efectivo('Efectivo / otra'),

  /// Creada sola al llegar una compra de una tarjeta desconocida; falta que
  /// el usuario le ponga tipo y saldo.
  sinConfigurar('Sin configurar');

  const TipoCuenta(this.etiqueta);

  final String etiqueta;
}

/// Una cuenta o tarjeta: donde tienes dinero (débito, efectivo) o una deuda
/// (crédito).
class Cuenta {
  const Cuenta({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.color,
    this.alias = const [],
    this.saldoInicialCentavos = 0,
    required this.fechaSaldoInicial,
    this.limiteCentavos,
    this.diaCorte,
    this.diaPago,
    this.diasRecordatorio = 3,
  });

  /// 0 = cuenta nueva que aún no está en la base.
  final int id;
  final String nombre;
  final TipoCuenta tipo;

  /// Clave de la paleta pastel (ver core/theme/paleta.dart).
  final String color;

  /// Otros nombres con los que puede llegar desde Apple Pay, p. ej.
  /// "Visa ••4821".
  final List<String> alias;

  /// En crédito es la deuda; en las demás, el dinero disponible. Es el valor
  /// a la [fechaSaldoInicial]: solo cuentan los movimientos posteriores.
  final int saldoInicialCentavos;
  final DateTime fechaSaldoInicial;

  // Solo crédito.
  final int? limiteCentavos;
  final int? diaCorte;
  final int? diaPago;

  /// Días antes de la fecha límite de pago para avisar; 0 = sin aviso.
  final int diasRecordatorio;

  bool get esCredito => tipo == TipoCuenta.credito;

  /// ¿Esta cuenta es la que Apple Pay llama [nombreRecibido]? Compara sin
  /// mayúsculas ni tildes contra el nombre y los nombres alternativos.
  bool reconoce(String nombreRecibido) {
    final buscado = normalizar(nombreRecibido);
    return normalizar(nombre) == buscado ||
        alias.any((a) => normalizar(a) == buscado);
  }

  Cuenta copyWith({
    int? id,
    String? nombre,
    TipoCuenta? tipo,
    String? color,
    List<String>? alias,
    int? saldoInicialCentavos,
    DateTime? fechaSaldoInicial,
    int? Function()? limiteCentavos,
    int? Function()? diaCorte,
    int? Function()? diaPago,
    int? diasRecordatorio,
  }) {
    // Los campos que pueden volverse null se pasan como función (p. ej.
    // `diaCorte: () => null`) para distinguir "no cambiar" de "borrar".
    return Cuenta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      color: color ?? this.color,
      alias: alias ?? this.alias,
      saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
      fechaSaldoInicial: fechaSaldoInicial ?? this.fechaSaldoInicial,
      limiteCentavos: limiteCentavos != null
          ? limiteCentavos()
          : this.limiteCentavos,
      diaCorte: diaCorte != null ? diaCorte() : this.diaCorte,
      diaPago: diaPago != null ? diaPago() : this.diaPago,
      diasRecordatorio: diasRecordatorio ?? this.diasRecordatorio,
    );
  }
}
