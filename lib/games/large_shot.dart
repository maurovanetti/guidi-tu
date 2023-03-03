import 'package:guidi_tu/common/widget_keys.dart';

import '/common/move.dart';
import '/common/game_features.dart';
import '/games/shot.dart';
import '/games/turn_play.dart';
import 'game_area.dart';
import 'outcome_screen.dart';

class LargeShot extends TurnPlay {
  LargeShot() : super(key: largeShotWidgetKey, gameFeatures: largeShot);

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
