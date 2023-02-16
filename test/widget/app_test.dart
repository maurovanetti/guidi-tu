import 'package:flutter_test/flutter_test.dart';
import 'package:guidi_tu/common/bubble.dart';
import 'package:guidi_tu/common/widget_keys.dart';
import 'package:guidi_tu/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    WithBubbles.enabled = false;
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets("App can start", (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester
        .pump(const Duration(seconds: 4)); // Initial animation must complete
  });

  group("Saved driver + payer", () {
    testWidgets("App doesn't show driver + payer at start if missing",
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(driverWidgetKey.found(), findsOneWidget);
      expect(payerWidgetKey.found(), findsOneWidget);
      await tester.pump(const Duration(seconds: 4)); // End initial animation
      expect("GUIDO".found(), findsNothing);
      expect("PAGO".found(), findsNothing);
      expect(driverWidgetKey.found(), findsOneWidget);
      expect(payerWidgetKey.found(), findsOneWidget);
    });

    testWidgets("App shows driver + payer at start if not expired",
        (WidgetTester tester) async {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt('awardsTime', DateTime.now().millisecondsSinceEpoch);
      await prefs.setString('payer', 'PAGO');
      await prefs.setString('driver', 'GUIDO');
      await tester.pumpWidget(const App());
      expect(driverWidgetKey.found(), findsOneWidget);
      expect(payerWidgetKey.found(), findsOneWidget);
      await tester.pump(const Duration(seconds: 4)); // End initial animation
      var guido = "GUIDO".found().evaluate().single.widget;
      var driver = driverWidgetKey.found().evaluate().single.widget;
      expect(guido, driver);
      var pago = "PAGO".found().evaluate().single.widget;
      var payer = payerWidgetKey.found().evaluate().single.widget;
      expect(pago, payer);
    });

    testWidgets("App hides driver + payer at start if expired",
        (WidgetTester tester) async {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          'awardsTime',
          DateTime.now()
              .subtract(const Duration(days: 2))
              .millisecondsSinceEpoch);
      await prefs.setString('payer', 'PAGO');
      await prefs.setString('driver', 'GUIDO');
      await tester.pumpWidget(const App());
      expect(driverWidgetKey.found(), findsOneWidget);
      expect(payerWidgetKey.found(), findsOneWidget);
      await tester.pump(const Duration(seconds: 4)); // End initial animation
      expect("GUIDO".found(), findsNothing);
      expect("PAGO".found(), findsNothing);
      expect(driverWidgetKey.found(), findsOneWidget);
      expect(payerWidgetKey.found(), findsOneWidget);
    });
  });
}
