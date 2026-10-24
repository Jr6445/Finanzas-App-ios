import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/format/formato.dart';
import '../../../core/ui/dialogos.dart';
import '../../../core/ui/espacio_final.dart';
import '../../../core/ui/tarjeta.dart';
import '../../../core/ui/tocable.dart';
import '../../categorias/application/categorias_providers.dart';
import '../../compras/application/compras_providers.dart';
import '../../compras/presentation/formulario_compra_page.dart';
import '../../compras/presentation/widgets/compra_tile.dart';
import '../application/cuentas_providers.dart';
import '../domain/cuenta.dart';
import '../domain/estado_cuenta.dart';
import '../domain/movimiento.dart';
import 'estilo_cuenta.dart';
import 'formulario_cuenta_page.dart';
import 'formulario_movimiento_page.dart';
import 'widgets/movimiento_tile.dart';
import 'widgets/tarjeta_cuenta.dart';

final _diaMes = DateFormat("d 'de' MMMM", 'es');

/// Una cuenta: su tarjeta, el estado del corte (si es de crédito), acciones
/// y todo su historial por día.
class DetalleCuentaPage extends ConsumerWidget {
  const DetalleCuentaPage({super.key, required this.cuentaId});

  final int cuentaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref
        .watch(estadosCuentasProvider)
        .where((e) => e.cuenta.id == cuentaId)
        .firstOrNull;
    if (estado == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }
    final cuenta = estado.cuenta;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(cuenta.nombre),
            previousPageTitle: 'Cuentas',
            border: null,
            backgroundColor: CupertinoColors.systemGroupedBackground,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _editar(context, cuenta),
              child: const Text('Editar'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: TarjetaCuenta(
                estado: estado,
                onTap: cuenta.tipo == TipoCuenta.sinConfigurar
                    ? () => _editar(context, cuenta)
                    : null,
              ),
            ),
          ),
          if (cuenta.tipo != TipoCuenta.sinConfigurar)
            SliverToBoxAdapter(child: _Acciones(estado: estado)),
          if (estado.credito case final credito?)
            SliverToBoxAdapter(child: _TarjetaCorte(credito: credito))
          else if (cuenta.esCredito)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: PieSeccion(
                  'Agrega el día de corte y el día límite de pago (Editar) '
                  'para ver cuánto pagar de cada corte.',
                ),
              ),
            ),
          if (estado.entradas.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Sin movimientos todavía',
                  textAlign: TextAlign.center,
                  style: Estilos.secundario(context, tamano: 15),
                ),
              ),
            )
          else
            _SliverHistorial(estado: estado),
          const SliverEspacioFinal(),
        ],
      ),
    );
  }

  Future<void> _editar(BuildContext context, Cuenta cuenta) async {
    final borrada = await abrirModal<bool>(
      context,
      FormularioCuentaPage(cuenta: cuenta),
    );
    if (borrada == true && context.mounted) Navigator.pop(context);
  }
}

/// Botones redondos de acción, como los de la app Wallet.
class _Acciones extends ConsumerWidget {
  const _Acciones({required this.estado});

  final EstadoCuenta estado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuenta = estado.cuenta;
    final botones = <Widget>[
      if (cuenta.esCredito)
        _BotonAccion(
          icono: CupertinoIcons.checkmark_seal,
          texto: 'Pagar',
          onTap: () => abrirModal(
            context,
            FormularioMovimientoPage(
              tipo: TipoMovimiento.transferencia,
              destinoId: cuenta.id,
            ),
          ),
        )
      else ...[
        _BotonAccion(
          icono: CupertinoIcons.arrow_down,
          texto: 'Depósito',
          onTap: () => abrirModal(
            context,
            FormularioMovimientoPage(destinoId: cuenta.id),
          ),
        ),
        _BotonAccion(
          icono: CupertinoIcons.arrow_right_arrow_left,
          texto: 'Transferir',
          onTap: () => abrirModal(
            context,
            FormularioMovimientoPage(
              tipo: TipoMovimiento.transferencia,
              origenId: cuenta.id,
            ),
          ),
        ),
      ],
      _BotonAccion(
        icono: CupertinoIcons.slider_horizontal_3,
        texto: cuenta.esCredito ? 'Ajustar deuda' : 'Ajustar saldo',
        onTap: () => _ajustar(context, ref),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: botones,
      ),
    );
  }

  /// Pide el saldo real (el que dice el banco) y guarda la diferencia como
  /// ajuste.
  Future<void> _ajustar(BuildContext context, WidgetRef ref) async {
    final real = await showCupertinoDialog<int>(
      context: context,
      builder: (_) => _DialogoAjuste(
        titulo: estado.cuenta.esCredito ? 'Deuda real' : 'Saldo real',
        actual: estado.valorCentavos,
      ),
    );
    if (real == null || real == estado.valorCentavos) return;
    await ref
        .read(cuentasRepositorioProvider)
        .guardarMovimiento(
          Movimiento(
            id: const Uuid().v4(),
            tipo: TipoMovimiento.ajuste,
            cuentaDestinoId: estado.cuenta.id,
            montoCentavos: real - estado.valorCentavos,
            fecha: DateTime.now(),
          ),
        );
  }
}

class _BotonAccion extends StatelessWidget {
  const _BotonAccion({
    required this.icono,
    required this.texto,
    required this.onTap,
  });

  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tocable(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: CupertinoColors.secondarySystemGroupedBackground
                  .resolveFrom(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icono,
              size: 22,
              color: CupertinoColors.systemBlue.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(texto, style: Estilos.secundario(context, tamano: 12)),
        ],
      ),
    );
  }
}

class _DialogoAjuste extends StatefulWidget {
  const _DialogoAjuste({required this.titulo, required this.actual});

  final String titulo;
  final int actual;

  @override
  State<_DialogoAjuste> createState() => _DialogoAjusteState();
}

class _DialogoAjusteState extends State<_DialogoAjuste> {
  late final TextEditingController _monto = TextEditingController(
    text: montoParaEditar(widget.actual),
  );

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monto = parsearMonto(_monto.text);
    return CupertinoAlertDialog(
      title: Text(widget.titulo),
      content: Column(
        children: [
          const SizedBox(height: 4),
          const Text(
            'Escribe lo que dice tu banco; la diferencia se '
            'guarda como ajuste.',
          ),
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _monto,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: monto == null ? null : () => Navigator.pop(context, monto),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

/// Saldo del último corte, lo abonado, lo pendiente y el ciclo en curso.
class _TarjetaCorte extends StatelessWidget {
  const _TarjetaCorte({required this.credito});

  final EstadoCredito credito;

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    Widget fila(
      String etiqueta,
      String valor, {
      String? detalle,
      bool fuerte = false,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(etiqueta, style: const TextStyle(fontSize: 15)),
                  if (detalle != null)
                    Text(
                      detalle,
                      style: Estilos.terciario(context, tamano: 12),
                    ),
                ],
              ),
            ),
            Text(
              valor,
              style: Estilos.monto(
                peso: fuerte ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Tarjeta(
      titulo: 'Corte',
      child: Column(
        children: [
          fila(
            'Saldo al corte',
            formatearMonto(credito.saldoAlCorteCentavos),
            detalle: _diaMes.format(credito.ultimoCorte),
          ),
          fila('Abonado', formatearMonto(credito.abonadoDesdeCorteCentavos)),
          fila(
            'Pendiente de pagar',
            formatearMonto(credito.pendienteCentavos),
            detalle: credito.pendienteCentavos == 0
                ? 'Pagado'
                : '${pagoVencido(credito, ahora) ? 'Venció' : 'Vence'} el '
                      '${_diaMes.format(credito.fechaLimitePago)} '
                      '(${enDias(credito.fechaLimitePago, ahora)})',
            fuerte: true,
          ),
          fila(
            'Compras del ciclo actual',
            formatearMonto(credito.cicloActualCentavos),
            detalle: 'Próximo corte: ${_diaMes.format(credito.proximoCorte)}',
          ),
        ],
      ),
    );
  }
}

/// Historial de la cuenta agrupado por día: compras y movimientos juntos.
class _SliverHistorial extends ConsumerWidget {
  const _SliverHistorial({required this.estado});

  final EstadoCuenta estado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoriasPorIdProvider);
    final cuentas = ref.watch(cuentasPorIdProvider);

    final dias = <DateTime, List<EntradaCuenta>>{};
    for (final e in estado.entradas) {
      dias.putIfAbsent(soloFecha(e.fecha), () => []).add(e);
    }
    final grupos = dias.entries.toList();

    return SliverList.builder(
      itemCount: grupos.length,
      itemBuilder: (context, i) {
        final MapEntry(key: dia, value: entradas) = grupos[i];
        return CupertinoListSection.insetGrouped(
          header: Text(
            etiquetaDia(dia),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          children: [
            for (final e in entradas)
              if (e.compra case final compra?)
                DeslizarParaBorrar(
                  id: compra.id,
                  titulo: '¿Borrar compra?',
                  mensaje: compra.comercio,
                  alBorrar: () =>
                      ref.read(comprasRepositorioProvider).borrar(compra.id),
                  child: CompraTile(
                    compra: compra,
                    categoria: categorias[compra.categoriaId],
                    onTap: () => abrirModal(
                      context,
                      FormularioCompraPage(compra: compra),
                    ),
                  ),
                )
              else
                DeslizarParaBorrar(
                  id: e.movimiento!.id,
                  titulo: '¿Borrar este movimiento?',
                  alBorrar: () => ref
                      .read(cuentasRepositorioProvider)
                      .borrarMovimiento(e.movimiento!.id),
                  child: MovimientoTile(
                    movimiento: e.movimiento!,
                    cuenta: estado.cuenta,
                    cuentas: cuentas,
                    // Los ajustes no se editan: se borran y se vuelve a
                    // ajustar.
                    onTap: e.movimiento!.tipo == TipoMovimiento.ajuste
                        ? null
                        : () => abrirModal(
                            context,
                            FormularioMovimientoPage(movimiento: e.movimiento),
                          ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
