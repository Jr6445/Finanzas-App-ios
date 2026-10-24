import 'package:flutter/cupertino.dart';

/// Alerta de iOS para confirmar una acción destructiva. Devuelve true si el
/// usuario confirmó.
Future<bool> confirmarBorrado(
  BuildContext context, {
  required String titulo,
  String? mensaje,
}) async {
  final confirmado = await showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(titulo),
      content: mensaje == null ? null : Text(mensaje),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Borrar'),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}

/// Envuelve una fila para poder borrarla deslizándola hacia la izquierda,
/// pidiendo confirmación antes.
class DeslizarParaBorrar extends StatelessWidget {
  const DeslizarParaBorrar({
    super.key,
    required this.id,
    required this.titulo,
    this.mensaje,
    required this.alBorrar,
    required this.child,
  });

  final Object id;
  final String titulo;
  final String? mensaje;
  final Future<void> Function() alBorrar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: CupertinoColors.systemRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
      ),
      // Se borra aquí y no en onDismissed: la lista se actualiza cuando la
      // base avisa del cambio, y eso debe ocurrir mientras la fila se encoge.
      // Si la fila siguiera en la lista al terminar, Flutter lanza un error.
      confirmDismiss: (_) async {
        final confirmado = await confirmarBorrado(
          context,
          titulo: titulo,
          mensaje: mensaje,
        );
        if (confirmado) await alBorrar();
        return confirmado;
      },
      child: child,
    );
  }
}

/// Botón de texto para la barra de navegación ("Cancelar", "Guardar").
class BotonBarra extends StatelessWidget {
  const BotonBarra({
    super.key,
    required this.texto,
    required this.onPressed,
    this.principal = false,
  });

  final String texto;
  final VoidCallback? onPressed;
  final bool principal;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        texto,
        style: principal ? const TextStyle(fontWeight: FontWeight.w600) : null,
      ),
    );
  }
}

/// Abre una pantalla como hoja modal de iOS (sube desde abajo). Usa el
/// navegador raíz para que la hoja tape también la barra de pestañas; cada
/// pestaña tiene su propio navegador y, con ese, quedaría debajo.
Future<T?> abrirModal<T>(BuildContext context, Widget pantalla) {
  return Navigator.of(context, rootNavigator: true).push<T>(
    CupertinoPageRoute(fullscreenDialog: true, builder: (_) => pantalla),
  );
}

/// Abre una pantalla con la transición normal de iOS (desde la derecha).
Future<T?> abrirPantalla<T>(BuildContext context, Widget pantalla) {
  return Navigator.of(context)
      .push<T>(CupertinoPageRoute(builder: (_) => pantalla));
}
