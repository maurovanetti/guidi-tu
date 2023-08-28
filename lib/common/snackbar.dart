import 'dart:async';

import 'package:flutter/material.dart';

class QuickMessage {
  static final _instance = QuickMessage._internal();
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackBarController;

  QuickMessage._internal();
  factory QuickMessage() => _instance;

  void showQuickMessage(
    String message, {
    required BuildContext context,
    bool longer = false,
  }) {
    // The quick message does not require any feedback.
    _snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: longer ? 5 : 2),
      ),
    );
    unawaited(_resetSnackBarController());
  }

  void hideQuickMessage() {
    _snackBarController?.close();
    _snackBarController = null;
  }

  Future<void> _resetSnackBarController() async {
    var _ = await _snackBarController?.closed;
    _snackBarController = null;
  }
}
