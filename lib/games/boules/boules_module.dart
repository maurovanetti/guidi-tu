import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/flame/forge2d_game_with_dragging.dart';
import 'boules_bowl.dart';
import 'boules_target.dart';

class BoulesModule extends Forge2DGameWithDragging {
  static const boulesSetupKey = "boulesSetup";
  final void Function(bool ready) setReady;
  late final List<BoulesBowl> _bowls;
  late Vector2 _startPosition;
  Vector2? _lastBowlPosition;

  Vector2? get lastBowlPosition => _lastBowlPosition;

  late final BoulesTarget _target;

  @override
  PositionComponent get dragged => _target;

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
    _startPosition = Vector2(size.x / 2, size.y - (BoulesBowl.radius * 1.5));
    add(BoulesBowl(_startPosition, player: TurnAware.currentPlayer));
    _target = BoulesTarget(
      _startPosition - Vector2(0, size.y / 3),
      origin: _startPosition,
      referenceColor: TurnAware.currentPlayer.color,
    );
    add(_target);
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

  @override
  bool containsLocalPoint(Vector2 p) {
    if (screenToWorld(p).y > _startPosition.y) {
      return false;
    }
    return super.containsLocalPoint(p);
  }
}
