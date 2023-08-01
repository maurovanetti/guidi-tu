import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'boules_bowl.dart';

class BoulesModule extends Forge2DGame {
  static const boulesSetupKey = "boulesSetup";
  final void Function(bool ready) setReady;
  late final List<BoulesBowl> _bowls;
  Vector2? _lastBowlPosition;
  Vector2? get lastBowlPosition => _lastBowlPosition;

  BoulesModule({required this.setReady});

  @override
  backgroundColor() => Colors.green[900]!;

  @override
  Future<void> onLoad() async {
    world.setGravity(Vector2.zero());
    _bowls = await retrieveBowls();
    for (var bowl in _bowls) {
      add(bowl);
    }
    init();
  }

  Future<List<BoulesBowl>> retrieveBowls() async {
    List<BoulesBowl> bowls = [];
    var sessionData = await TeamAware.retrieveSessionData();
    if (sessionData.containsKey(boulesSetupKey)) {
      debugPrint("Loading jack + bowls from session data");
      var boulesSetup = sessionData[boulesSetupKey];
      for (var bowlSetup in boulesSetup) {
        var bowl = BoulesBowl.fromJson(bowlSetup);
        bowls.add(bowl);
      }
    } else {
      var jackPosition = Vector2(size.x / 2, size.y / 5);
      var jack = BoulesJack(jackPosition);
      bowls.add(jack);
      TeamAware.storeSessionData({
        boulesSetupKey: [jack.toJson()],
      });
    }
    return bowls;
  }

  void init() {}
}
