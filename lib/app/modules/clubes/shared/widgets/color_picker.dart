import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../utils/random_colors.dart';

/// Um [ListTile] que exibe um diálogo para a seleção de cor.
class ColorPickerListTile extends StatefulWidget {
  const ColorPickerListTile({
    Key? key,
    this.colorChange,
    this.initialColor,
  }) : super(key: key);

  /// Função chamada sempre que uma nova cor é confimada. O parâmetro da função é o valor
  /// da nova cor.
  final void Function(Color color)? colorChange;

  /// Cor inicial.
  final Color? initialColor;

  @override
  _ColorPickerListTileState createState() => _ColorPickerListTileState();
}

class _ColorPickerListTileState extends State<ColorPickerListTile> {
  late final seletor = ColorPicker(widget.initialColor);
  late Color? cor = widget.initialColor ?? seletor.shadeColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      title: const Text('Tema'),
      subtitle: const Text('Cor da capa e do avatar do clube'),
      trailing: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(backgroundColor: cor),
      ),
      onTap: () async {
        await seletor.openColorPicker(context);
        final novaCor = seletor.shadeColor;
        if (novaCor != cor) {
          setState(() => cor = novaCor);
          if (novaCor != null) widget.colorChange?.call(novaCor);
        }
      },
    );
  }
}

/// Possui métodos para abrir um diálogo de seleção de cor.
/// * [mainColor] é a [ColorSwatch] selecionada.
/// * [shadeColor] é a [Color] selecionada em [mainColor].
class ColorPicker {
  ColorPicker([Color? shadeColor]) : _shadeColor = shadeColor ?? RandomColor();
  String title = 'Selecione uma cor';
  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor;
  ColorSwatch? get mainColor => _mainColor;
  Color? _shadeColor;
  Color? get shadeColor => _shadeColor;

  Future<void> _openDialog(BuildContext context, Widget content) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: const Text('APLICAR'),
              onPressed: () {
                Navigator.of(context).pop();
                _mainColor = _tempMainColor;
                _shadeColor = _tempShadeColor;
              },
            ),
          ],
        );
      },
    );
  }

  /// Abre o diálogo para a seleção de cor em duas etapas.
  /// Na primeira etapa seleciona-se a [ColorSwatch] e na segunda, a tonalidade.
  Future<void> openColorPicker(BuildContext context) async {
    return _openDialog(
      context,
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => _tempShadeColor = color,
        onMainColorChange: (color) => _tempMainColor = color,
      ),
    );
  }

  /// Abre o diálogo para a seleção de cor em uma etapa.
  /// Apenas a etapa para a seleção da [ColorSwatch] é exibida.
  Future<void> openMainColorPicker(BuildContext context) async {
    return _openDialog(
      context,
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => _tempMainColor = color,
      ),
    );
  }

  Future<void> openAccentColorPicker(BuildContext context) async {
    return _openDialog(
      context,
      MaterialColorPicker(
        colors: accentColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => _tempMainColor = color,
        circleSize: 40.0,
        spacing: 10,
      ),
    );
  }

  Future<void> openFullMaterialColorPicker(BuildContext context) async {
    return _openDialog(
      context,
      MaterialColorPicker(
        colors: fullMaterialColors,
        selectedColor: _mainColor,
        onMainColorChange: (color) => _tempMainColor = color,
      ),
    );
  }
}
