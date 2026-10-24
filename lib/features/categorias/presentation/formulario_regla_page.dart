import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/dialogos.dart';
import '../../../core/ui/tarjeta.dart';
import '../../compras/application/compras_providers.dart';
import '../application/categorias_providers.dart';
import '../domain/regla_categoria.dart';
import 'estilo_categoria.dart';
import 'selector_categoria_page.dart';

/// Crear ([regla] null) o editar una regla. Muestra en vivo qué comercios de
/// tus compras coinciden, para probar el patrón antes de guardarlo.
class FormularioReglaPage extends ConsumerStatefulWidget {
  const FormularioReglaPage({super.key, this.regla});

  final ReglaCategoria? regla;

  @override
  ConsumerState<FormularioReglaPage> createState() =>
      _FormularioReglaPageState();
}

class _FormularioReglaPageState extends ConsumerState<FormularioReglaPage> {
  late final TextEditingController _patron;
  int? _categoriaId;

  bool get _editando => widget.regla != null;

  bool get _valido =>
      normalizar(_patron.text).isNotEmpty && _categoriaId != null;

  @override
  void initState() {
    super.initState();
    _patron = TextEditingController(text: widget.regla?.patron);
    _categoriaId = widget.regla?.categoriaId;
  }

  @override
  void dispose() {
    _patron.dispose();
    super.dispose();
  }

  Future<void> _elegirCategoria() async {
    final elegida = await abrirPantalla<CategoriaElegida>(
      context,
      SelectorCategoriaPage(seleccionada: _categoriaId),
    );
    if (elegida != null) setState(() => _categoriaId = elegida.id);
  }

  Future<void> _guardar() async {
    final categorias = ref.read(categoriasRepositorioProvider);
    await categorias.guardarRegla(
      id: widget.regla?.id,
      patron: _patron.text.trim(),
      categoriaId: _categoriaId!,
    );
    // La regla nueva también sirve para las compras que ya estaban sin
    // categoría.
    await ref
        .read(comprasRepositorioProvider)
        .categorizarSinCategoria(await categorias.obtenerReglas());
    if (mounted) Navigator.pop(context);
  }

  Future<void> _borrar() async {
    final confirmado = await confirmarBorrado(
      context,
      titulo: '¿Borrar la regla "${widget.regla!.patron}"?',
    );
    if (!confirmado) return;
    await ref.read(categoriasRepositorioProvider).borrarRegla(widget.regla!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoria = ref.watch(categoriasPorIdProvider)[_categoriaId];
    final compras = ref.watch(comprasProvider).value ?? const [];
    final coincidencias = {
      for (final c in compras)
        if (coincide(c.comercio, _patron.text)) c.comercio,
    }.toList()..sort();

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_editando ? 'Editar regla' : 'Nueva regla'),
        leading: BotonBarra(
          texto: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        trailing: BotonBarra(
          texto: 'Guardar',
          principal: true,
          onPressed: _valido ? _guardar : null,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoFormSection.insetGrouped(
              header: const EncabezadoSeccion('Si el comercio contiene'),
              children: [
                CupertinoTextFormFieldRow(
                  controller: _patron,
                  placeholder: 'Ej. selectos',
                  autofocus: !_editando,
                  autocorrect: false,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const EncabezadoSeccion('Asignar a'),
              children: [
                CupertinoListTile(
                  leading: IconoCategoria.de(categoria),
                  title: Text(categoria?.nombre ?? 'Elegir categoría'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _elegirCategoria,
                ),
              ],
            ),
            if (normalizar(_patron.text).isNotEmpty)
              CupertinoListSection.insetGrouped(
                header: EncabezadoSeccion(
                  'Coincide con ${coincidencias.length} '
                  '${coincidencias.length == 1 ? 'comercio' : 'comercios'}',
                ),
                children: [
                  if (coincidencias.isEmpty)
                    const CupertinoListTile(
                      title: Text('Ningún comercio de tus compras'),
                    ),
                  for (final comercio in coincidencias.take(20))
                    CupertinoListTile(title: Text(comercio)),
                ],
              ),
            if (_editando)
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    title: Center(
                      child: Text(
                        'Borrar regla',
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
