import 'package:flame/components.dart';

import 'challenge_platform.dart';
import 'steady_hand_module.dart';

/// This module is a modified version of Steady Hand used in the individual
/// dexterity challenge, out of the mini-game system.
class ChallengeModule extends SteadyHandModule {
  @override
  double get ballRadius => 1.0;

  ChallengeModule({required super.notifyFallen});

  @override
  Component createPlatform() => ChallengePlatform(size);

  @override
  Vector2 ballInitialPosition() {
    return Vector2(1, 1) * ballRadius;
  }
}
