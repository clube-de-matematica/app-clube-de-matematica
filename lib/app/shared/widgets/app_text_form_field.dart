import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

/// O [TextFormField] padrão do aplicativo.
class AppTextFormField extends TextFormField {
  AppTextFormField({
    Key? key,
    bool autofocus = false,
    FocusNode? focusNode,
    TextAlign textAlign = TextAlign.start,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? labelText,
    String? hintText,
    String? initialValue,
    int? maxLength,
    int? maxLines,
    TextStyle? style,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
  }) : super(
          key: key,
          autofocus: autofocus,
          focusNode: focusNode,
          textAlign: textAlign,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction,
          maxLength: maxLength,
          maxLines: maxLines,
          style: style,
          decoration: InputDecoration()
              .applyDefaults(AppTheme.instance.temaClaro.inputDecorationTheme)
              .copyWith(
                labelText: labelText,
                hintText: hintText,
                suffixIcon: suffixIcon,
              ),
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        );
}
