import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerNameField extends TextField {
  PlayerNameField({
    super.key,
    super.controller,
    super.onChanged,
    required ThemeData themeData,
  }) : super(
          decoration: const InputDecoration(counterText: 'max 5 lettere'),
          inputFormatters: const [UpperCaseTextFormatter(5)],
          textCapitalization: TextCapitalization.characters,
          style: themeData.textTheme.headlineLarge,
        );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  final int maxLength;

  const UpperCaseTextFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return (newValue.text.length > maxLength)
        ? oldValue
        : TextEditingValue(
            text: newValue.text.toUpperCase(),
            selection: newValue.selection,
            composing: newValue.composing,
          );
  }
}
