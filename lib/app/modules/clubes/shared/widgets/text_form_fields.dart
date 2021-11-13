import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_text_form_field.dart';

/// Um [TextFormField] para inserir o nome do clube.
class NomeClubeTextFormField extends AppTextFormField {
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
class DescricaoClubeTextFormField extends AppTextFormField {
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
