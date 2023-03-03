import '/common/widget_keys.dart';
import '/common/move.dart';
import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';
import 'game_area.dart';
import 'outcome_screen.dart';

class SmallShot extends TurnPlay {
  SmallShot() : super(key: WidgetKeys.smallShot, gameFeatures: smallShot);

  @override
  createState() => TurnPlayState<ShotMove>();
}

class SmallShotGameArea extends GameArea<ShotMove> {
  SmallShotGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
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
