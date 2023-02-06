import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';
import 'outcome_screen.dart';

class LargeShot extends TurnPlay {
  LargeShot({super.key}) : super(gameFeatures: largeShot);

  @override
  createState() => ShotState();
}

class LargeShotOutcome extends OutcomeScreen {
  LargeShotOutcome({super.key}) : super(gameFeatures: largeShot);

  // Implement its OutcomeScreenState subclass
}
