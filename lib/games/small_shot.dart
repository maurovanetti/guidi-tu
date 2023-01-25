import '/common/game_features.dart';
import '/games/turn_play.dart';

class SmallShot extends TurnPlay {
  @override
  GameFeatures get gameFeatures => smallShot;

  const SmallShot({super.key});
}
