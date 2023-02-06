import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';

class SmallShot extends TurnPlay {
  SmallShot({super.key}) : super(gameFeatures: smallShot);

  @override
  createState() => ShotState();
}
