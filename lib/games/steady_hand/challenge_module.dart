import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'challenge_platform.dart';
import 'steady_hand_module.dart';

/// This module is a modified version of Steady Hand used in the individual
/// dexterity challenge, out of the mini-game system.
class ChallengeModule extends SteadyHandModule {
  int _score = 0;

  @override
  get ballGravityMultiplier => super.ballGravityMultiplier / 5;
  @override
  get ballRadius => super.ballRadius / 3;
  int get score => _score;

  ChallengeModule({required super.notifyFallen});

  @override
  Component createPlatform() =>
      ChallengePlatform(view.size.toVector2(), _onScoreChange);

  @override
  Vector2 ballInitialPosition() =>
      view.topLeft.toVector2() + Vector2.all(ballRadius);

  @override
  void onLoad() {
    camera.viewfinder.anchor = Anchor.topLeft;
    super.onLoad();
  }

  void _onScoreChange(int value) {
    _score = value;
  }
}
