import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../flame/custom_text_box_component.dart';
import '/common/common.dart';
import '/games/flame/forge2d_game_with_dragging.dart';
import 'boules_bowl.dart';
import 'boules_target.dart';
import 'boules_wall.dart';

class BoulesModule extends Forge2DGameWithDragging {
  static const boulesSetupKey = "boulesSetup";
  final void Function(bool ready) setReady;
  late final List<BoulesBowl> _bowls;
  late Vector2 _startPosition;
  Vector2? _lastBowlPosition;

  Vector2? get lastBowlPosition => _lastBowlPosition;

  late final BoulesBowl _activeBowl;
  late final BoulesTarget _target;

  @override
  PositionComponent? get dragged => _target.isMounted ? _target : null;

  BoulesModule({required this.setReady});

  @override
  backgroundColor() => Colors.green[900]!;

  @override
  Future<void> onLoad() async {
    world.setGravity(Vector2.zero());
    add(BoulesWall(Vector2.zero(), Vector2(size.x, 0)));
    add(BoulesWall(Vector2.zero(), Vector2(0, size.y)));
    add(BoulesWall(Vector2(size.x, 0), Vector2(size.x, size.y)));
    add(BoulesWall(Vector2(0, size.y), Vector2(size.x, size.y)));
    _bowls = await retrieveBowls();
    for (var bowl in _bowls) {
      add(bowl);
    }
    _startPosition = Vector2(size.x / 2, size.y - (BoulesBowl.radius * 1.5));
    _activeBowl = BoulesBowl(_startPosition, player: TurnAware.currentPlayer);
    add(_activeBowl);
    _target = BoulesTarget(
      _startPosition - Vector2(0, BoulesBowl.radius * 2),
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
      var jack = BoulesJack(_jackPosition);
      bowls.add(jack);
      TeamAware.storeSessionData({
        boulesSetupKey: [jack.toJson()],
      });
    }
    return bowls;
  }

  Vector2 get _jackPosition => Vector2(size.x / 2, size.y / 5);

  CustomTextBoxComponent? _hint;

  void init() {
    _hint = CustomTextBoxComponent(
      "Trascina la freccia e poi lascia andare per lanciare la boccia",
      _jackPosition + Vector2(0, BoulesJack.radius * 2),
      autoDismiss: true,
      scale: 1 / zoom,
    );
    add(_hint!);
  }

  @override
  bool containsLocalPoint(Vector2 p) {
    if (screenToWorld(p).y > _startPosition.y) {
      return false;
    }
    return super.containsLocalPoint(p);
  }

  @override
  void onDragStart(DragStartEvent event) {
    _hint?.dismiss();
    super.onDragStart(event);
  }

  @override
  void onRelevantDragEnd() {
    if (dragged != null) {
      _activeBowl.launchTowards(dragged!.position);
      remove(dragged!);
    }
  }
}
