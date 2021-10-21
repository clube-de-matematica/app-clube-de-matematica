import 'package:flutter/material.dart';

import '../../../../shared/theme/appTheme.dart';

/// O [TextFormField] padrão do aplicativo.
class _AppTextFormField extends TextFormField {
  _AppTextFormField({
    Key? key,
    TextAlign textAlign = TextAlign.start,
    String? labelText,
    String? hintText,
    String? initialValue,
    int? maxLength,
    int? maxLines,
    TextStyle? style,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) : super(
          key: key,
          autofocus: true,
          textAlign: textAlign,
          keyboardType: TextInputType.text,
          maxLength: maxLength,
          maxLines: maxLines,
          style: style,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 16 * AppTheme.escala),
            border: const OutlineInputBorder(),
            hintText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //prefixIcon: Icon(Icons.person),
          ),
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
        );
}

/// Um [TextFormField] para inserir o nome do clube.
class NomeClubeTextFormField extends _AppTextFormField {
  NomeClubeTextFormField({
    Key? key,
    String? initialValue,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          maxLength: 50,
          labelText: 'Nome',
          hintText: 'Digite o nome do clube',
          onSaved: onSaved,
          validator: validator,
        );
}

/// Um [TextFormField] para inserir a descrição do clube.
class DescricaoClubeTextFormField extends _AppTextFormField {
  DescricaoClubeTextFormField({
    Key? key,
    String? initialValue,
    void Function(String?)? onSaved,
  }) : super(
          key: key,
          initialValue: initialValue,
          maxLength: 200,
          maxLines: 5,
          labelText: 'Descrição',
          hintText: 'Digite uma rápida descrição do clube',
          onSaved: onSaved,
        );
}
