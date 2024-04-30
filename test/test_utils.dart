// These utils are the only place where new top-level public members are
// allowed. Please be careful before introducing more, and consider how they may
// affect the reliability of the tests.
// ignore_for_file: avoid-top-level-members-in-tests, prefer-getter-over-method

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension FindingByKey on Key {
  Finder found() => find.byKey(this);
}

extension FindingByText on String {
  Finder found() => find.text(this);
}

extension CustomTestUtils on WidgetTester {
  Future<void> pumpForNavigation() async {
    await pump();
    await pump(const Duration(seconds: 5));
  }

  Future<void> setSurfaceSize(int width, int height) async {
    await binding.setSurfaceSize(Size(width.toDouble(), height.toDouble()));
  }

  Future<void> restoreDefaultSurfaceSize() async {
    await binding.setSurfaceSize(null);
  }
}

class TestUtils {
  static void debugListRelevantWidgets({bool skipOffstage = false}) {
    debugPrint("=== Widgets with ValueKey<String> ===");
    find
        .byWidgetPredicate(
          (widget) => widget.key is ValueKey<String>,
          skipOffstage: skipOffstage,
        )
        .evaluate()
        .forEach((element) {
      debugPrint(element.widget.toString());
    });
    debugPrint("======== Text in widgets ========");
    find
        .byWidgetPredicate(
          (widget) => widget is Text,
          skipOffstage: skipOffstage,
        )
        .evaluate()
        .forEach((element) {
      debugPrint((element.widget as Text).data);
    });
    debugPrint("=====================================");
  }
}
