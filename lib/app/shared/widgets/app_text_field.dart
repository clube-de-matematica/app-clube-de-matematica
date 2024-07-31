import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

/// O [TextField] padrão do aplicativo.
class AppTextField extends TextField {
  AppTextField({
    Key? key,
    TextEditingController? controller,
    bool autofocus = false,
    FocusNode? focusNode,
    TextAlign textAlign = TextAlign.start,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? labelText,
    String? hintText,
    int? maxLength,
    int? maxLines,
    TextStyle? style,
    Widget? suffixIcon,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) : super(
          key: key,
          controller: controller,
          autofocus: autofocus,
          focusNode: focusNode,
          textAlign: textAlign,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction,
          maxLength: maxLength,
          maxLines: maxLines,
          style: style,
          decoration: InputDecoration()
              .applyDefaults(AppTheme.instance.light.inputDecorationTheme)
              .copyWith(
                labelText: labelText,
                hintText: hintText,
                suffixIcon: suffixIcon,
              ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        );
}
