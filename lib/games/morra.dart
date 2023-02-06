import '/common/game_features.dart';
import '/games/turn_play.dart';
import 'outcome_screen.dart';

class Morra extends TurnPlay {
  Morra({super.key}) : super(gameFeatures: morra);

  // Implement its TurnPlayState subclass
}

class MorraOutcome extends OutcomeScreen {
  MorraOutcome({super.key}) : super(gameFeatures: largeShot);

  // Implement its OutcomeScreenState subclass
}
