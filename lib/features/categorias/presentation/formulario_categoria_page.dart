import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../application/categorias_providers.dart';
import '../domain/categoria.dart';
import '../domain/regla_categoria.dart';
import 'estilo_categoria.dart';

/// Crear ([categoria] null) o editar una categoría: nombre, ícono y color.
class FormularioCategoriaPage extends ConsumerStatefulWidget {
  const FormularioCategoriaPage({super.key, this.categoria});

  final Categoria? categoria;

  @override
  ConsumerState<FormularioCategoriaPage> createState() =>
      _FormularioCategoriaPageState();
}

class _FormularioCategoriaPageState
    extends ConsumerState<FormularioCategoriaPage> {
  late final TextEditingController _nombre;
  late String _icono;
  late String _color;

  bool get _editando => widget.categoria != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.categoria?.nombre);
    _icono = widget.categoria?.icono ?? 'categoria';
    _color = widget.categoria?.color ?? 'azul';
  }

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  bool _nombreRepetido(List<Categoria> categorias) {
    final nombre = normalizar(_nombre.text);
    return categorias.any(
      (c) => c.id != widget.categoria?.id && normalizar(c.nombre) == nombre,
    );
  }

  Future<void> _guardar() async {
    await ref
        .read(categoriasRepositorioProvider)
        .guardarCategoria(
          id: widget.categoria?.id,
          nombre: _nombre.text.trim(),
          icono: _icono,
          color: _color,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _borrar() async {
    final confirmado = await confirmarBorrado(
      context,
      titulo: '¿Borrar "${widget.categoria!.nombre}"?',
      mensaje: 'Sus compras quedarán sin categoría y se borrarán sus reglas.',
    );
    if (!confirmado) return;
    await ref
        .read(categoriasRepositorioProvider)
        .borrarCategoria(widget.categoria!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final repetido = _nombreRepetido(
      ref.watch(categoriasProvider).value ?? const [],
    );
    final valido = normalizar(_nombre.text).isNotEmpty && !repetido;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_editando ? 'Editar categoría' : 'Nueva categoría'),
        leading: BotonBarra(
          texto: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        trailing: BotonBarra(
          texto: 'Guardar',
          principal: true,
          onPressed: valido ? _guardar : null,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Center(
              child: IconoCategoria(icono: _icono, color: _color, tamano: 72),
            ),
            CupertinoFormSection.insetGrouped(
              footer: repetido
                  ? const PieSeccion('Ya existe una categoría con ese nombre')
                  : null,
              children: [
                CupertinoTextFormFieldRow(
                  controller: _nombre,
                  placeholder: 'Nombre',
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: !_editando,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            _Cuadricula(
              children: [
                for (final MapEntry(key: clave, value: tono)
                    in tonosPastel.entries)
                  _Opcion(
                    seleccionada: clave == _color,
                    onTap: () => setState(() => _color = clave),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoDynamicColor.resolve(
                          tono.medio,
                          context,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            _Cuadricula(
              children: [
                for (final MapEntry(key: clave, value: icono)
                    in iconosCategoria.entries)
                  _Opcion(
                    seleccionada: clave == _icono,
                    onTap: () => setState(() => _icono = clave),
                    child: Icon(
                      icono,
                      size: 22,
                      color: CupertinoDynamicColor.resolve(
                        tonoPastel(_color).tinta,
                        context,
                      ),
                    ),
                  ),
              ],
            ),
            if (_editando)
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    title: Center(
                      child: Text(
                        'Borrar categoría',
                        style: TextStyle(
                          color: CupertinoColors.systemRed.resolveFrom(context),
                        ),
                      ),
                    ),
                    onTap: _borrar,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta blanca con opciones en cuadrícula (como el editor de listas de
/// Recordatorios).
class _Cuadricula extends StatelessWidget {
  const _Cuadricula({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(
          context,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: children,
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.seleccionada,
    required this.onTap,
    required this.child,
  });

  final bool seleccionada;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: seleccionada
                ? CupertinoColors.systemGrey3.resolveFrom(context)
                : const Color(0x00000000),
          ),
        ),
        child: child,
      ),
    );
  }
}
