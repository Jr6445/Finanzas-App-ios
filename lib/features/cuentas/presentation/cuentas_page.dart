import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/formato.dart';
import '../../../core/ui/dialogos.dart';
import '../../../core/ui/espacio_final.dart';
import '../../../core/ui/tarjeta.dart';
import '../application/cuentas_providers.dart';
import '../domain/cuenta.dart';
import 'detalle_cuenta_page.dart';
import 'formulario_cuenta_page.dart';
import 'widgets/tarjeta_cuenta.dart';

/// Pestaña "Cuentas": todas las cuentas como tarjetas de Wallet, con el
/// total disponible y la deuda total arriba.
class CuentasPage extends ConsumerWidget {
  const CuentasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estados = ref.watch(estadosCuentasProvider);
    final cargando = ref.watch(cuentasProvider).isLoading;

    var disponible = 0;
    var deuda = 0;
    for (final e in estados) {
      switch (e.cuenta.tipo) {
        case TipoCuenta.debito || TipoCuenta.efectivo:
          disponible += e.valorCentavos;
        case TipoCuenta.credito:
          deuda += e.valorCentavos;
        case TipoCuenta.sinConfigurar:
          break;
      }
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Cuentas'),
            border: null,
            backgroundColor: CupertinoColors.systemGroupedBackground,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () =>
                  abrirModal(context, const FormularioCuentaPage()),
              child: const Icon(CupertinoIcons.plus_circle_fill, size: 28),
            ),
          ),
          if (cargando)
            const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator()),
            )
          else if (estados.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Agrega tus tarjetas y cuentas con el botón +.\n'
                    'Las de Apple Pay también aparecen solas con tu primera '
                    'compra.',
                    textAlign: TextAlign.center,
                    style: Estilos.secundario(context, tamano: 15),
                  ),
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disponible',
                      style: Estilos.secundario(context, tamano: 15),
                    ),
                    Text(
                      formatearMonto(disponible),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        fontFeatures: Estilos.numeros,
                      ),
                    ),
                    if (deuda != 0)
                      Text(
                        'Deuda en tarjetas: ${formatearMonto(deuda)}',
                        style: Estilos.terciario(context),
                      ),
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: estados.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TarjetaCuenta(
                  estado: estados[i],
                  onTap: () => abrirPantalla(
                    context,
                    DetalleCuentaPage(cuentaId: estados[i].cuenta.id),
                  ),
                ),
              ),
            ),
            const SliverEspacioFinal(),
          ],
        ],
      ),
    );
  }
}
