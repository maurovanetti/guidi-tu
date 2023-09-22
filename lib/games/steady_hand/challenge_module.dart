import 'package:flame/components.dart';

import 'challenge_platform.dart';
import 'steady_hand_module.dart';

/// This module is a modified version of Steady Hand used in the individual
/// dexterity challenge, out of the mini-game system.
class ChallengeModule extends SteadyHandModule {
  int _score = 0;

  @override
  get ballGravityMultiplier => super.ballGravityMultiplier / 3;
  @override
  get ballRadius => super.ballRadius / 3;
  int get score => _score;

  ChallengeModule({required super.notifyFallen});

  @override
  Component createPlatform() => ChallengePlatform(size, _onScoreChange);

  @override
  Vector2 ballInitialPosition() {
    return Vector2(1, 1) * ballRadius;
  }

  void _onScoreChange(int value) {
    _score = value;
  }
}
