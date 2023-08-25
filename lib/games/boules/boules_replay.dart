import '/common/common.dart';
import 'boules_module.dart';
import 'boules_bowl.dart';

class BoulesReplay extends BoulesModule {
  BoulesReplay() : super(setReady: (_) {});

  @override
  void init() {
    // No need for new bowl at replay.

    // Keeps only the best shot for each player.
    final bestBowls = <Player, BoulesBowl>{};
    for (BoulesBowl bowl in playedBowls) {
      var player = bowl.player;
      if (!bestBowls.containsKey(player)) {
        bestBowls[player] = bowl;
      } else {
        var bestBowl = bestBowls[player]!;
        // We use initialPosition because in the replay, the bowls are not
        // moving. Moreover, the body is not created yet, so we cannot use it.
        if (bowl.initialPosition.distanceTo(updatedJackPosition) <
            bestBowl.initialPosition.distanceTo(updatedJackPosition)) {
          bestBowls[player] = bowl;
        }
      }
    }

    Future.delayed(const Duration(seconds: 2), () {
      // Flashes away the bad shots.
      for (BoulesBowl bowl in playedBowls) {
        if (bowl != bestBowls[bowl.player]) {
          bowl.sprite.flash();
        }
      }
    });

    super.onMount();
  }
}
