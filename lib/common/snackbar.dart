import 'package:flutter/material.dart';

mixin QuickMessage {
  void showQuickMessage(String message, {required BuildContext context}) {
    // The quick message does not require any feedback.
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
