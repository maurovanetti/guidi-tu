import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'shot.dart';

class SmallShot extends TurnPlayScreen {
  SmallShot() : super(key: WidgetKeys.smallShot, gameFeatures: smallShot);

  @override
  createState() => TurnPlayState<ShotMove>();
}

class SmallShotGameArea extends GameArea<ShotMove> {
  SmallShotGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: largeShot,
          moveReceiver: moveReceiver as MoveReceiver<ShotMove>,
        );

  @override
  createState() => ShotGameAreaState();
}

class SmallShotOutcome extends OutcomeScreen {
  SmallShotOutcome({super.key}) : super(gameFeatures: smallShot);

  @override
  ShotOutcomeState createState() => ShotOutcomeState();
}
