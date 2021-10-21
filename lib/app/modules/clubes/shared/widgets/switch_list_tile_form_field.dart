import 'package:flutter/material.dart';

/// Um [SwitchListTile] que extende [FormField].
/// Usado para definir o nível de privacidade do clube.
class SwitchListTileFormField extends FormField<bool> {
  SwitchListTileFormField({
    Key? key,
    bool valorInicial = true,
    void Function(bool?)? onSaved,
  }) : super(
          key: key,
          initialValue: valorInicial,
          builder: (field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: const Text('Grupo aberto'),
                subtitle: const Text(
                    'Qualquer pessoa com o código de acesso pode participar?'),
                value: field.value ?? valorInicial,
                onChanged: (value) => field.didChange(value),
              ),
            );
          },
          onSaved: onSaved,
        );
}
