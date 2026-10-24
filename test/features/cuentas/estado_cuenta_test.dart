import 'package:finanzas/features/compras/domain/compra.dart';
import 'package:finanzas/features/cuentas/domain/cuenta.dart';
import 'package:finanzas/features/cuentas/domain/estado_cuenta.dart';
import 'package:finanzas/features/cuentas/domain/movimiento.dart';
import 'package:finanzas/features/cuentas/domain/recordatorios.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const _debito = 1;
const _credito = 2;
const _efectivo = 3;

Compra _compra(String id, int cuentaId, int centavos, DateTime fecha) => Compra(
  id: id,
  comercio: 'X',
  montoCentavos: centavos,
  tarjeta: 'X',
  cuentaId: cuentaId,
  categoriaId: null,
  fecha: fecha,
  origen: OrigenCompra.manual,
);

Movimiento _mov(
  String id,
  TipoMovimiento tipo,
  int centavos,
  DateTime fecha, {
  int? origen,
  int? destino,
}) => Movimiento(
  id: id,
  tipo: tipo,
  cuentaOrigenId: origen,
  cuentaDestinoId: destino,
  montoCentavos: centavos,
  fecha: fecha,
);

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  final debito = Cuenta(
    id: _debito,
    nombre: 'Visa Agrícola',
    tipo: TipoCuenta.debito,
    color: 'verde',
    saldoInicialCentavos: 10000, // $100
    fechaSaldoInicial: DateTime(2026, 9, 1),
  );
  final credito = Cuenta(
    id: _credito,
    nombre: 'Mastercard',
    tipo: TipoCuenta.credito,
    color: 'azul',
    saldoInicialCentavos: 0,
    fechaSaldoInicial: DateTime(2026, 9, 1),
    limiteCentavos: 100000, // $1,000
    diaCorte: 15,
    diaPago: 5,
  );

  group('débito', () {
    test('el ejemplo: 100 − 50 (mes pasado) − 10 (este mes) = 40', () {
      final e = calcularEstado(
        cuenta: debito,
        compras: [
          _compra('a', _debito, 5000, DateTime(2026, 9, 20)),
          _compra('b', _debito, 1000, DateTime(2026, 10, 3)),
          _compra('otra', _credito, 9999, DateTime(2026, 10, 3)),
        ],
        movimientos: const [],
        ahora: DateTime(2026, 10, 24),
      );
      expect(e.valorCentavos, 4000);
      expect(e.gastadoMesCentavos, 1000);
      expect(e.entradas.map((x) => x.id), ['b', 'a']);
    });

    test('lo anterior al saldo inicial no se resta otra vez', () {
      final e = calcularEstado(
        cuenta: debito,
        compras: [_compra('vieja', _debito, 3000, DateTime(2026, 8, 30))],
        movimientos: const [],
        ahora: DateTime(2026, 10, 24),
      );
      expect(e.valorCentavos, 10000);
      // Pero sí aparece en el historial.
      expect(e.entradas, hasLength(1));
    });

    test('depósitos, retiro a efectivo y ajuste', () {
      final movimientos = [
        _mov(
          'sal',
          TipoMovimiento.deposito,
          80000,
          DateTime(2026, 10, 1),
          destino: _debito,
        ),
        _mov(
          'ret',
          TipoMovimiento.transferencia,
          10000,
          DateTime(2026, 10, 2),
          origen: _debito,
          destino: _efectivo,
        ),
        _mov(
          'aj',
          TipoMovimiento.ajuste,
          -500,
          DateTime(2026, 10, 3),
          destino: _debito,
        ),
      ];
      final e = calcularEstado(
        cuenta: debito,
        compras: const [],
        movimientos: movimientos,
        ahora: DateTime(2026, 10, 24),
      );
      // 100 + 800 − 100 − 5
      expect(e.valorCentavos, 79500);

      final efectivo = calcularEstado(
        cuenta: Cuenta(
          id: _efectivo,
          nombre: 'Efectivo',
          tipo: TipoCuenta.efectivo,
          color: 'gris',
          fechaSaldoInicial: DateTime(2026, 9, 1),
        ),
        compras: [_compra('pupusas', _efectivo, 450, DateTime(2026, 10, 5))],
        movimientos: movimientos,
        ahora: DateTime(2026, 10, 24),
      );
      expect(efectivo.valorCentavos, 10000 - 450);
    });
  });

  group('crédito', () {
    // Corte el 15, pago el 5 del mes siguiente.
    final compras = [
      _compra('sep', _credito, 20000, DateTime(2026, 9, 10)),
      _compra('corte', _credito, 5000, DateTime(2026, 10, 15, 23)),
      _compra('nueva', _credito, 3000, DateTime(2026, 10, 20)),
    ];

    test('deuda, disponible y ciclo', () {
      final e = calcularEstado(
        cuenta: credito,
        compras: compras,
        movimientos: const [],
        ahora: DateTime(2026, 10, 24),
      );
      expect(e.valorCentavos, 28000);
      expect(e.disponibleCentavos, 72000);

      final c = e.credito!;
      expect(c.ultimoCorte, DateTime(2026, 10, 15));
      expect(c.proximoCorte, DateTime(2026, 11, 15));
      expect(c.fechaLimitePago, DateTime(2026, 11, 5));
      // Lo del día del corte entra en ese corte.
      expect(c.saldoAlCorteCentavos, 25000);
      expect(c.cicloActualCentavos, 3000);
      expect(c.pendienteCentavos, 25000);
    });

    test('pago desde la débito: baja la deuda y el saldo de la débito', () {
      final pago = _mov(
        'pago',
        TipoMovimiento.transferencia,
        15000,
        DateTime(2026, 10, 25),
        origen: _debito,
        destino: _credito,
      );
      final e = calcularEstado(
        cuenta: credito,
        compras: compras,
        movimientos: [pago],
        ahora: DateTime(2026, 10, 26),
      );
      expect(e.valorCentavos, 13000);
      expect(e.credito!.abonadoDesdeCorteCentavos, 15000);
      expect(e.credito!.pendienteCentavos, 10000);

      final d = calcularEstado(
        cuenta: debito,
        compras: const [],
        movimientos: [pago],
        ahora: DateTime(2026, 10, 26),
      );
      expect(d.valorCentavos, 10000 - 15000);
    });

    test('pagar de más no deja pendiente negativo', () {
      final e = calcularEstado(
        cuenta: credito,
        compras: compras,
        movimientos: [
          _mov(
            'pago',
            TipoMovimiento.deposito,
            99999,
            DateTime(2026, 10, 25),
            destino: _credito,
          ),
        ],
        ahora: DateTime(2026, 10, 26),
      );
      expect(e.credito!.pendienteCentavos, 0);
    });

    test('sin día de corte o de pago no hay información de ciclo', () {
      final e = calcularEstado(
        cuenta: credito.copyWith(diaCorte: () => null),
        compras: compras,
        movimientos: const [],
        ahora: DateTime(2026, 10, 24),
      );
      expect(e.credito, isNull);
      expect(e.valorCentavos, 28000);
    });
  });

  group('fechas de corte', () {
    test('antes del día de corte, el último corte fue el mes pasado', () {
      expect(ultimoCorte(DateTime(2026, 10, 14), 15), DateTime(2026, 9, 15));
      expect(
        ultimoCorte(DateTime(2026, 10, 15, 8), 15),
        DateTime(2026, 10, 15),
      );
    });

    test('día 31 en meses cortos y cambio de año', () {
      expect(ultimoCorte(DateTime(2026, 12, 1), 31), DateTime(2026, 11, 30));
      expect(fechaConDia(2026, 13, 31), DateTime(2027, 1, 31));
      expect(fechaConDia(2027, 2, 30), DateTime(2027, 2, 28));
    });

    test('fecha límite de pago', () {
      expect(fechaLimitePago(DateTime(2026, 12, 15), 5), DateTime(2027, 1, 5));
      expect(
        fechaLimitePago(DateTime(2026, 10, 5), 25),
        DateTime(2026, 10, 25),
      );
    });
  });

  group('recordatorios', () {
    EstadoCuenta estado({int dias = 3}) => calcularEstado(
      cuenta: credito.copyWith(diasRecordatorio: dias),
      compras: [_compra('a', _credito, 25000, DateTime(2026, 10, 10))],
      movimientos: const [],
      ahora: DateTime(2026, 10, 24),
    );

    test('avisa N días antes de la fecha límite a las 9:00', () {
      final r = calcularRecordatorios([estado()], DateTime(2026, 10, 24));
      expect(r.single.id, _credito);
      expect(r.single.fecha, DateTime(2026, 11, 2, 9));
      expect(r.single.titulo, 'Pagar Mastercard');
      expect(r.single.cuerpo, contains(r'$250.00'));
      expect(r.single.cuerpo, contains('5 de noviembre'));
    });

    test('sin aviso si está apagado, si ya pasó la hora o si no debe nada', () {
      expect(
        calcularRecordatorios([estado(dias: 0)], DateTime(2026, 10, 24)),
        isEmpty,
      );
      expect(calcularRecordatorios([estado()], DateTime(2026, 11, 3)), isEmpty);
      final sinDeuda = calcularEstado(
        cuenta: credito,
        compras: const [],
        movimientos: const [],
        ahora: DateTime(2026, 10, 24),
      );
      expect(
        calcularRecordatorios([sinDeuda], DateTime(2026, 10, 24)),
        isEmpty,
      );
    });
  });

  test('reconoce el nombre de Apple Pay sin importar mayúsculas ni tildes', () {
    final c = debito.copyWith(alias: ['Visa ••4821']);
    expect(c.reconoce('VISA AGRICOLA'), isTrue);
    expect(c.reconoce('visa ••4821'), isTrue);
    expect(c.reconoce('Mastercard'), isFalse);
  });
}
