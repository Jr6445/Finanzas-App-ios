import 'package:flutter/cupertino.dart';

import '../../../../core/format/formato.dart';
import '../../../../core/ui/tarjeta.dart';
import '../../../categorias/domain/categoria.dart';
import '../../../categorias/presentation/estilo_categoria.dart';
import '../../domain/compra.dart';

class CompraTile extends StatelessWidget {
  const CompraTile({
    super.key,
    required this.compra,
    required this.categoria,
    this.onTap,
  });

  final Compra compra;
  final Categoria? categoria;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leadingSize: 34,
      leadingToTitle: 12,
      leading: IconoCategoria.de(categoria),
      title: Text(compra.comercio, style: const TextStyle(fontSize: 16)),
      subtitle: Text(
        '${categoria?.nombre ?? nombreSinCategoria} · ${compra.tarjeta}',
        style: Estilos.secundario(context),
      ),
      additionalInfo: Text(
        formatearMonto(compra.montoCentavos),
        style: Estilos.monto(tamano: 16)
            .copyWith(color: CupertinoColors.label.resolveFrom(context)),
      ),
      onTap: onTap,
    );
  }
}
