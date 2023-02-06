import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';

class LargeShot extends TurnPlay {
  LargeShot({super.key}) : super(gameFeatures: largeShot);

  @override
  createState() => ShotState();
}
