import '/common/game_features.dart';
import '/games/turn_play.dart';

class Morra extends TurnPlay {
  @override
  GameFeatures get gameFeatures => morra;

  const Morra({super.key});
}
