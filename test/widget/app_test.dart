// Tests should be compact and sometimes repetitive, even a little dumb. For
// this reason, we ignore several elegance rules in tests.
// ignore_for_file: avoid-ignoring-return-values
// ignore_for_file: prefer-test-matchers
// ignore_for_file: avoid-long-functions
// ignore_for_file: avoid-importing-entrypoint-exports
// ignore_for_file: no-magic-number
// ignore_for_file: prefer-moving-to-variable

import 'package:flutter_test/flutter_test.dart';
import 'package:guidi_tu/common/game_features.dart';
import 'package:guidi_tu/common/persistence.dart';
import 'package:guidi_tu/common/widget_keys.dart';
import 'package:guidi_tu/main.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Bubbles can break tests using pumpAndSettle (they never settle), but it's
    // better in any case to avoid pumpAndSettle and use pumpForNavigation (a
    // custom extension) instead.
    // Uncomment the following line to restore the bubble-less testing.
    // WithBubbles.enabled = false;
    await Persistence.init(production: false);
    db.clear();
  });

  group("App journey", () {
    testWidgets("App can start", (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester
          .pump(const Duration(seconds: 4)); // Initial animation must complete
      expect(WidgetKeys.toTutorial.found(), findsOneWidget);
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
      await tester.tap(WidgetKeys.toTutorial.found());
      await tester.pumpForNavigation();

      // Tutorial page
      expect(WidgetKeys.toTutorial.found(), findsNothing);
      expect(WidgetKeys.toTeam.found(), findsOneWidget);
      await tester.tap(WidgetKeys.toTeam.found());
      await tester.pumpForNavigation();
      await tester.tap(WidgetKeys.toTeam.found());
      await tester.pumpForNavigation();
      await tester.tap(WidgetKeys.toTeam.found());
      await tester.pumpForNavigation();
      await tester.tap(WidgetKeys.toTeam.found());
      await tester.pumpForNavigation();

      // Team page
      expect(WidgetKeys.toTeam.found(), findsNothing);
      await tester.tap(WidgetKeys.addPlayer.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      expect(WidgetKeys.editPlayer.found(), findsOneWidget);
      await tester.enterText(WidgetKeys.editPlayerName.found(), "TIZIO");
      await tester.tap(WidgetKeys.setMasculinePlayer.found());
      await tester.tap(WidgetKeys.submitEditPlayer.found());
      await tester.pumpForNavigation(); // Closing dialog and refreshing page
      await tester.tap(WidgetKeys.addPlayer.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      // ignore: avoid-duplicate-test-assertions
      expect(WidgetKeys.editPlayer.found(), findsOneWidget);
      await tester.enterText(WidgetKeys.editPlayerName.found(), "CAIA");
      await tester.tap(WidgetKeys.setFemininePlayer.found());
      await tester.tap(WidgetKeys.submitEditPlayer.found());
      await tester.pumpForNavigation(); // Closing dialog and refreshing page
      await tester.tap(WidgetKeys.addPlayer.found());
      await tester.pump(); // Not a navigation, just a dialog opening
      // ignore: avoid-duplicate-test-assertions
      expect(WidgetKeys.editPlayer.found(), findsOneWidget);
      await tester.enterText(WidgetKeys.editPlayerName.found(), "SEMPY");
      await tester.tap(WidgetKeys.submitEditPlayer.found());
      await tester.pumpForNavigation(); // Closing dialog and refreshing page
      await tester.ensureVisible(WidgetKeys.toPick.found());
      expect(WidgetKeys.toPick.found(), findsOneWidget);
      await tester.tap(WidgetKeys.toPick.found());
      await tester.pumpForNavigation();

      // Pick page
      expect(WidgetKeys.toPick.found(), findsNothing);
      expect(WidgetKeys.pickGame(largeShot.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(smallShot.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(morra.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(battleship.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(stopwatch.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(steadyHand.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(ouija.id).found(), findsOneWidget);
      expect(WidgetKeys.pickGame(boules.id).found(), findsOneWidget);
      await tester.tap(WidgetKeys.pickGame(largeShot.id).found());
      await tester.pumpAndSettle();
      expect(WidgetKeys.toInterstitial(largeShot.id).found(), findsOneWidget);
      await tester.tap(WidgetKeys.toInterstitial(largeShot.id).found());
      await tester.pumpForNavigation();

      // Interstitial page
      expect(WidgetKeys.toInterstitial(largeShot.id).found(), findsNothing);
      expect(WidgetKeys.toTurnInstructions.found(), findsOneWidget);
      await tester.tap(WidgetKeys.toTurnInstructions.found());
      await tester.pumpForNavigation();

      for (int i = 0; i < 3; i++) {
        // Turn instructions page (n-th player)
        expect(WidgetKeys.toTurnInstructions.found(), findsNothing);
        await tester.ensureVisible(WidgetKeys.toTurnPlay.found());
        expect(WidgetKeys.toTurnPlay.found(), findsOneWidget);
        await tester.tap(WidgetKeys.toTurnPlay.found());
        await tester.pump(); // Not a navigation, just a dialog opening
        expect(WidgetKeys.hiddenPlayAlert.found(), findsOneWidget);
        expect(WidgetKeys.acknowledgeHiddenPlay.found(), findsOneWidget);
        await tester.tap(WidgetKeys.acknowledgeHiddenPlay.found());
        await tester.pumpForNavigation(); // Actual navigation

        // Turn play page (n-th player)
        expect(WidgetKeys.toTurnPlay.found(), findsNothing);
        expect(WidgetKeys.largeShot.found(), findsOneWidget);
        await tester.ensureVisible(WidgetKeys.clock.found());
        expect(WidgetKeys.clock.found(), findsOneWidget);
        await tester.ensureVisible(WidgetKeys.toNextTurn.found());
        expect(WidgetKeys.toNextTurn.found(), findsOneWidget);
        await tester.tap(WidgetKeys.toNextTurn.found());
        await tester.pumpForNavigation();
      }

      // Completion screen
      expect(WidgetKeys.toNextTurn.found(), findsNothing);
      expect(WidgetKeys.toOutcome.found(), findsOneWidget);
      await tester.tap(WidgetKeys.toOutcome.found());
      await tester.pumpForNavigation();

      // Outcome screen
      expect(WidgetKeys.toOutcome.found(), findsNothing);
      expect(WidgetKeys.toPlacement.found(), findsOneWidget);
      await tester.tap(WidgetKeys.toPlacement.found());
      await tester.pumpForNavigation();

      // Placement screen
      expect(WidgetKeys.toPlacement.found(), findsNothing);
      expect(WidgetKeys.toHome.found(), findsOneWidget);
      await tester.tap(WidgetKeys.toHome.found());
      await tester.pumpForNavigation();

      // Home screen again
      await tester
          .pump(const Duration(seconds: 4)); // Initial animation must complete
      expect(WidgetKeys.toHome.found(), findsNothing);
      expect(WidgetKeys.toTutorial.found(), findsOneWidget);
      int qualified = 0;
      if ("TIZIO".found().tryEvaluate()) qualified++;
      if ("CAIA".found().tryEvaluate()) qualified++;
      if ("SEMPY".found().tryEvaluate()) qualified++;
      expect(qualified, 2);
      await tester.restoreDefaultSurfaceSize();
    });
  });

  group("Saved driver + payer", () {
    testWidgets(
      "App doesn't show driver + payer at start if missing",
      (WidgetTester tester) async {
        await tester.pumpWidget(const App());
        expect(WidgetKeys.driver.found(), findsNothing);
        expect(WidgetKeys.payer.found(), findsNothing);
        await tester.pump(const Duration(seconds: 4)); // End initial animation
        expect("GUIDO".found(), findsNothing);
        expect("PAGO".found(), findsNothing);
        expect(WidgetKeys.driver.found(), findsOneWidget);
        expect(WidgetKeys.payer.found(), findsOneWidget);
      },
    );

    testWidgets(
      "App shows driver + payer at start if not expired",
      (WidgetTester tester) async {
        db.set('awardsTime', DateTime.now().millisecondsSinceEpoch);
        db.set('payer', 'PAGO');
        db.set('driver', 'GUIDO');
        await tester.pumpWidget(const App());
        expect(WidgetKeys.driver.found(), findsNothing);
        expect(WidgetKeys.payer.found(), findsNothing);
        await tester.pump(const Duration(seconds: 4)); // End initial animation

        expect("GUIDO".found(), findsOneWidget);
        expect("PAGO".found(), findsOneWidget);
      },
    );

    testWidgets(
      "App hides driver + payer at start if expired",
      (WidgetTester tester) async {
        db.set(
          'awardsTime',
          DateTime.now()
              .subtract(const Duration(days: 2))
              .millisecondsSinceEpoch,
        );
        db.set('payer', 'PAGO');
        db.set('driver', 'GUIDO');
        await tester.pumpWidget(const App());
        expect(WidgetKeys.driver.found(), findsNothing);
        expect(WidgetKeys.payer.found(), findsNothing);
        await tester.pump(const Duration(seconds: 4)); // End initial animation
        expect("GUIDO".found(), findsNothing);
        expect("PAGO".found(), findsNothing);
        expect(WidgetKeys.driver.found(), findsOneWidget);
        expect(WidgetKeys.payer.found(), findsOneWidget);
      },
    );
  });
}
