import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// O [TextFormField] padrão do aplicativo.
class AppTextFormField extends TextFormField {
  AppTextFormField({
    super.key,
    super.autofocus,
    super.focusNode,
    super.textAlign,
    TextInputType? keyboardType,
    super.textInputAction,
    String? labelText,
    String? hintText,
    super.initialValue,
    super.maxLength,
    super.maxLines = null,
    super.style,
    Widget? suffixIcon,
    super.validator,
    super.onSaved,
    super.onChanged,
    super.onFieldSubmitted,
  }) : super(
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: const InputDecoration()
              .applyDefaults(AppTheme.instance.light.inputDecorationTheme)
              .copyWith(
                labelText: labelText,
                hintText: hintText,
                suffixIcon: suffixIcon,
              ),
        );
}
