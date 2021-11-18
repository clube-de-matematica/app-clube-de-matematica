import 'package:flutter/material.dart';

/// Um [PopupMenuItem] com um [Checkbox] à direita.
class CheckboxPopupMenuItem<T> extends PopupMenuItem<T> {
  const CheckboxPopupMenuItem({
    Key? key,
    T? value,
    this.checked = false,
    required this.onChanged,
    bool enabled = true,
    EdgeInsets? padding,
    double height = kMinInteractiveDimension,
    Widget? child,
  }) : super(
          key: key,
          value: value,
          enabled: enabled,
          padding: padding,
          height: height,
          child: child,
        );

  final bool checked;
  final void Function(bool?)? onChanged;

  @override
  Widget? get child => super.child;

  @override
  PopupMenuItemState<T, CheckboxPopupMenuItem<T>> createState() =>
      _CheckboxPopupMenuItemState<T>();
}

class _CheckboxPopupMenuItemState<T>
    extends PopupMenuItemState<T, CheckboxPopupMenuItem<T>> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.checked;
  }

  @override
  void handleTap() {
    super.handleTap();
  }

  @override
  Widget buildChild() {
    return ListTile(
      enabled: widget.enabled,
      contentPadding: const EdgeInsets.all(0),
      trailing: Checkbox(
        value: checked,
        onChanged: (newValue) {
          widget.onChanged?.call(newValue);
          setState(() {
            if (newValue != null) checked = newValue;
          });
        },
      ),
      title: widget.child,
    );
  }
}
