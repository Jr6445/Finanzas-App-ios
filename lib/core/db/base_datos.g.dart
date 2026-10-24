// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_datos.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, CategoriaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, icono, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriaFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    } else if (isInserting) {
      context.missing(_iconoMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriaFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class CategoriaFila extends DataClass implements Insertable<CategoriaFila> {
  final int id;
  final String nombre;

  /// Clave del ícono y del color (ver estilo_categoria.dart). Se guarda una
  /// clave y no el código del ícono para que Flutter pueda eliminar del
  /// .ipa los íconos que no se usan ("tree shaking").
  final String icono;
  final String color;
  const CategoriaFila({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['icono'] = Variable<String>(icono);
    map['color'] = Variable<String>(color);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      icono: Value(icono),
      color: Value(color),
    );
  }

  factory CategoriaFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriaFila(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      icono: serializer.fromJson<String>(json['icono']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'icono': serializer.toJson<String>(icono),
      'color': serializer.toJson<String>(color),
    };
  }

  CategoriaFila copyWith({
    int? id,
    String? nombre,
    String? icono,
    String? color,
  }) => CategoriaFila(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    icono: icono ?? this.icono,
    color: color ?? this.color,
  );
  CategoriaFila copyWithCompanion(CategoriasCompanion data) {
    return CategoriaFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      icono: data.icono.present ? data.icono.value : this.icono,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, icono, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriaFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.icono == this.icono &&
          other.color == this.color);
}

class CategoriasCompanion extends UpdateCompanion<CategoriaFila> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> icono;
  final Value<String> color;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.icono = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String icono,
    required String color,
  }) : nombre = Value(nombre),
       icono = Value(icono),
       color = Value(color);
  static Insertable<CategoriaFila> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? icono,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (icono != null) 'icono': icono,
      if (color != null) 'color': color,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? icono,
    Value<String>? color,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $ReglasTable extends Reglas with TableInfo<$ReglasTable, ReglaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReglasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patronMeta = const VerificationMeta('patron');
  @override
  late final GeneratedColumn<String> patron = GeneratedColumn<String>(
    'patron',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, patron, categoriaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reglas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReglaFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patron')) {
      context.handle(
        _patronMeta,
        patron.isAcceptableOrUnknown(data['patron']!, _patronMeta),
      );
    } else if (isInserting) {
      context.missing(_patronMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReglaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReglaFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patron: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patron'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
    );
  }

  @override
  $ReglasTable createAlias(String alias) {
    return $ReglasTable(attachedDatabase, alias);
  }
}

class ReglaFila extends DataClass implements Insertable<ReglaFila> {
  final int id;
  final String patron;
  final int categoriaId;
  const ReglaFila({
    required this.id,
    required this.patron,
    required this.categoriaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patron'] = Variable<String>(patron);
    map['categoria_id'] = Variable<int>(categoriaId);
    return map;
  }

  ReglasCompanion toCompanion(bool nullToAbsent) {
    return ReglasCompanion(
      id: Value(id),
      patron: Value(patron),
      categoriaId: Value(categoriaId),
    );
  }

  factory ReglaFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReglaFila(
      id: serializer.fromJson<int>(json['id']),
      patron: serializer.fromJson<String>(json['patron']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patron': serializer.toJson<String>(patron),
      'categoriaId': serializer.toJson<int>(categoriaId),
    };
  }

  ReglaFila copyWith({int? id, String? patron, int? categoriaId}) => ReglaFila(
    id: id ?? this.id,
    patron: patron ?? this.patron,
    categoriaId: categoriaId ?? this.categoriaId,
  );
  ReglaFila copyWithCompanion(ReglasCompanion data) {
    return ReglaFila(
      id: data.id.present ? data.id.value : this.id,
      patron: data.patron.present ? data.patron.value : this.patron,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReglaFila(')
          ..write('id: $id, ')
          ..write('patron: $patron, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patron, categoriaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReglaFila &&
          other.id == this.id &&
          other.patron == this.patron &&
          other.categoriaId == this.categoriaId);
}

class ReglasCompanion extends UpdateCompanion<ReglaFila> {
  final Value<int> id;
  final Value<String> patron;
  final Value<int> categoriaId;
  const ReglasCompanion({
    this.id = const Value.absent(),
    this.patron = const Value.absent(),
    this.categoriaId = const Value.absent(),
  });
  ReglasCompanion.insert({
    this.id = const Value.absent(),
    required String patron,
    required int categoriaId,
  }) : patron = Value(patron),
       categoriaId = Value(categoriaId);
  static Insertable<ReglaFila> custom({
    Expression<int>? id,
    Expression<String>? patron,
    Expression<int>? categoriaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patron != null) 'patron': patron,
      if (categoriaId != null) 'categoria_id': categoriaId,
    });
  }

  ReglasCompanion copyWith({
    Value<int>? id,
    Value<String>? patron,
    Value<int>? categoriaId,
  }) {
    return ReglasCompanion(
      id: id ?? this.id,
      patron: patron ?? this.patron,
      categoriaId: categoriaId ?? this.categoriaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patron.present) {
      map['patron'] = Variable<String>(patron.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReglasCompanion(')
          ..write('id: $id, ')
          ..write('patron: $patron, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }
}

class $CuentasTable extends Cuentas with TableInfo<$CuentasTable, CuentaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoCuenta, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoCuenta>($CuentasTable.$convertertipo);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _saldoInicialCentavosMeta =
      const VerificationMeta('saldoInicialCentavos');
  @override
  late final GeneratedColumn<int> saldoInicialCentavos = GeneratedColumn<int>(
    'saldo_inicial_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fechaSaldoInicialMeta = const VerificationMeta(
    'fechaSaldoInicial',
  );
  @override
  late final GeneratedColumn<DateTime> fechaSaldoInicial =
      GeneratedColumn<DateTime>(
        'fecha_saldo_inicial',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _limiteCentavosMeta = const VerificationMeta(
    'limiteCentavos',
  );
  @override
  late final GeneratedColumn<int> limiteCentavos = GeneratedColumn<int>(
    'limite_centavos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaCorteMeta = const VerificationMeta(
    'diaCorte',
  );
  @override
  late final GeneratedColumn<int> diaCorte = GeneratedColumn<int>(
    'dia_corte',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaPagoMeta = const VerificationMeta(
    'diaPago',
  );
  @override
  late final GeneratedColumn<int> diaPago = GeneratedColumn<int>(
    'dia_pago',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diasRecordatorioMeta = const VerificationMeta(
    'diasRecordatorio',
  );
  @override
  late final GeneratedColumn<int> diasRecordatorio = GeneratedColumn<int>(
    'dias_recordatorio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    tipo,
    color,
    alias,
    saldoInicialCentavos,
    fechaSaldoInicial,
    limiteCentavos,
    diaCorte,
    diaPago,
    diasRecordatorio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuentas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CuentaFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('saldo_inicial_centavos')) {
      context.handle(
        _saldoInicialCentavosMeta,
        saldoInicialCentavos.isAcceptableOrUnknown(
          data['saldo_inicial_centavos']!,
          _saldoInicialCentavosMeta,
        ),
      );
    }
    if (data.containsKey('fecha_saldo_inicial')) {
      context.handle(
        _fechaSaldoInicialMeta,
        fechaSaldoInicial.isAcceptableOrUnknown(
          data['fecha_saldo_inicial']!,
          _fechaSaldoInicialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaSaldoInicialMeta);
    }
    if (data.containsKey('limite_centavos')) {
      context.handle(
        _limiteCentavosMeta,
        limiteCentavos.isAcceptableOrUnknown(
          data['limite_centavos']!,
          _limiteCentavosMeta,
        ),
      );
    }
    if (data.containsKey('dia_corte')) {
      context.handle(
        _diaCorteMeta,
        diaCorte.isAcceptableOrUnknown(data['dia_corte']!, _diaCorteMeta),
      );
    }
    if (data.containsKey('dia_pago')) {
      context.handle(
        _diaPagoMeta,
        diaPago.isAcceptableOrUnknown(data['dia_pago']!, _diaPagoMeta),
      );
    }
    if (data.containsKey('dias_recordatorio')) {
      context.handle(
        _diasRecordatorioMeta,
        diasRecordatorio.isAcceptableOrUnknown(
          data['dias_recordatorio']!,
          _diasRecordatorioMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuentaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuentaFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: $CuentasTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
      saldoInicialCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_inicial_centavos'],
      )!,
      fechaSaldoInicial: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_saldo_inicial'],
      )!,
      limiteCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limite_centavos'],
      ),
      diaCorte: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_corte'],
      ),
      diaPago: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_pago'],
      ),
      diasRecordatorio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dias_recordatorio'],
      )!,
    );
  }

  @override
  $CuentasTable createAlias(String alias) {
    return $CuentasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoCuenta, int, int> $convertertipo =
      const EnumIndexConverter<TipoCuenta>(TipoCuenta.values);
}

class CuentaFila extends DataClass implements Insertable<CuentaFila> {
  final int id;
  final String nombre;
  final TipoCuenta tipo;
  final String color;

  /// Nombres alternativos, uno por línea.
  final String alias;
  final int saldoInicialCentavos;
  final DateTime fechaSaldoInicial;
  final int? limiteCentavos;
  final int? diaCorte;
  final int? diaPago;
  final int diasRecordatorio;
  const CuentaFila({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.color,
    required this.alias,
    required this.saldoInicialCentavos,
    required this.fechaSaldoInicial,
    this.limiteCentavos,
    this.diaCorte,
    this.diaPago,
    required this.diasRecordatorio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    {
      map['tipo'] = Variable<int>($CuentasTable.$convertertipo.toSql(tipo));
    }
    map['color'] = Variable<String>(color);
    map['alias'] = Variable<String>(alias);
    map['saldo_inicial_centavos'] = Variable<int>(saldoInicialCentavos);
    map['fecha_saldo_inicial'] = Variable<DateTime>(fechaSaldoInicial);
    if (!nullToAbsent || limiteCentavos != null) {
      map['limite_centavos'] = Variable<int>(limiteCentavos);
    }
    if (!nullToAbsent || diaCorte != null) {
      map['dia_corte'] = Variable<int>(diaCorte);
    }
    if (!nullToAbsent || diaPago != null) {
      map['dia_pago'] = Variable<int>(diaPago);
    }
    map['dias_recordatorio'] = Variable<int>(diasRecordatorio);
    return map;
  }

  CuentasCompanion toCompanion(bool nullToAbsent) {
    return CuentasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipo: Value(tipo),
      color: Value(color),
      alias: Value(alias),
      saldoInicialCentavos: Value(saldoInicialCentavos),
      fechaSaldoInicial: Value(fechaSaldoInicial),
      limiteCentavos: limiteCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(limiteCentavos),
      diaCorte: diaCorte == null && nullToAbsent
          ? const Value.absent()
          : Value(diaCorte),
      diaPago: diaPago == null && nullToAbsent
          ? const Value.absent()
          : Value(diaPago),
      diasRecordatorio: Value(diasRecordatorio),
    );
  }

  factory CuentaFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuentaFila(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: $CuentasTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      color: serializer.fromJson<String>(json['color']),
      alias: serializer.fromJson<String>(json['alias']),
      saldoInicialCentavos: serializer.fromJson<int>(
        json['saldoInicialCentavos'],
      ),
      fechaSaldoInicial: serializer.fromJson<DateTime>(
        json['fechaSaldoInicial'],
      ),
      limiteCentavos: serializer.fromJson<int?>(json['limiteCentavos']),
      diaCorte: serializer.fromJson<int?>(json['diaCorte']),
      diaPago: serializer.fromJson<int?>(json['diaPago']),
      diasRecordatorio: serializer.fromJson<int>(json['diasRecordatorio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<int>($CuentasTable.$convertertipo.toJson(tipo)),
      'color': serializer.toJson<String>(color),
      'alias': serializer.toJson<String>(alias),
      'saldoInicialCentavos': serializer.toJson<int>(saldoInicialCentavos),
      'fechaSaldoInicial': serializer.toJson<DateTime>(fechaSaldoInicial),
      'limiteCentavos': serializer.toJson<int?>(limiteCentavos),
      'diaCorte': serializer.toJson<int?>(diaCorte),
      'diaPago': serializer.toJson<int?>(diaPago),
      'diasRecordatorio': serializer.toJson<int>(diasRecordatorio),
    };
  }

  CuentaFila copyWith({
    int? id,
    String? nombre,
    TipoCuenta? tipo,
    String? color,
    String? alias,
    int? saldoInicialCentavos,
    DateTime? fechaSaldoInicial,
    Value<int?> limiteCentavos = const Value.absent(),
    Value<int?> diaCorte = const Value.absent(),
    Value<int?> diaPago = const Value.absent(),
    int? diasRecordatorio,
  }) => CuentaFila(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    color: color ?? this.color,
    alias: alias ?? this.alias,
    saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
    fechaSaldoInicial: fechaSaldoInicial ?? this.fechaSaldoInicial,
    limiteCentavos: limiteCentavos.present
        ? limiteCentavos.value
        : this.limiteCentavos,
    diaCorte: diaCorte.present ? diaCorte.value : this.diaCorte,
    diaPago: diaPago.present ? diaPago.value : this.diaPago,
    diasRecordatorio: diasRecordatorio ?? this.diasRecordatorio,
  );
  CuentaFila copyWithCompanion(CuentasCompanion data) {
    return CuentaFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      color: data.color.present ? data.color.value : this.color,
      alias: data.alias.present ? data.alias.value : this.alias,
      saldoInicialCentavos: data.saldoInicialCentavos.present
          ? data.saldoInicialCentavos.value
          : this.saldoInicialCentavos,
      fechaSaldoInicial: data.fechaSaldoInicial.present
          ? data.fechaSaldoInicial.value
          : this.fechaSaldoInicial,
      limiteCentavos: data.limiteCentavos.present
          ? data.limiteCentavos.value
          : this.limiteCentavos,
      diaCorte: data.diaCorte.present ? data.diaCorte.value : this.diaCorte,
      diaPago: data.diaPago.present ? data.diaPago.value : this.diaPago,
      diasRecordatorio: data.diasRecordatorio.present
          ? data.diasRecordatorio.value
          : this.diasRecordatorio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuentaFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('color: $color, ')
          ..write('alias: $alias, ')
          ..write('saldoInicialCentavos: $saldoInicialCentavos, ')
          ..write('fechaSaldoInicial: $fechaSaldoInicial, ')
          ..write('limiteCentavos: $limiteCentavos, ')
          ..write('diaCorte: $diaCorte, ')
          ..write('diaPago: $diaPago, ')
          ..write('diasRecordatorio: $diasRecordatorio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    tipo,
    color,
    alias,
    saldoInicialCentavos,
    fechaSaldoInicial,
    limiteCentavos,
    diaCorte,
    diaPago,
    diasRecordatorio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuentaFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.color == this.color &&
          other.alias == this.alias &&
          other.saldoInicialCentavos == this.saldoInicialCentavos &&
          other.fechaSaldoInicial == this.fechaSaldoInicial &&
          other.limiteCentavos == this.limiteCentavos &&
          other.diaCorte == this.diaCorte &&
          other.diaPago == this.diaPago &&
          other.diasRecordatorio == this.diasRecordatorio);
}

class CuentasCompanion extends UpdateCompanion<CuentaFila> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<TipoCuenta> tipo;
  final Value<String> color;
  final Value<String> alias;
  final Value<int> saldoInicialCentavos;
  final Value<DateTime> fechaSaldoInicial;
  final Value<int?> limiteCentavos;
  final Value<int?> diaCorte;
  final Value<int?> diaPago;
  final Value<int> diasRecordatorio;
  const CuentasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.color = const Value.absent(),
    this.alias = const Value.absent(),
    this.saldoInicialCentavos = const Value.absent(),
    this.fechaSaldoInicial = const Value.absent(),
    this.limiteCentavos = const Value.absent(),
    this.diaCorte = const Value.absent(),
    this.diaPago = const Value.absent(),
    this.diasRecordatorio = const Value.absent(),
  });
  CuentasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required TipoCuenta tipo,
    required String color,
    this.alias = const Value.absent(),
    this.saldoInicialCentavos = const Value.absent(),
    required DateTime fechaSaldoInicial,
    this.limiteCentavos = const Value.absent(),
    this.diaCorte = const Value.absent(),
    this.diaPago = const Value.absent(),
    this.diasRecordatorio = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo),
       color = Value(color),
       fechaSaldoInicial = Value(fechaSaldoInicial);
  static Insertable<CuentaFila> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? tipo,
    Expression<String>? color,
    Expression<String>? alias,
    Expression<int>? saldoInicialCentavos,
    Expression<DateTime>? fechaSaldoInicial,
    Expression<int>? limiteCentavos,
    Expression<int>? diaCorte,
    Expression<int>? diaPago,
    Expression<int>? diasRecordatorio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (color != null) 'color': color,
      if (alias != null) 'alias': alias,
      if (saldoInicialCentavos != null)
        'saldo_inicial_centavos': saldoInicialCentavos,
      if (fechaSaldoInicial != null) 'fecha_saldo_inicial': fechaSaldoInicial,
      if (limiteCentavos != null) 'limite_centavos': limiteCentavos,
      if (diaCorte != null) 'dia_corte': diaCorte,
      if (diaPago != null) 'dia_pago': diaPago,
      if (diasRecordatorio != null) 'dias_recordatorio': diasRecordatorio,
    });
  }

  CuentasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<TipoCuenta>? tipo,
    Value<String>? color,
    Value<String>? alias,
    Value<int>? saldoInicialCentavos,
    Value<DateTime>? fechaSaldoInicial,
    Value<int?>? limiteCentavos,
    Value<int?>? diaCorte,
    Value<int?>? diaPago,
    Value<int>? diasRecordatorio,
  }) {
    return CuentasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      color: color ?? this.color,
      alias: alias ?? this.alias,
      saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
      fechaSaldoInicial: fechaSaldoInicial ?? this.fechaSaldoInicial,
      limiteCentavos: limiteCentavos ?? this.limiteCentavos,
      diaCorte: diaCorte ?? this.diaCorte,
      diaPago: diaPago ?? this.diaPago,
      diasRecordatorio: diasRecordatorio ?? this.diasRecordatorio,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(
        $CuentasTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (saldoInicialCentavos.present) {
      map['saldo_inicial_centavos'] = Variable<int>(saldoInicialCentavos.value);
    }
    if (fechaSaldoInicial.present) {
      map['fecha_saldo_inicial'] = Variable<DateTime>(fechaSaldoInicial.value);
    }
    if (limiteCentavos.present) {
      map['limite_centavos'] = Variable<int>(limiteCentavos.value);
    }
    if (diaCorte.present) {
      map['dia_corte'] = Variable<int>(diaCorte.value);
    }
    if (diaPago.present) {
      map['dia_pago'] = Variable<int>(diaPago.value);
    }
    if (diasRecordatorio.present) {
      map['dias_recordatorio'] = Variable<int>(diasRecordatorio.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('color: $color, ')
          ..write('alias: $alias, ')
          ..write('saldoInicialCentavos: $saldoInicialCentavos, ')
          ..write('fechaSaldoInicial: $fechaSaldoInicial, ')
          ..write('limiteCentavos: $limiteCentavos, ')
          ..write('diaCorte: $diaCorte, ')
          ..write('diaPago: $diaPago, ')
          ..write('diasRecordatorio: $diasRecordatorio')
          ..write(')'))
        .toString();
  }
}

class $ComprasTable extends Compras with TableInfo<$ComprasTable, CompraFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComprasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _comercioMeta = const VerificationMeta(
    'comercio',
  );
  @override
  late final GeneratedColumn<String> comercio = GeneratedColumn<String>(
    'comercio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tarjetaMeta = const VerificationMeta(
    'tarjeta',
  );
  @override
  late final GeneratedColumn<String> tarjeta = GeneratedColumn<String>(
    'tarjeta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrigenCompra, int> origen =
      GeneratedColumn<int>(
        'origen',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<OrigenCompra>($ComprasTable.$converterorigen);
  static const VerificationMeta _cuentaIdMeta = const VerificationMeta(
    'cuentaId',
  );
  @override
  late final GeneratedColumn<int> cuentaId = GeneratedColumn<int>(
    'cuenta_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    comercio,
    montoCentavos,
    tarjeta,
    categoriaId,
    fecha,
    origen,
    cuentaId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compras';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompraFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('comercio')) {
      context.handle(
        _comercioMeta,
        comercio.isAcceptableOrUnknown(data['comercio']!, _comercioMeta),
      );
    } else if (isInserting) {
      context.missing(_comercioMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('tarjeta')) {
      context.handle(
        _tarjetaMeta,
        tarjeta.isAcceptableOrUnknown(data['tarjeta']!, _tarjetaMeta),
      );
    } else if (isInserting) {
      context.missing(_tarjetaMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('cuenta_id')) {
      context.handle(
        _cuentaIdMeta,
        cuentaId.isAcceptableOrUnknown(data['cuenta_id']!, _cuentaIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompraFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompraFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      comercio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comercio'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      tarjeta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tarjeta'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      origen: $ComprasTable.$converterorigen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}origen'],
        )!,
      ),
      cuentaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_id'],
      ),
    );
  }

  @override
  $ComprasTable createAlias(String alias) {
    return $ComprasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrigenCompra, int, int> $converterorigen =
      const EnumIndexConverter<OrigenCompra>(OrigenCompra.values);
}

class CompraFila extends DataClass implements Insertable<CompraFila> {
  final String id;
  final String comercio;
  final int montoCentavos;
  final String tarjeta;

  /// Null = sin categoría (ninguna regla coincidió o se borró la categoría).
  final int? categoriaId;
  final DateTime fecha;
  final OrigenCompra origen;

  /// v3. Null si se borró la cuenta (la compra conserva el nombre en
  /// [tarjeta]).
  final int? cuentaId;
  const CompraFila({
    required this.id,
    required this.comercio,
    required this.montoCentavos,
    required this.tarjeta,
    this.categoriaId,
    required this.fecha,
    required this.origen,
    this.cuentaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['comercio'] = Variable<String>(comercio);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    map['tarjeta'] = Variable<String>(tarjeta);
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    {
      map['origen'] = Variable<int>(
        $ComprasTable.$converterorigen.toSql(origen),
      );
    }
    if (!nullToAbsent || cuentaId != null) {
      map['cuenta_id'] = Variable<int>(cuentaId);
    }
    return map;
  }

  ComprasCompanion toCompanion(bool nullToAbsent) {
    return ComprasCompanion(
      id: Value(id),
      comercio: Value(comercio),
      montoCentavos: Value(montoCentavos),
      tarjeta: Value(tarjeta),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      fecha: Value(fecha),
      origen: Value(origen),
      cuentaId: cuentaId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuentaId),
    );
  }

  factory CompraFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompraFila(
      id: serializer.fromJson<String>(json['id']),
      comercio: serializer.fromJson<String>(json['comercio']),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
      tarjeta: serializer.fromJson<String>(json['tarjeta']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      origen: $ComprasTable.$converterorigen.fromJson(
        serializer.fromJson<int>(json['origen']),
      ),
      cuentaId: serializer.fromJson<int?>(json['cuentaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'comercio': serializer.toJson<String>(comercio),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
      'tarjeta': serializer.toJson<String>(tarjeta),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'origen': serializer.toJson<int>(
        $ComprasTable.$converterorigen.toJson(origen),
      ),
      'cuentaId': serializer.toJson<int?>(cuentaId),
    };
  }

  CompraFila copyWith({
    String? id,
    String? comercio,
    int? montoCentavos,
    String? tarjeta,
    Value<int?> categoriaId = const Value.absent(),
    DateTime? fecha,
    OrigenCompra? origen,
    Value<int?> cuentaId = const Value.absent(),
  }) => CompraFila(
    id: id ?? this.id,
    comercio: comercio ?? this.comercio,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    tarjeta: tarjeta ?? this.tarjeta,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    fecha: fecha ?? this.fecha,
    origen: origen ?? this.origen,
    cuentaId: cuentaId.present ? cuentaId.value : this.cuentaId,
  );
  CompraFila copyWithCompanion(ComprasCompanion data) {
    return CompraFila(
      id: data.id.present ? data.id.value : this.id,
      comercio: data.comercio.present ? data.comercio.value : this.comercio,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      tarjeta: data.tarjeta.present ? data.tarjeta.value : this.tarjeta,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      origen: data.origen.present ? data.origen.value : this.origen,
      cuentaId: data.cuentaId.present ? data.cuentaId.value : this.cuentaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompraFila(')
          ..write('id: $id, ')
          ..write('comercio: $comercio, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('tarjeta: $tarjeta, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('fecha: $fecha, ')
          ..write('origen: $origen, ')
          ..write('cuentaId: $cuentaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    comercio,
    montoCentavos,
    tarjeta,
    categoriaId,
    fecha,
    origen,
    cuentaId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompraFila &&
          other.id == this.id &&
          other.comercio == this.comercio &&
          other.montoCentavos == this.montoCentavos &&
          other.tarjeta == this.tarjeta &&
          other.categoriaId == this.categoriaId &&
          other.fecha == this.fecha &&
          other.origen == this.origen &&
          other.cuentaId == this.cuentaId);
}

class ComprasCompanion extends UpdateCompanion<CompraFila> {
  final Value<String> id;
  final Value<String> comercio;
  final Value<int> montoCentavos;
  final Value<String> tarjeta;
  final Value<int?> categoriaId;
  final Value<DateTime> fecha;
  final Value<OrigenCompra> origen;
  final Value<int?> cuentaId;
  final Value<int> rowid;
  const ComprasCompanion({
    this.id = const Value.absent(),
    this.comercio = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.tarjeta = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.origen = const Value.absent(),
    this.cuentaId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComprasCompanion.insert({
    required String id,
    required String comercio,
    required int montoCentavos,
    required String tarjeta,
    this.categoriaId = const Value.absent(),
    required DateTime fecha,
    required OrigenCompra origen,
    this.cuentaId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       comercio = Value(comercio),
       montoCentavos = Value(montoCentavos),
       tarjeta = Value(tarjeta),
       fecha = Value(fecha),
       origen = Value(origen);
  static Insertable<CompraFila> custom({
    Expression<String>? id,
    Expression<String>? comercio,
    Expression<int>? montoCentavos,
    Expression<String>? tarjeta,
    Expression<int>? categoriaId,
    Expression<DateTime>? fecha,
    Expression<int>? origen,
    Expression<int>? cuentaId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (comercio != null) 'comercio': comercio,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (tarjeta != null) 'tarjeta': tarjeta,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (fecha != null) 'fecha': fecha,
      if (origen != null) 'origen': origen,
      if (cuentaId != null) 'cuenta_id': cuentaId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComprasCompanion copyWith({
    Value<String>? id,
    Value<String>? comercio,
    Value<int>? montoCentavos,
    Value<String>? tarjeta,
    Value<int?>? categoriaId,
    Value<DateTime>? fecha,
    Value<OrigenCompra>? origen,
    Value<int?>? cuentaId,
    Value<int>? rowid,
  }) {
    return ComprasCompanion(
      id: id ?? this.id,
      comercio: comercio ?? this.comercio,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      tarjeta: tarjeta ?? this.tarjeta,
      categoriaId: categoriaId ?? this.categoriaId,
      fecha: fecha ?? this.fecha,
      origen: origen ?? this.origen,
      cuentaId: cuentaId ?? this.cuentaId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (comercio.present) {
      map['comercio'] = Variable<String>(comercio.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (tarjeta.present) {
      map['tarjeta'] = Variable<String>(tarjeta.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (origen.present) {
      map['origen'] = Variable<int>(
        $ComprasTable.$converterorigen.toSql(origen.value),
      );
    }
    if (cuentaId.present) {
      map['cuenta_id'] = Variable<int>(cuentaId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComprasCompanion(')
          ..write('id: $id, ')
          ..write('comercio: $comercio, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('tarjeta: $tarjeta, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('fecha: $fecha, ')
          ..write('origen: $origen, ')
          ..write('cuentaId: $cuentaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresupuestosTable extends Presupuestos
    with TableInfo<$PresupuestosTable, PresupuestoFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresupuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [categoriaId, montoCentavos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presupuestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresupuestoFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoriaId};
  @override
  PresupuestoFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresupuestoFila(
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
    );
  }

  @override
  $PresupuestosTable createAlias(String alias) {
    return $PresupuestosTable(attachedDatabase, alias);
  }
}

class PresupuestoFila extends DataClass implements Insertable<PresupuestoFila> {
  final int categoriaId;
  final int montoCentavos;
  const PresupuestoFila({
    required this.categoriaId,
    required this.montoCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['categoria_id'] = Variable<int>(categoriaId);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    return map;
  }

  PresupuestosCompanion toCompanion(bool nullToAbsent) {
    return PresupuestosCompanion(
      categoriaId: Value(categoriaId),
      montoCentavos: Value(montoCentavos),
    );
  }

  factory PresupuestoFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresupuestoFila(
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoriaId': serializer.toJson<int>(categoriaId),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
    };
  }

  PresupuestoFila copyWith({int? categoriaId, int? montoCentavos}) =>
      PresupuestoFila(
        categoriaId: categoriaId ?? this.categoriaId,
        montoCentavos: montoCentavos ?? this.montoCentavos,
      );
  PresupuestoFila copyWithCompanion(PresupuestosCompanion data) {
    return PresupuestoFila(
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestoFila(')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCentavos: $montoCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoriaId, montoCentavos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresupuestoFila &&
          other.categoriaId == this.categoriaId &&
          other.montoCentavos == this.montoCentavos);
}

class PresupuestosCompanion extends UpdateCompanion<PresupuestoFila> {
  final Value<int> categoriaId;
  final Value<int> montoCentavos;
  const PresupuestosCompanion({
    this.categoriaId = const Value.absent(),
    this.montoCentavos = const Value.absent(),
  });
  PresupuestosCompanion.insert({
    this.categoriaId = const Value.absent(),
    required int montoCentavos,
  }) : montoCentavos = Value(montoCentavos);
  static Insertable<PresupuestoFila> custom({
    Expression<int>? categoriaId,
    Expression<int>? montoCentavos,
  }) {
    return RawValuesInsertable({
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
    });
  }

  PresupuestosCompanion copyWith({
    Value<int>? categoriaId,
    Value<int>? montoCentavos,
  }) {
    return PresupuestosCompanion(
      categoriaId: categoriaId ?? this.categoriaId,
      montoCentavos: montoCentavos ?? this.montoCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestosCompanion(')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCentavos: $montoCentavos')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, MovimientoFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMovimiento, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoMovimiento>($MovimientosTable.$convertertipo);
  static const VerificationMeta _cuentaOrigenIdMeta = const VerificationMeta(
    'cuentaOrigenId',
  );
  @override
  late final GeneratedColumn<int> cuentaOrigenId = GeneratedColumn<int>(
    'cuenta_origen_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _cuentaDestinoIdMeta = const VerificationMeta(
    'cuentaDestinoId',
  );
  @override
  late final GeneratedColumn<int> cuentaDestinoId = GeneratedColumn<int>(
    'cuenta_destino_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    cuentaOrigenId,
    cuentaDestinoId,
    montoCentavos,
    fecha,
    nota,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cuenta_origen_id')) {
      context.handle(
        _cuentaOrigenIdMeta,
        cuentaOrigenId.isAcceptableOrUnknown(
          data['cuenta_origen_id']!,
          _cuentaOrigenIdMeta,
        ),
      );
    }
    if (data.containsKey('cuenta_destino_id')) {
      context.handle(
        _cuentaDestinoIdMeta,
        cuentaDestinoId.isAcceptableOrUnknown(
          data['cuenta_destino_id']!,
          _cuentaDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tipo: $MovimientosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      cuentaOrigenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_origen_id'],
      ),
      cuentaDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_destino_id'],
      ),
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      )!,
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMovimiento, int, int> $convertertipo =
      const EnumIndexConverter<TipoMovimiento>(TipoMovimiento.values);
}

class MovimientoFila extends DataClass implements Insertable<MovimientoFila> {
  final String id;
  final TipoMovimiento tipo;
  final int? cuentaOrigenId;
  final int? cuentaDestinoId;
  final int montoCentavos;
  final DateTime fecha;
  final String nota;
  const MovimientoFila({
    required this.id,
    required this.tipo,
    this.cuentaOrigenId,
    this.cuentaDestinoId,
    required this.montoCentavos,
    required this.fecha,
    required this.nota,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['tipo'] = Variable<int>($MovimientosTable.$convertertipo.toSql(tipo));
    }
    if (!nullToAbsent || cuentaOrigenId != null) {
      map['cuenta_origen_id'] = Variable<int>(cuentaOrigenId);
    }
    if (!nullToAbsent || cuentaDestinoId != null) {
      map['cuenta_destino_id'] = Variable<int>(cuentaDestinoId);
    }
    map['monto_centavos'] = Variable<int>(montoCentavos);
    map['fecha'] = Variable<DateTime>(fecha);
    map['nota'] = Variable<String>(nota);
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      tipo: Value(tipo),
      cuentaOrigenId: cuentaOrigenId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuentaOrigenId),
      cuentaDestinoId: cuentaDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuentaDestinoId),
      montoCentavos: Value(montoCentavos),
      fecha: Value(fecha),
      nota: Value(nota),
    );
  }

  factory MovimientoFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoFila(
      id: serializer.fromJson<String>(json['id']),
      tipo: $MovimientosTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      cuentaOrigenId: serializer.fromJson<int?>(json['cuentaOrigenId']),
      cuentaDestinoId: serializer.fromJson<int?>(json['cuentaDestinoId']),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      nota: serializer.fromJson<String>(json['nota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<int>(
        $MovimientosTable.$convertertipo.toJson(tipo),
      ),
      'cuentaOrigenId': serializer.toJson<int?>(cuentaOrigenId),
      'cuentaDestinoId': serializer.toJson<int?>(cuentaDestinoId),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
      'fecha': serializer.toJson<DateTime>(fecha),
      'nota': serializer.toJson<String>(nota),
    };
  }

  MovimientoFila copyWith({
    String? id,
    TipoMovimiento? tipo,
    Value<int?> cuentaOrigenId = const Value.absent(),
    Value<int?> cuentaDestinoId = const Value.absent(),
    int? montoCentavos,
    DateTime? fecha,
    String? nota,
  }) => MovimientoFila(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    cuentaOrigenId: cuentaOrigenId.present
        ? cuentaOrigenId.value
        : this.cuentaOrigenId,
    cuentaDestinoId: cuentaDestinoId.present
        ? cuentaDestinoId.value
        : this.cuentaDestinoId,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    fecha: fecha ?? this.fecha,
    nota: nota ?? this.nota,
  );
  MovimientoFila copyWithCompanion(MovimientosCompanion data) {
    return MovimientoFila(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cuentaOrigenId: data.cuentaOrigenId.present
          ? data.cuentaOrigenId.value
          : this.cuentaOrigenId,
      cuentaDestinoId: data.cuentaDestinoId.present
          ? data.cuentaDestinoId.value
          : this.cuentaDestinoId,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      nota: data.nota.present ? data.nota.value : this.nota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoFila(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('cuentaOrigenId: $cuentaOrigenId, ')
          ..write('cuentaDestinoId: $cuentaDestinoId, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    cuentaOrigenId,
    cuentaDestinoId,
    montoCentavos,
    fecha,
    nota,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoFila &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.cuentaOrigenId == this.cuentaOrigenId &&
          other.cuentaDestinoId == this.cuentaDestinoId &&
          other.montoCentavos == this.montoCentavos &&
          other.fecha == this.fecha &&
          other.nota == this.nota);
}

class MovimientosCompanion extends UpdateCompanion<MovimientoFila> {
  final Value<String> id;
  final Value<TipoMovimiento> tipo;
  final Value<int?> cuentaOrigenId;
  final Value<int?> cuentaDestinoId;
  final Value<int> montoCentavos;
  final Value<DateTime> fecha;
  final Value<String> nota;
  final Value<int> rowid;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cuentaOrigenId = const Value.absent(),
    this.cuentaDestinoId = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovimientosCompanion.insert({
    required String id,
    required TipoMovimiento tipo,
    this.cuentaOrigenId = const Value.absent(),
    this.cuentaDestinoId = const Value.absent(),
    required int montoCentavos,
    required DateTime fecha,
    this.nota = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tipo = Value(tipo),
       montoCentavos = Value(montoCentavos),
       fecha = Value(fecha);
  static Insertable<MovimientoFila> custom({
    Expression<String>? id,
    Expression<int>? tipo,
    Expression<int>? cuentaOrigenId,
    Expression<int>? cuentaDestinoId,
    Expression<int>? montoCentavos,
    Expression<DateTime>? fecha,
    Expression<String>? nota,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (cuentaOrigenId != null) 'cuenta_origen_id': cuentaOrigenId,
      if (cuentaDestinoId != null) 'cuenta_destino_id': cuentaDestinoId,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (fecha != null) 'fecha': fecha,
      if (nota != null) 'nota': nota,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovimientosCompanion copyWith({
    Value<String>? id,
    Value<TipoMovimiento>? tipo,
    Value<int?>? cuentaOrigenId,
    Value<int?>? cuentaDestinoId,
    Value<int>? montoCentavos,
    Value<DateTime>? fecha,
    Value<String>? nota,
    Value<int>? rowid,
  }) {
    return MovimientosCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      cuentaOrigenId: cuentaOrigenId ?? this.cuentaOrigenId,
      cuentaDestinoId: cuentaDestinoId ?? this.cuentaDestinoId,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(
        $MovimientosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (cuentaOrigenId.present) {
      map['cuenta_origen_id'] = Variable<int>(cuentaOrigenId.value);
    }
    if (cuentaDestinoId.present) {
      map['cuenta_destino_id'] = Variable<int>(cuentaDestinoId.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('cuentaOrigenId: $cuentaOrigenId, ')
          ..write('cuentaDestinoId: $cuentaDestinoId, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDatos extends GeneratedDatabase {
  _$BaseDatos(QueryExecutor e) : super(e);
  $BaseDatosManager get managers => $BaseDatosManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $ReglasTable reglas = $ReglasTable(this);
  late final $CuentasTable cuentas = $CuentasTable(this);
  late final $ComprasTable compras = $ComprasTable(this);
  late final $PresupuestosTable presupuestos = $PresupuestosTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categorias,
    reglas,
    cuentas,
    compras,
    presupuestos,
    movimientos,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reglas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('compras', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuentas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('compras', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('presupuestos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuentas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimientos', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuentas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimientos', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$CategoriasTableCreateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  required String nombre,
  required String icono,
  required String color,
});
typedef $$CategoriasTableUpdateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> icono,
  Value<String> color,
});

final class $$CategoriasTableReferences
    extends BaseReferences<_$BaseDatos, $CategoriasTable, CategoriaFila> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReglasTable, List<ReglaFila>> _reglasRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.reglas,
    aliasName: 'categorias__id__reglas__categoria_id',
  );

  $$ReglasTableProcessedTableManager get reglasRefs {
    final manager = $$ReglasTableTableManager(
      $_db,
      $_db.reglas,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reglasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ComprasTable, List<CompraFila>> _comprasRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.compras,
    aliasName: 'categorias__id__compras__categoria_id',
  );

  $$ComprasTableProcessedTableManager get comprasRefs {
    final manager = $$ComprasTableTableManager(
      $_db,
      $_db.compras,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_comprasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PresupuestosTable, List<PresupuestoFila>>
  _presupuestosRefsTable(_$BaseDatos db) => MultiTypedResultKey.fromTable(
    db.presupuestos,
    aliasName: 'categorias__id__presupuestos__categoria_id',
  );

  $$PresupuestosTableProcessedTableManager get presupuestosRefs {
    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_presupuestosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$BaseDatos, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reglasRefs(
    Expression<bool> Function($$ReglasTableFilterComposer f) f,
  ) {
    final $$ReglasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reglas,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglasTableFilterComposer(
            $db: $db,
            $table: $db.reglas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> comprasRefs(
    Expression<bool> Function($$ComprasTableFilterComposer f) f,
  ) {
    final $$ComprasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableFilterComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> presupuestosRefs(
    Expression<bool> Function($$PresupuestosTableFilterComposer f) f,
  ) {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$BaseDatos, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$BaseDatos, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> reglasRefs<T extends Object>(
    Expression<T> Function($$ReglasTableAnnotationComposer a) f,
  ) {
    final $$ReglasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reglas,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReglasTableAnnotationComposer(
            $db: $db,
            $table: $db.reglas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> comprasRefs<T extends Object>(
    Expression<T> Function($$ComprasTableAnnotationComposer a) f,
  ) {
    final $$ComprasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableAnnotationComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> presupuestosRefs<T extends Object>(
    Expression<T> Function($$PresupuestosTableAnnotationComposer a) f,
  ) {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $CategoriasTable,
          CategoriaFila,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (CategoriaFila, $$CategoriasTableReferences),
          CategoriaFila,
          PrefetchHooks Function({
            bool reglasRefs,
            bool comprasRefs,
            bool presupuestosRefs,
          })
        > {
  $$CategoriasTableTableManager(_$BaseDatos db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<String> color = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                icono: icono,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String icono,
                required String color,
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                icono: icono,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriasTable, CategoriaFila>(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                reglasRefs = false,
                comprasRefs = false,
                presupuestosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reglasRefs) db.reglas,
                    if (comprasRefs) db.compras,
                    if (presupuestosRefs) db.presupuestos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reglasRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoriaFila,
                          $CategoriasTable,
                          ReglaFila,
                          $ReglasTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._reglasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).reglasRefs,
                          currentColumn: 'id',
                          referencedColumn: 'categoria_id',
                          typedResults: items,
                        ),
                      if (comprasRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoriaFila,
                          $CategoriasTable,
                          CompraFila,
                          $ComprasTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._comprasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).comprasRefs,
                          currentColumn: 'id',
                          referencedColumn: 'categoria_id',
                          typedResults: items,
                        ),
                      if (presupuestosRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoriaFila,
                          $CategoriasTable,
                          PresupuestoFila,
                          $PresupuestosTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._presupuestosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).presupuestosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'categoria_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $CategoriasTable,
      CategoriaFila,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (CategoriaFila, $$CategoriasTableReferences),
      CategoriaFila,
      PrefetchHooks Function({
        bool reglasRefs,
        bool comprasRefs,
        bool presupuestosRefs,
      })
    >;
typedef $$ReglasTableCreateCompanionBuilder = ReglasCompanion Function({
  Value<int> id,
  required String patron,
  required int categoriaId,
});
typedef $$ReglasTableUpdateCompanionBuilder = ReglasCompanion Function({
  Value<int> id,
  Value<String> patron,
  Value<int> categoriaId,
});

final class $$ReglasTableReferences
    extends BaseReferences<_$BaseDatos, $ReglasTable, ReglaFila> {
  $$ReglasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$BaseDatos db) =>
      db.categorias.createAlias('reglas__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReglasTableFilterComposer extends Composer<_$BaseDatos, $ReglasTable> {
  $$ReglasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patron => $composableBuilder(
    column: $table.patron,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReglasTableOrderingComposer
    extends Composer<_$BaseDatos, $ReglasTable> {
  $$ReglasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patron => $composableBuilder(
    column: $table.patron,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReglasTableAnnotationComposer
    extends Composer<_$BaseDatos, $ReglasTable> {
  $$ReglasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patron =>
      $composableBuilder(column: $table.patron, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReglasTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $ReglasTable,
          ReglaFila,
          $$ReglasTableFilterComposer,
          $$ReglasTableOrderingComposer,
          $$ReglasTableAnnotationComposer,
          $$ReglasTableCreateCompanionBuilder,
          $$ReglasTableUpdateCompanionBuilder,
          (ReglaFila, $$ReglasTableReferences),
          ReglaFila,
          PrefetchHooks Function({bool categoriaId})
        > {
  $$ReglasTableTableManager(_$BaseDatos db, $ReglasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReglasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReglasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReglasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> patron = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
              }) => ReglasCompanion(
                id: id,
                patron: patron,
                categoriaId: categoriaId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String patron,
                required int categoriaId,
              }) => ReglasCompanion.insert(
                id: id,
                patron: patron,
                categoriaId: categoriaId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReglasTable, ReglaFila>(table),
                  $$ReglasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoriaId,
                        referencedTable: $$ReglasTableReferences
                            ._categoriaIdTable(db),
                        referencedColumn: $$ReglasTableReferences
                            ._categoriaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReglasTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $ReglasTable,
      ReglaFila,
      $$ReglasTableFilterComposer,
      $$ReglasTableOrderingComposer,
      $$ReglasTableAnnotationComposer,
      $$ReglasTableCreateCompanionBuilder,
      $$ReglasTableUpdateCompanionBuilder,
      (ReglaFila, $$ReglasTableReferences),
      ReglaFila,
      PrefetchHooks Function({bool categoriaId})
    >;
typedef $$CuentasTableCreateCompanionBuilder = CuentasCompanion Function({
  Value<int> id,
  required String nombre,
  required TipoCuenta tipo,
  required String color,
  Value<String> alias,
  Value<int> saldoInicialCentavos,
  required DateTime fechaSaldoInicial,
  Value<int?> limiteCentavos,
  Value<int?> diaCorte,
  Value<int?> diaPago,
  Value<int> diasRecordatorio,
});
typedef $$CuentasTableUpdateCompanionBuilder = CuentasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<TipoCuenta> tipo,
  Value<String> color,
  Value<String> alias,
  Value<int> saldoInicialCentavos,
  Value<DateTime> fechaSaldoInicial,
  Value<int?> limiteCentavos,
  Value<int?> diaCorte,
  Value<int?> diaPago,
  Value<int> diasRecordatorio,
});

final class $$CuentasTableReferences
    extends BaseReferences<_$BaseDatos, $CuentasTable, CuentaFila> {
  $$CuentasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComprasTable, List<CompraFila>> _comprasRefsTable(
    _$BaseDatos db,
  ) => MultiTypedResultKey.fromTable(
    db.compras,
    aliasName: 'cuentas__id__compras__cuenta_id',
  );

  $$ComprasTableProcessedTableManager get comprasRefs {
    final manager = $$ComprasTableTableManager(
      $_db,
      $_db.compras,
    ).filter((f) => f.cuentaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_comprasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CuentasTableFilterComposer
    extends Composer<_$BaseDatos, $CuentasTable> {
  $$CuentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoCuenta, TipoCuenta, int> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoInicialCentavos => $composableBuilder(
    column: $table.saldoInicialCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaSaldoInicial => $composableBuilder(
    column: $table.fechaSaldoInicial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limiteCentavos => $composableBuilder(
    column: $table.limiteCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaCorte => $composableBuilder(
    column: $table.diaCorte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaPago => $composableBuilder(
    column: $table.diaPago,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diasRecordatorio => $composableBuilder(
    column: $table.diasRecordatorio,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> comprasRefs(
    Expression<bool> Function($$ComprasTableFilterComposer f) f,
  ) {
    final $$ComprasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.cuentaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableFilterComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuentasTableOrderingComposer
    extends Composer<_$BaseDatos, $CuentasTable> {
  $$CuentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoInicialCentavos => $composableBuilder(
    column: $table.saldoInicialCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaSaldoInicial => $composableBuilder(
    column: $table.fechaSaldoInicial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limiteCentavos => $composableBuilder(
    column: $table.limiteCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaCorte => $composableBuilder(
    column: $table.diaCorte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaPago => $composableBuilder(
    column: $table.diaPago,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diasRecordatorio => $composableBuilder(
    column: $table.diasRecordatorio,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CuentasTableAnnotationComposer
    extends Composer<_$BaseDatos, $CuentasTable> {
  $$CuentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCuenta, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<int> get saldoInicialCentavos => $composableBuilder(
    column: $table.saldoInicialCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaSaldoInicial => $composableBuilder(
    column: $table.fechaSaldoInicial,
    builder: (column) => column,
  );

  GeneratedColumn<int> get limiteCentavos => $composableBuilder(
    column: $table.limiteCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaCorte =>
      $composableBuilder(column: $table.diaCorte, builder: (column) => column);

  GeneratedColumn<int> get diaPago =>
      $composableBuilder(column: $table.diaPago, builder: (column) => column);

  GeneratedColumn<int> get diasRecordatorio => $composableBuilder(
    column: $table.diasRecordatorio,
    builder: (column) => column,
  );

  Expression<T> comprasRefs<T extends Object>(
    Expression<T> Function($$ComprasTableAnnotationComposer a) f,
  ) {
    final $$ComprasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.cuentaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableAnnotationComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuentasTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $CuentasTable,
          CuentaFila,
          $$CuentasTableFilterComposer,
          $$CuentasTableOrderingComposer,
          $$CuentasTableAnnotationComposer,
          $$CuentasTableCreateCompanionBuilder,
          $$CuentasTableUpdateCompanionBuilder,
          (CuentaFila, $$CuentasTableReferences),
          CuentaFila,
          PrefetchHooks Function({bool comprasRefs})
        > {
  $$CuentasTableTableManager(_$BaseDatos db, $CuentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<TipoCuenta> tipo = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> alias = const Value.absent(),
                Value<int> saldoInicialCentavos = const Value.absent(),
                Value<DateTime> fechaSaldoInicial = const Value.absent(),
                Value<int?> limiteCentavos = const Value.absent(),
                Value<int?> diaCorte = const Value.absent(),
                Value<int?> diaPago = const Value.absent(),
                Value<int> diasRecordatorio = const Value.absent(),
              }) => CuentasCompanion(
                id: id,
                nombre: nombre,
                tipo: tipo,
                color: color,
                alias: alias,
                saldoInicialCentavos: saldoInicialCentavos,
                fechaSaldoInicial: fechaSaldoInicial,
                limiteCentavos: limiteCentavos,
                diaCorte: diaCorte,
                diaPago: diaPago,
                diasRecordatorio: diasRecordatorio,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required TipoCuenta tipo,
                required String color,
                Value<String> alias = const Value.absent(),
                Value<int> saldoInicialCentavos = const Value.absent(),
                required DateTime fechaSaldoInicial,
                Value<int?> limiteCentavos = const Value.absent(),
                Value<int?> diaCorte = const Value.absent(),
                Value<int?> diaPago = const Value.absent(),
                Value<int> diasRecordatorio = const Value.absent(),
              }) => CuentasCompanion.insert(
                id: id,
                nombre: nombre,
                tipo: tipo,
                color: color,
                alias: alias,
                saldoInicialCentavos: saldoInicialCentavos,
                fechaSaldoInicial: fechaSaldoInicial,
                limiteCentavos: limiteCentavos,
                diaCorte: diaCorte,
                diaPago: diaPago,
                diasRecordatorio: diasRecordatorio,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CuentasTable, CuentaFila>(table),
                  $$CuentasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comprasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (comprasRefs) db.compras],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (comprasRefs)
                    await $_getPrefetchedDataByColumns<
                      CuentaFila,
                      $CuentasTable,
                      CompraFila,
                      $ComprasTable
                    >(
                      currentTable: table,
                      referencedTable: $$CuentasTableReferences
                          ._comprasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CuentasTableReferences(db, table, p0).comprasRefs,
                      currentColumn: 'id',
                      referencedColumn: 'cuenta_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CuentasTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $CuentasTable,
      CuentaFila,
      $$CuentasTableFilterComposer,
      $$CuentasTableOrderingComposer,
      $$CuentasTableAnnotationComposer,
      $$CuentasTableCreateCompanionBuilder,
      $$CuentasTableUpdateCompanionBuilder,
      (CuentaFila, $$CuentasTableReferences),
      CuentaFila,
      PrefetchHooks Function({bool comprasRefs})
    >;
typedef $$ComprasTableCreateCompanionBuilder = ComprasCompanion Function({
  required String id,
  required String comercio,
  required int montoCentavos,
  required String tarjeta,
  Value<int?> categoriaId,
  required DateTime fecha,
  required OrigenCompra origen,
  Value<int?> cuentaId,
  Value<int> rowid,
});
typedef $$ComprasTableUpdateCompanionBuilder = ComprasCompanion Function({
  Value<String> id,
  Value<String> comercio,
  Value<int> montoCentavos,
  Value<String> tarjeta,
  Value<int?> categoriaId,
  Value<DateTime> fecha,
  Value<OrigenCompra> origen,
  Value<int?> cuentaId,
  Value<int> rowid,
});

final class $$ComprasTableReferences
    extends BaseReferences<_$BaseDatos, $ComprasTable, CompraFila> {
  $$ComprasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$BaseDatos db) =>
      db.categorias.createAlias('compras__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CuentasTable _cuentaIdTable(_$BaseDatos db) =>
      db.cuentas.createAlias('compras__cuenta_id__cuentas__id');

  $$CuentasTableProcessedTableManager? get cuentaId {
    final $_column = $_itemColumn<int>('cuenta_id');
    if ($_column == null) return null;
    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ComprasTableFilterComposer
    extends Composer<_$BaseDatos, $ComprasTable> {
  $$ComprasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comercio => $composableBuilder(
    column: $table.comercio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tarjeta => $composableBuilder(
    column: $table.tarjeta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrigenCompra, OrigenCompra, int> get origen =>
      $composableBuilder(
        column: $table.origen,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableFilterComposer get cuentaId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComprasTableOrderingComposer
    extends Composer<_$BaseDatos, $ComprasTable> {
  $$ComprasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comercio => $composableBuilder(
    column: $table.comercio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tarjeta => $composableBuilder(
    column: $table.tarjeta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableOrderingComposer get cuentaId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComprasTableAnnotationComposer
    extends Composer<_$BaseDatos, $ComprasTable> {
  $$ComprasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get comercio =>
      $composableBuilder(column: $table.comercio, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tarjeta =>
      $composableBuilder(column: $table.tarjeta, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrigenCompra, int> get origen =>
      $composableBuilder(column: $table.origen, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableAnnotationComposer get cuentaId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComprasTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $ComprasTable,
          CompraFila,
          $$ComprasTableFilterComposer,
          $$ComprasTableOrderingComposer,
          $$ComprasTableAnnotationComposer,
          $$ComprasTableCreateCompanionBuilder,
          $$ComprasTableUpdateCompanionBuilder,
          (CompraFila, $$ComprasTableReferences),
          CompraFila,
          PrefetchHooks Function({bool categoriaId, bool cuentaId})
        > {
  $$ComprasTableTableManager(_$BaseDatos db, $ComprasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComprasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComprasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComprasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> comercio = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<String> tarjeta = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<OrigenCompra> origen = const Value.absent(),
                Value<int?> cuentaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComprasCompanion(
                id: id,
                comercio: comercio,
                montoCentavos: montoCentavos,
                tarjeta: tarjeta,
                categoriaId: categoriaId,
                fecha: fecha,
                origen: origen,
                cuentaId: cuentaId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String comercio,
                required int montoCentavos,
                required String tarjeta,
                Value<int?> categoriaId = const Value.absent(),
                required DateTime fecha,
                required OrigenCompra origen,
                Value<int?> cuentaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComprasCompanion.insert(
                id: id,
                comercio: comercio,
                montoCentavos: montoCentavos,
                tarjeta: tarjeta,
                categoriaId: categoriaId,
                fecha: fecha,
                origen: origen,
                cuentaId: cuentaId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComprasTable, CompraFila>(table),
                  $$ComprasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false, cuentaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoriaId,
                        referencedTable: $$ComprasTableReferences
                            ._categoriaIdTable(db),
                        referencedColumn: $$ComprasTableReferences
                            ._categoriaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (cuentaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cuentaId,
                        referencedTable: $$ComprasTableReferences
                            ._cuentaIdTable(db),
                        referencedColumn: $$ComprasTableReferences
                            ._cuentaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ComprasTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $ComprasTable,
      CompraFila,
      $$ComprasTableFilterComposer,
      $$ComprasTableOrderingComposer,
      $$ComprasTableAnnotationComposer,
      $$ComprasTableCreateCompanionBuilder,
      $$ComprasTableUpdateCompanionBuilder,
      (CompraFila, $$ComprasTableReferences),
      CompraFila,
      PrefetchHooks Function({bool categoriaId, bool cuentaId})
    >;
typedef $$PresupuestosTableCreateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<int> categoriaId,
      required int montoCentavos,
    });
typedef $$PresupuestosTableUpdateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<int> categoriaId,
      Value<int> montoCentavos,
    });

final class $$PresupuestosTableReferences
    extends BaseReferences<_$BaseDatos, $PresupuestosTable, PresupuestoFila> {
  $$PresupuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$BaseDatos db) =>
      db.categorias.createAlias('presupuestos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PresupuestosTableFilterComposer
    extends Composer<_$BaseDatos, $PresupuestosTable> {
  $$PresupuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableOrderingComposer
    extends Composer<_$BaseDatos, $PresupuestosTable> {
  $$PresupuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableAnnotationComposer
    extends Composer<_$BaseDatos, $PresupuestosTable> {
  $$PresupuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $PresupuestosTable,
          PresupuestoFila,
          $$PresupuestosTableFilterComposer,
          $$PresupuestosTableOrderingComposer,
          $$PresupuestosTableAnnotationComposer,
          $$PresupuestosTableCreateCompanionBuilder,
          $$PresupuestosTableUpdateCompanionBuilder,
          (PresupuestoFila, $$PresupuestosTableReferences),
          PresupuestoFila,
          PrefetchHooks Function({bool categoriaId})
        > {
  $$PresupuestosTableTableManager(_$BaseDatos db, $PresupuestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresupuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresupuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresupuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> categoriaId = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
              }) => PresupuestosCompanion(
                categoriaId: categoriaId,
                montoCentavos: montoCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> categoriaId = const Value.absent(),
                required int montoCentavos,
              }) => PresupuestosCompanion.insert(
                categoriaId: categoriaId,
                montoCentavos: montoCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PresupuestosTable, PresupuestoFila>(table),
                  $$PresupuestosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoriaId,
                        referencedTable: $$PresupuestosTableReferences
                            ._categoriaIdTable(db),
                        referencedColumn: $$PresupuestosTableReferences
                            ._categoriaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PresupuestosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $PresupuestosTable,
      PresupuestoFila,
      $$PresupuestosTableFilterComposer,
      $$PresupuestosTableOrderingComposer,
      $$PresupuestosTableAnnotationComposer,
      $$PresupuestosTableCreateCompanionBuilder,
      $$PresupuestosTableUpdateCompanionBuilder,
      (PresupuestoFila, $$PresupuestosTableReferences),
      PresupuestoFila,
      PrefetchHooks Function({bool categoriaId})
    >;
typedef $$MovimientosTableCreateCompanionBuilder =
    MovimientosCompanion Function({
      required String id,
      required TipoMovimiento tipo,
      Value<int?> cuentaOrigenId,
      Value<int?> cuentaDestinoId,
      required int montoCentavos,
      required DateTime fecha,
      Value<String> nota,
      Value<int> rowid,
    });
typedef $$MovimientosTableUpdateCompanionBuilder =
    MovimientosCompanion Function({
      Value<String> id,
      Value<TipoMovimiento> tipo,
      Value<int?> cuentaOrigenId,
      Value<int?> cuentaDestinoId,
      Value<int> montoCentavos,
      Value<DateTime> fecha,
      Value<String> nota,
      Value<int> rowid,
    });

final class $$MovimientosTableReferences
    extends BaseReferences<_$BaseDatos, $MovimientosTable, MovimientoFila> {
  $$MovimientosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CuentasTable _cuentaOrigenIdTable(_$BaseDatos db) =>
      db.cuentas.createAlias('movimientos__cuenta_origen_id__cuentas__id');

  $$CuentasTableProcessedTableManager? get cuentaOrigenId {
    final $_column = $_itemColumn<int>('cuenta_origen_id');
    if ($_column == null) return null;
    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaOrigenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CuentasTable _cuentaDestinoIdTable(_$BaseDatos db) =>
      db.cuentas.createAlias('movimientos__cuenta_destino_id__cuentas__id');

  $$CuentasTableProcessedTableManager? get cuentaDestinoId {
    final $_column = $_itemColumn<int>('cuenta_destino_id');
    if ($_column == null) return null;
    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosTableFilterComposer
    extends Composer<_$BaseDatos, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMovimiento, TipoMovimiento, int>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  $$CuentasTableFilterComposer get cuentaOrigenId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaOrigenId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableFilterComposer get cuentaDestinoId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaDestinoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$BaseDatos, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  $$CuentasTableOrderingComposer get cuentaOrigenId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaOrigenId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableOrderingComposer get cuentaDestinoId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaDestinoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$BaseDatos, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMovimiento, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  $$CuentasTableAnnotationComposer get cuentaOrigenId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaOrigenId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableAnnotationComposer get cuentaDestinoId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaDestinoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableTableManager
    extends
        RootTableManager<
          _$BaseDatos,
          $MovimientosTable,
          MovimientoFila,
          $$MovimientosTableFilterComposer,
          $$MovimientosTableOrderingComposer,
          $$MovimientosTableAnnotationComposer,
          $$MovimientosTableCreateCompanionBuilder,
          $$MovimientosTableUpdateCompanionBuilder,
          (MovimientoFila, $$MovimientosTableReferences),
          MovimientoFila,
          PrefetchHooks Function({bool cuentaOrigenId, bool cuentaDestinoId})
        > {
  $$MovimientosTableTableManager(_$BaseDatos db, $MovimientosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<TipoMovimiento> tipo = const Value.absent(),
                Value<int?> cuentaOrigenId = const Value.absent(),
                Value<int?> cuentaDestinoId = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> nota = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimientosCompanion(
                id: id,
                tipo: tipo,
                cuentaOrigenId: cuentaOrigenId,
                cuentaDestinoId: cuentaDestinoId,
                montoCentavos: montoCentavos,
                fecha: fecha,
                nota: nota,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required TipoMovimiento tipo,
                Value<int?> cuentaOrigenId = const Value.absent(),
                Value<int?> cuentaDestinoId = const Value.absent(),
                required int montoCentavos,
                required DateTime fecha,
                Value<String> nota = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimientosCompanion.insert(
                id: id,
                tipo: tipo,
                cuentaOrigenId: cuentaOrigenId,
                cuentaDestinoId: cuentaDestinoId,
                montoCentavos: montoCentavos,
                fecha: fecha,
                nota: nota,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MovimientosTable, MovimientoFila>(table),
                  $$MovimientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cuentaOrigenId = false, cuentaDestinoId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cuentaOrigenId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cuentaOrigenId,
                            referencedTable: $$MovimientosTableReferences
                                ._cuentaOrigenIdTable(db),
                            referencedColumn: $$MovimientosTableReferences
                                ._cuentaOrigenIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (cuentaDestinoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cuentaDestinoId,
                            referencedTable: $$MovimientosTableReferences
                                ._cuentaDestinoIdTable(db),
                            referencedColumn: $$MovimientosTableReferences
                                ._cuentaDestinoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$MovimientosTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseDatos,
      $MovimientosTable,
      MovimientoFila,
      $$MovimientosTableFilterComposer,
      $$MovimientosTableOrderingComposer,
      $$MovimientosTableAnnotationComposer,
      $$MovimientosTableCreateCompanionBuilder,
      $$MovimientosTableUpdateCompanionBuilder,
      (MovimientoFila, $$MovimientosTableReferences),
      MovimientoFila,
      PrefetchHooks Function({bool cuentaOrigenId, bool cuentaDestinoId})
    >;

class $BaseDatosManager {
  final _$BaseDatos _db;
  $BaseDatosManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$ReglasTableTableManager get reglas =>
      $$ReglasTableTableManager(_db, _db.reglas);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db, _db.cuentas);
  $$ComprasTableTableManager get compras =>
      $$ComprasTableTableManager(_db, _db.compras);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db, _db.presupuestos);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
}
