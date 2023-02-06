import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';

class LargeShot extends TurnPlay {
  @override
  GameFeatures get gameFeatures => largeShot;

  const LargeShot({super.key});

  @override
  createState() => ShotState();
}
