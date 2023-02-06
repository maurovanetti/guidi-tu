import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';

class SmallShot extends TurnPlay {
  const SmallShot({super.key});

  @override
  GameFeatures get gameFeatures => smallShot;

  @override
  createState() => ShotState();
}
