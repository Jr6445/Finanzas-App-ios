import 'package:flutter/cupertino.dart';

/// Hace tocable cualquier fila, atenuándola mientras está presionada (como
/// las filas de las apps de Apple). A diferencia de CupertinoButton, no
/// cambia el color del texto a azul.
class Tocable extends StatefulWidget {
  const Tocable({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<Tocable> createState() => _TocableState();
}

class _TocableState extends State<Tocable> {
  bool _presionado = false;

  void _presionar(bool valor) => setState(() => _presionado = valor);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // opaque: también responde al tocar los espacios vacíos de la fila.
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _presionar(true),
      onTapUp: (_) => _presionar(false),
      onTapCancel: () => _presionar(false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        opacity: _presionado ? 0.4 : 1,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
