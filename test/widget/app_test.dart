import 'package:flutter_test/flutter_test.dart';
import 'package:guidi_tu/common/game_features.dart';
import 'package:guidi_tu/common/widget_keys.dart';
import 'package:guidi_tu/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Bubbles can break tests using pumpAndSettle (they never settle), but it's
    // better in any case to avoid pumpAndSettle and use pumpForNavigation (a
    // custom extension) instead.
    // Uncomment the following line to restore the bubble-less testing.
    // WithBubbles.enabled = false;
    SharedPreferences.setMockInitialValues({});
  });

  group("App journey", () {
    testWidgets("App can start", (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester
          .pump(const Duration(seconds: 4)); // Initial animation must complete
    });

    testWidgets("App can complete a match", (WidgetTester tester) async {
      // The AspectRatio widget breaks the test with the default size because it
      // prevents the widgets below it from being laid out.
      await tester.setSurfaceSize(400, 880);
      // TODO Fix the layout so that this is not necessary anymore

      // Home page
      await tester.pumpWidget(const App());
      await tester
          .pump(const Duration(seconds: 4)); // Initial animation must complete
      expect(toTutorialWidgetKey.found(), findsOneWidget);
      await tester.tap(toTutorialWidgetKey.found());
      await tester.pumpForNavigation();

      // Tutorial page
      expect(toTutorialWidgetKey.found(), findsNothing);
      expect(toTeamWidgetKey.found(), findsOneWidget);
      await tester.tap(toTeamWidgetKey.found());
      await tester.pumpForNavigation();

      // Team page
      expect(toTeamWidgetKey.found(), findsNothing);
      await tester.tap(addPlayerWidgetKey.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      expect(editPlayerWidgetKey.found(), findsOneWidget);
      await tester.enterText(editPlayerNameWidgetKey.found(), "TIZIO");
      await tester.tap(setMasculinePlayerWidgetKey.found());
      await tester.tap(submitEditPlayerWidgetKey.found());
      await tester.pumpForNavigation(); // Closing dialog and refreshing page
      await tester.tap(addPlayerWidgetKey.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      expect(editPlayerWidgetKey.found(), findsOneWidget);
      await tester.enterText(editPlayerNameWidgetKey.found(), "CAIA");
      await tester.tap(setFemininePlayerWidgetKey.found());
      await tester.tap(submitEditPlayerWidgetKey.found());
      await tester.pumpForNavigation(); // Closing dialog and refreshing page
      await tester.ensureVisible(toPickWidgetKey.found());
      expect(toPickWidgetKey.found(), findsOneWidget);
      await tester.tap(toPickWidgetKey.found());
      await tester.pumpForNavigation();

      // Pick page
      expect(toPickWidgetKey.found(), findsNothing);
      expect(pickGameWidgetKey(largeShot.name).found(), findsOneWidget);
      await tester.tap(pickGameWidgetKey(largeShot.name).found());
      expect(toTurnInterstitialWidgetKey.found(), findsOneWidget);
      await tester.tap(toTurnInterstitialWidgetKey.found());
      await tester.pumpForNavigation();

      // Turn interstitial page (1st player)
      expect(toTurnInterstitialWidgetKey.found(), findsNothing);
      expect(toTurnPlayWidgetKey.found(), findsOneWidget);
      await tester.ensureVisible(toTurnPlayWidgetKey.found());
      await tester.tap(toTurnPlayWidgetKey.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      expect(hiddenPlayAlertWidgetKey.found(), findsOneWidget);
      expect(acknowledgeHiddenPlayWidgetKey.found(), findsOneWidget);
      await tester.tap(acknowledgeHiddenPlayWidgetKey.found());
      await tester.pumpForNavigation(); // Actual navigation

      // Turn play page (1st player)
      expect(toTurnPlayWidgetKey.found(), findsNothing);
      expect(largeShotWidgetKey.found(), findsOneWidget);
      await tester.ensureVisible(clockWidgetKey.found());
      expect(clockWidgetKey.found(), findsOneWidget);
      await tester.ensureVisible(toNextTurnWidgetKey.found());
      expect(toNextTurnWidgetKey.found(), findsOneWidget);
      await tester.tap(toNextTurnWidgetKey.found());
      await tester.pumpForNavigation();

      // Turn interstitial page (2nd player)
      expect(toNextTurnWidgetKey.found(), findsNothing);
      expect(toTurnPlayWidgetKey.found(), findsOneWidget);
      await tester.ensureVisible(toTurnPlayWidgetKey.found());
      await tester.tap(toTurnPlayWidgetKey.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      expect(hiddenPlayAlertWidgetKey.found(), findsOneWidget);
      expect(acknowledgeHiddenPlayWidgetKey.found(), findsOneWidget);
      await tester.tap(acknowledgeHiddenPlayWidgetKey.found());
      await tester.pumpForNavigation(); // Actual navigation

      // Turn play page (2nd player)
      expect(toTurnPlayWidgetKey.found(), findsNothing);
      expect(largeShotWidgetKey.found(), findsOneWidget);
      await tester.ensureVisible(clockWidgetKey.found());
      expect(clockWidgetKey.found(), findsOneWidget);
      await tester.ensureVisible(toNextTurnWidgetKey.found());
      expect(toNextTurnWidgetKey.found(), findsOneWidget);
      await tester.tap(toNextTurnWidgetKey.found());
      await tester.pumpForNavigation();

      // Completion screen
      expect(toNextTurnWidgetKey.found(), findsNothing);
      expect(toOutcomeWidgetKey.found(), findsOneWidget);
      await tester.tap(toOutcomeWidgetKey.found());
      await tester.pumpForNavigation();

      // Outcome screen
      expect(toOutcomeWidgetKey.found(), findsNothing);
      expect(toPlacementWidgetKey.found(), findsOneWidget);
      await tester.tap(toPlacementWidgetKey.found());
      await tester.pumpForNavigation();

      // Placement screen
      expect(toPlacementWidgetKey.found(), findsNothing);
      expect(toHomeWidgetKey.found(), findsOneWidget);
      await tester.tap(toHomeWidgetKey.found());
      await tester.pumpForNavigation();

      // Home screen again
      await tester
          .pump(const Duration(seconds: 4)); // Initial animation must complete
      expect(toHomeWidgetKey.found(), findsNothing);
      expect(toTutorialWidgetKey.found(), findsOneWidget);
      expect("TIZIO".found(), findsOneWidget);
      expect("CAIA".found(), findsOneWidget);

      await tester.restoreDefaultSurfaceSize();
    });
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
