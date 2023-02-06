import 'package:flutter/material.dart';

mixin QuickMessage {
  void showQuickMessage(String message, {required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
