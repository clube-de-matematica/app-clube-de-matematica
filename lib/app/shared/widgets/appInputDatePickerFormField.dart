// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

/// A [TextFormField] configured to accept and validate a date entered by a user.
///
/// When the field is saved or submitted, the text will be parsed into a
/// [DateTime] according to the ambient locale's compact date format. If the
/// input text doesn't parse into a date, the [errorFormatText] message will
/// be displayed under the field.
///
/// [firstDate], [lastDate], and [selectableDayPredicate] provide constraints on
/// what days are valid. If the input date isn't in the date range or doesn't pass
/// the given predicate, then the [errorInvalidText] message will be displayed
/// under the field.
///
/// See also:
///
///  * [showDatePicker], which shows a dialog that contains a material design
///    date picker which includes support for text entry of dates.
///  * [MaterialLocalizations.parseCompactDate], which is used to parse the text
///    input into a [DateTime].
///
class AppInputDatePickerFormField extends StatefulWidget {
  /// Creates a [TextFormField] configured to accept and validate a date.
  ///
  /// If the optional [initialDate] is provided, then it will be used to populate
  /// the text field. If the [fieldHintText] is provided, it will be shown.
  ///
  /// If [initialDate] is provided, it must not be before [firstDate] or after
  /// [lastDate]. If [selectableDayPredicate] is provided, it must return `true`
  /// for [initialDate].
  ///
  /// [firstDate] must be on or before [lastDate].
  ///
  /// [firstDate], [lastDate], and [autofocus] must be non-null.
  ///
  AppInputDatePickerFormField({
    Key? key,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    this.onDateSubmitted,
    this.onDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.nullable = false,
  })  : initialDate =
            initialDate != null ? DateUtils.dateOnly(initialDate) : null,
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        super(key: key) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          initialDate == null ||
          selectableDayPredicate!(this.initialDate!),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.',
    );
  }

  /// If provided, it will be used as the default value of the field.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can input.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can input.
  final DateTime lastDate;

  /// An optional method to call when the user indicates they are done editing
  /// the text in the field. Will only be called if the input represents a valid
  /// [DateTime].
  final ValueChanged<DateTime?>? onDateSubmitted;

  /// An optional method to call with the final date when the form is
  /// saved via [FormState.save]. Will only be called if the input represents
  /// a valid [DateTime].
  final ValueChanged<DateTime?>? onDateSaved;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String? errorInvalidText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format string. For example,
  /// 'mm/dd/yyyy' for en_US.
  final String? fieldHintText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String? fieldLabelText;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Se `true` a validação considerará o valor `null` como válido.
  final bool nullable;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  State<AppInputDatePickerFormField> createState() =>
      _AppInputDatePickerFormFieldState();
}

class _AppInputDatePickerFormFieldState
    extends State<AppInputDatePickerFormField> {
  final TextEditingController _controller = _DateEditingController();
  DateTime? _selectedDate;
  String? _inputText;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateValueForSelectedDate();
  }

  @override
  void didUpdateWidget(AppInputDatePickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      // Can't update the form field in the middle of a build, so do it next frame
      WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          _selectedDate = widget.initialDate;
          _updateValueForSelectedDate();
        });
      });
    }
  }

  void _updateValueForSelectedDate() {
    if (_selectedDate != null) {
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      _inputText = localizations.formatCompactDate(_selectedDate!);
      TextEditingValue textEditingValue =
          _controller.value.copyWith(text: _inputText);
      // Select the new text if we are auto focused and haven't selected the text before.
      if (widget.autofocus && !_autoSelected) {
        textEditingValue = textEditingValue.copyWith(
            selection: TextSelection(
          baseOffset: 0,
          extentOffset: _inputText!.length,
        ));
        _autoSelected = true;
      }
      _controller.value = textEditingValue;
    } else {
      _inputText = '';
      _controller.value = _controller.value.copyWith(text: _inputText);
    }
  }

  DateTime? _parseDate(String? text) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  bool _isValidAcceptableDate(DateTime? date) {
    if (date == null && widget.nullable) return true;
    return date != null &&
        !date.isBefore(widget.firstDate) &&
        !date.isAfter(widget.lastDate) &&
        (widget.selectableDayPredicate == null ||
            widget.selectableDayPredicate!(date));
  }

  String? _validateDate(String? text) {
    if (text?.isEmpty ?? true) {
      if (widget.nullable) return null;
      return 'Insira uma data.';
    }
    final DateTime? date = _parseDate(text);
    if (date == null) {
      return widget.errorFormatText ??
          MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      return widget.errorInvalidText ??
          MaterialLocalizations.of(context).dateOutOfRangeLabel;
    }
    return null;
  }

  void _updateDate(String? text, ValueChanged<DateTime?>? callback) {
    final DateTime? date = _parseDate(text);
    if (_isValidAcceptableDate(date)) {
      _selectedDate = date;
      _inputText = text;
      callback?.call(_selectedDate);
    }
  }

  void _handleSaved(String? text) {
    _updateDate(text, widget.onDateSaved);
  }

  void _handleSubmitted(String text) {
    _updateDate(text, widget.onDateSubmitted);
  }

  void _handleChanged(String text) {
    _updateDate(text, null);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final InputDecorationTheme inputTheme =
        Theme.of(context).inputDecorationTheme;
    return TextFormField(
      decoration: InputDecoration(
        border: inputTheme.border ?? const UnderlineInputBorder(),
        filled: inputTheme.filled,
        hintText: widget.fieldHintText ?? localizations.dateHelpText,
        labelText: widget.fieldLabelText ?? localizations.dateInputLabel,
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range_outlined),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate ??
                  (DateUtils.dateOnly(DateTime.now()).isAfter(widget.firstDate)
                      ? DateUtils.dateOnly(DateTime.now())
                      : widget.firstDate),
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
            );
            if (date != null) {
              _handleSubmitted(localizations.formatCompactDate(date));
              if (mounted) _updateValueForSelectedDate();
            }
            if (widget.focusNode != null) {
              FocusScope.of(context).requestFocus(widget.focusNode);
            }
          },
        ),
      ),
      validator: _validateDate,
      keyboardType: TextInputType.datetime,
      textInputAction: widget.textInputAction,
      onSaved: _handleSaved,
      onFieldSubmitted: _handleSubmitted,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      controller: _controller,
      onChanged: _handleChanged,
    );
  }
}

/// O [TextEditingController] para o campo de data.
class _DateEditingController extends TextEditingController {
  _DateEditingController({String? text}) : super(text: text);

  @override
  set value(TextEditingValue newValue) {
    final oldText = value.text;
    final newText = newValue.text;
    int newOffset = newValue.selection.baseOffset;
    final formated = format(newText);
    if (formated != newText) {
      // Ajustar cursor quando dia ou mês é finalizado.
      if (oldText.length < newText.length) {
        if (newOffset == 2 ||
            newOffset == 5 ||
            newOffset == 3 ||
            newOffset == 6) {
          newOffset += 1;
        }
      }
      newValue = newValue.copyWith(
        text: formated,
        selection: TextSelection.collapsed(offset: newOffset),
        composing: TextRange.empty,
      );
    }
    super.value = newValue;
  }

  /// Retorna [text] formatado para dd/mm/aaaa.
  String format(String text) {
    final replaced = text.replaceAll('/', '');
    final day = replaced.substring(0, min<int>(2, replaced.length));
    final month = replaced.length > 2
        ? replaced.substring(2, min<int>(4, replaced.length))
        : '';
    final year = replaced.length > 4
        ? replaced.substring(4, min<int>(8, replaced.length))
        : '';
    String formated = '';
    [day, month, year].forEach((part) {
      formated += part;
      if (formated.length == 2 || formated.length == 5) formated += '/';
    });
    return formated;
  }
}
