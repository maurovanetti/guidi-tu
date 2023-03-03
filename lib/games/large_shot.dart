import '/common/common.dart';
import '/screens/turn_play_screen.dart';
import '/screens/outcome_screen.dart';
import 'game_area.dart';
import 'shot.dart';

class LargeShot extends TurnPlayScreen {
  LargeShot() : super(key: WidgetKeys.largeShot, gameFeatures: largeShot);

  @override
  createState() => TurnPlayState<ShotMove>();
}

class LargeShotGameArea extends GameArea<ShotMove> {
  LargeShotGameArea({
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

class LargeShotOutcome extends OutcomeScreen {
  LargeShotOutcome({super.key}) : super(gameFeatures: largeShot);

  @override
  ShotOutcomeState createState() => ShotOutcomeState();
}
