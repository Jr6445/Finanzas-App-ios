import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../application/cuentas_providers.dart';
import '../domain/cuenta.dart';
import 'estilo_cuenta.dart';
import 'formulario_cuenta_page.dart';

/// Lista para elegir una cuenta. Devuelve la [Cuenta] elegida, o null si
/// el usuario regresa sin elegir.
class SelectorCuentaPage extends ConsumerWidget {
  const SelectorCuentaPage({
    super.key,
    required this.titulo,
    this.seleccionada,
    this.excluir,
  });

  final String titulo;
  final int? seleccionada;

  /// Cuenta que no se puede elegir (p. ej. el origen de una transferencia).
  final int? excluir;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuentas = [
      for (final c in ref.watch(cuentasProvider).value ?? const <Cuenta>[])
        if (c.id != excluir) c,
    ];

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(middle: Text(titulo)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                for (final c in cuentas)
                  CupertinoListTile(
                    leading: IconoCuenta(cuenta: c),
                    title: Text(c.nombre),
                    additionalInfo: Text(c.tipo.etiqueta),
                    trailing: c.id == seleccionada
                        ? const Icon(CupertinoIcons.check_mark, size: 20)
                        : null,
                    onTap: () => Navigator.pop(context, c),
                  ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.add_circled),
                  title: const Text('Nueva cuenta…'),
                  onTap: () =>
                      abrirModal(context, const FormularioCuentaPage()),
                ),
              ],
            ),
            if (cuentas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PieSeccion(
                  'Todavía no tienes cuentas. Crea una y luego elígela aquí.',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
