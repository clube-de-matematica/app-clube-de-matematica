import 'package:flutter/material.dart';

import '../../../../shared/repositories/id_base62.dart';

/// Um [ListTile] que extende [FormField].
/// Usado para gerar um novo código de acesso para o clube.
class GerarCodigoListTileFormField extends FormField<String> {
  GerarCodigoListTileFormField({
    Key? key,
    required String codigo,
    void Function(String?)? onSaved,
  }) : super(
          key: key,
          initialValue: codigo,
          builder: (field) {
            final state = field as _GerarCodigoListTileFormFieldState;
            return UnmanagedRestorationScope(
              bucket: state.bucket,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: const Text('Código'),
                subtitle: state.subtitulo,
                trailing: state.trailing,
                onTap: () => state.didChange(IdBase62.getIdClube()),
              ),
            );
          },
          onSaved: onSaved,
        );

  @override
  FormFieldState<String> createState() => _GerarCodigoListTileFormFieldState();
}

class _GerarCodigoListTileFormFieldState extends FormFieldState<String> {
  /// Verdadeido se um novo código foi gerado.
  bool get salvo => value == widget.initialValue;

  Widget get subtitulo =>
      Text(salvo ? 'Toque para gerar um novo código' : value ?? '');

  Widget get trailing {
    return salvo
        ? SelectableText(
            widget.initialValue ?? '',
            style: TextStyle(fontSize: 20.0),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 36.0,
              ),
              onPressed: () => reset(),
            ),
          );
  }

  @override
  void save() {
    if (!salvo) super.save();
  }

  @override
  void didChange(String? value) {
    if (value != null && value != this.value) {
      super.didChange(value);
    }
  }

  @override
  GerarCodigoListTileFormField get widget =>
      super.widget as GerarCodigoListTileFormField;
}
