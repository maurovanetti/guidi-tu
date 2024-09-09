import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common.dart';

class PlayerNameField extends TextField {
  PlayerNameField({
    super.key,
    super.controller,
    super.onChanged,
    required ThemeData themeData,
    required AppLocalizations $,
  }) : super(
          decoration: InputDecoration(
            counterText: $.maxNLetters(maxNameLength),
          ),
          inputFormatters: const [UpperCaseTextFormatter(maxNameLength)],
          textCapitalization: TextCapitalization.characters,
          style: themeData.textTheme.headlineLarge,
        );

  static const maxNameLength = 5;
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
