import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../core/format/formato.dart';
import '../../../../core/theme/paleta.dart';
import '../../../../core/ui/barra_progreso.dart';
import '../../../../core/ui/tarjeta.dart';
import '../../domain/cuenta.dart';
import '../../domain/estado_cuenta.dart';
import '../estilo_cuenta.dart';

final _diaMes = DateFormat("d 'de' MMM", 'es');

/// Una cuenta como tarjeta de Wallet, en su color pastel.
class TarjetaCuenta extends StatelessWidget {
  const TarjetaCuenta({super.key, required this.estado, this.onTap});

  final EstadoCuenta estado;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cuenta = estado.cuenta;
    final tono = tonoPastel(cuenta.color);
    Color resolver(CupertinoDynamicColor c) =>
        CupertinoDynamicColor.resolve(c, context);
    final tinta = resolver(tono.tinta);
    final secundario = tinta.withValues(alpha: 0.75);

    final contenido = Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: resolver(tono.relleno),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconoTipoCuenta(cuenta.tipo), size: 18, color: tinta),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cuenta.nombre,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: tinta,
                  ),
                ),
              ),
              Text(
                cuenta.tipo.etiqueta,
                style: TextStyle(fontSize: 13, color: secundario),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (cuenta.tipo == TipoCuenta.sinConfigurar)
            Text(
              'Toca para configurar el tipo y el saldo',
              style: TextStyle(fontSize: 15, color: tinta),
            )
          else
            ..._detalle(context, tinta, secundario, tono),
        ],
      ),
    );

    return onTap == null
        ? contenido
        : GestureDetector(onTap: onTap, child: contenido);
  }

  List<Widget> _detalle(
    BuildContext context,
    Color tinta,
    Color secundario,
    TonoPastel tono,
  ) {
    final (etiqueta, valor) = valorPrincipal(estado);
    final credito = estado.credito;
    final limite = estado.cuenta.limiteCentavos;
    final ahora = DateTime.now();
    final pie = TextStyle(fontSize: 13, color: secundario);

    return [
      Text(etiqueta, style: pie),
      Text(
        formatearMonto(valor),
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          fontFeatures: Estilos.numeros,
          color: tinta,
        ),
      ),
      if (estado.cuenta.esCredito && limite != null && limite > 0) ...[
        const SizedBox(height: 8),
        BarraProgreso(
          fraccion: valor / limite,
          color: CupertinoDynamicColor.resolve(tono.medio, context),
          alto: 5,
        ),
        const SizedBox(height: 6),
        Text(
          'Disponible ${formatearMonto(estado.disponibleCentavos!)} '
          'de ${formatearMonto(limite)}',
          style: pie,
        ),
      ],
      const SizedBox(height: 4),
      if (credito != null && pagoVencido(credito, ahora))
        Text(
          'Vencido: ${formatearMonto(credito.pendienteCentavos)} sin pagar '
          'desde el ${_diaMes.format(credito.fechaLimitePago)}',
          style: pie.copyWith(
            fontWeight: FontWeight.w600,
            color: CupertinoDynamicColor.resolve(
              tonoPastel('rojo').tinta,
              context,
            ),
          ),
        )
      else if (credito != null && credito.pendienteCentavos > 0)
        Text(
          'Pagar ${formatearMonto(credito.pendienteCentavos)} antes del '
          '${_diaMes.format(credito.fechaLimitePago)} '
          '(${enDias(credito.fechaLimitePago, ahora)})',
          style: pie.copyWith(fontWeight: FontWeight.w600, color: tinta),
        )
      else if (credito != null)
        Text(
          'Próximo corte: ${_diaMes.format(credito.proximoCorte)}',
          style: pie,
        )
      else
        Text(
          'Este mes: ${formatearMonto(estado.gastadoMesCentavos)} en compras',
          style: pie,
        ),
    ];
  }
}
