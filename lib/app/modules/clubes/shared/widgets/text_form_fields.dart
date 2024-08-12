import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_text_form_field.dart';

/// Um [TextFormField] para inserir o nome do clube.
class NomeClubeTextFormField extends AppTextFormField {
  NomeClubeTextFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
  }) : super(
          maxLength: 50,
          labelText: 'Nome',
          hintText: 'Digite o nome do clube',
        );
}

/// Um [TextFormField] para inserir a descrição do clube.
class DescricaoClubeTextFormField extends AppTextFormField {
  DescricaoClubeTextFormField({
    super.key,
    super.initialValue,
    super.onSaved,
  }) : super(
          maxLength: 200,
          maxLines: 5,
          labelText: 'Descrição',
          hintText: 'Digite uma rápida descrição do clube',
        );
}
