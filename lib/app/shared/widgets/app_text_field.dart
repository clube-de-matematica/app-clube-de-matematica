import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

/// O [TextField] padrão do aplicativo.
class AppTextField extends TextField {
  AppTextField({
    super.key,
    super.controller,
    super.autofocus,
    super.focusNode,
    super.textAlign,
    TextInputType? keyboardType,
    super.textInputAction,
    String? labelText,
    String? hintText,
    super.maxLength,
    super.maxLines = null,
    super.style,
    Widget? suffixIcon,
    super.onChanged,
    super.onSubmitted,
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
