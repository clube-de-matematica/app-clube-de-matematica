import 'package:flutter/material.dart';

/// Um [PopupMenuItem] com um [Checkbox] à direita.
class CheckboxPopupMenuItem<T> extends PopupMenuItem<T> {
  const CheckboxPopupMenuItem({
    super.key,
    super.value,
    this.checked = false,
    required this.onChanged,
    super.enabled,
    super.padding,
    super.height,
    super.child,
  });

  final bool checked;
  final void Function(bool?)? onChanged;


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
