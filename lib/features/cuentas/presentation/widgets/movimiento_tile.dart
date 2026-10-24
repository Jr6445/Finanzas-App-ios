import 'package:flutter/cupertino.dart';

import '../../../../core/format/formato.dart';
import '../../../../core/theme/paleta.dart';
import '../../../../core/ui/tarjeta.dart';
import '../../domain/cuenta.dart';
import '../../domain/movimiento.dart';

/// Un depósito, transferencia o ajuste en el historial de [cuenta].
class MovimientoTile extends StatelessWidget {
  const MovimientoTile({
    super.key,
    required this.movimiento,
    required this.cuenta,
    required this.cuentas,
    this.onTap,
  });

  final Movimiento movimiento;

  /// La cuenta cuyo historial se está viendo.
  final Cuenta cuenta;
  final Map<int, Cuenta> cuentas;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final m = movimiento;
    final entra = m.cuentaDestinoId == cuenta.id;
    String nombre(int? id) => cuentas[id]?.nombre ?? 'cuenta borrada';

    final (icono, tono, titulo) = switch (m.tipo) {
      TipoMovimiento.deposito => (
        CupertinoIcons.arrow_down,
        'verde',
        'Depósito',
      ),
      TipoMovimiento.transferencia when entra && cuenta.esCredito => (
        CupertinoIcons.checkmark,
        'verde',
        'Pago desde ${nombre(m.cuentaOrigenId)}',
      ),
      TipoMovimiento.transferencia when entra => (
        CupertinoIcons.arrow_right_arrow_left,
        'azul',
        'Desde ${nombre(m.cuentaOrigenId)}',
      ),
      TipoMovimiento.transferencia => (
        CupertinoIcons.arrow_right_arrow_left,
        'azul',
        cuentas[m.cuentaDestinoId]?.esCredito ?? false
            ? 'Pago a ${nombre(m.cuentaDestinoId)}'
            : 'A ${nombre(m.cuentaDestinoId)}',
      ),
      TipoMovimiento.ajuste => (
        CupertinoIcons.slider_horizontal_3,
        'gris',
        'Ajuste',
      ),
    };

    // Signo desde el punto de vista del dinero de la cuenta: un pago a la
    // tarjeta de crédito es un "+", aunque baje la deuda.
    final positivo = switch (m.tipo) {
      TipoMovimiento.ajuste => m.montoCentavos >= 0,
      _ => entra,
    };
    final monto = formatearMonto(m.montoCentavos.abs());

    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leadingSize: 34,
      leadingToTitle: 12,
      leading: IconoTono(icono: icono, tono: tonoPastel(tono)),
      title: Text(titulo, style: const TextStyle(fontSize: 16)),
      subtitle: m.nota.isEmpty
          ? null
          : Text(m.nota, style: Estilos.secundario(context)),
      additionalInfo: Text(
        '${positivo ? '+' : '−'}$monto',
        style: Estilos.monto(tamano: 16).copyWith(
          color: positivo
              ? CupertinoDynamicColor.resolve(
                  tonoPastel('verde').tinta,
                  context,
                )
              : CupertinoColors.label.resolveFrom(context),
        ),
      ),
      onTap: onTap,
    );
  }
}
