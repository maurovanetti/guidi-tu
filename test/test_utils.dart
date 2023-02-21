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

void debugListRelevantWidgets() {
  debugPrint("=== Widgets with ValueKey<String> ===");
  find
      .byWidgetPredicate((widget) => widget.key is ValueKey<String>,
          skipOffstage: false)
      .evaluate()
      .forEach(
    (element) {
      debugPrint(element.widget.toString());
    },
  );
  debugPrint("======== Text in widgets ========");
  find
      .byWidgetPredicate((widget) => widget is Text, skipOffstage: false)
      .evaluate()
      .forEach(
    (element) {
      debugPrint((element.widget as Text).data);
    },
  );
  debugPrint("=====================================");
}
