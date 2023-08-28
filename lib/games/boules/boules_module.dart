import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/flame/forge2d_game_with_dragging.dart';
import '../flame/custom_text_box_component.dart';
import 'boules_bowl.dart';
import 'boules_target.dart';
import 'boules_wall.dart';

class BoulesModule extends Forge2DGameWithDragging {
  static const boulesSetupKey = "boulesSetup";
  final void Function({bool ready}) setReady;
  final void Function(String message)? displayMessage;
  static const _minDragDuration = Duration(milliseconds: 500);
  late final List<BoulesBowl> _bowls;
  late final BoulesJack _jack;
  late Vector2 _startPosition;

  late final BoulesBowl _activeBowl;
  late final PositionComponent _target;
  late final BoulesArrowHead _arrowHead;

  CustomTextBoxComponent? _hint;

  bool _beholdTheOutcome = false;

  Vector2 get lastBowlPosition => _activeBowl.body.position;

  Vector2 get updatedJackPosition =>
      _jack.isLoaded ? _jack.body.position : _jack.initialPosition;

  Iterable<BoulesBowl> get playedBowls =>
      _bowls.where((bowl) => bowl is! BoulesJack);

  @override
  PositionComponent? get dragged => _target.isMounted ? _target : null;

  Vector2 get _initialJackPosition => Vector2(size.x / 2, size.y / 5);

  BoulesModule({required this.setReady, this.displayMessage})
      : super(minDragDuration: _minDragDuration);

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
    init();
    for (var bowl in _bowls) {
      add(bowl);
      bowl.addListener(_onBowlChangedState);
    }
  }

  Future<List<BoulesBowl>> retrieveBowls() async {
    List<BoulesBowl> bowls = [];
    var sessionData = await TeamAware.retrieveSessionData();
    if (sessionData.containsKey(boulesSetupKey)) {
      var boulesSetup = sessionData[boulesSetupKey];
      for (var bowlSetup in boulesSetup) {
        var bowl = BoulesBowl.fromJson(bowlSetup);
        bowls.add(bowl);
        if (bowl is BoulesJack) {
          _jack = bowl;
        }
      }
    } else {
      _jack = BoulesJack(_initialJackPosition);
      bowls.add(_jack);
      TeamAware.storeSessionData({
        boulesSetupKey: [_jack.toJson()],
      });
    }
    return bowls;
  }

  void init() {
    _startPosition = Vector2(size.x / 2, size.y - BoulesBowl.radius * (3 / 2));
    _activeBowl = BoulesBowl(_startPosition, player: TurnAware.currentPlayer);
    _bowls.add(_activeBowl);
    _target = PositionComponent(
      position: _startPosition - Vector2(0, BoulesBowl.radius * 4),
    );
    // ignore: avoid-async-call-in-sync-function
    add(_target);
    _arrowHead = BoulesArrowHead(
      origin: _startPosition,
      target: _target,
      referenceColor: TurnAware.currentPlayer.color,
    );
    // ignore: avoid-async-call-in-sync-function
    add(_arrowHead);
    _hint = CustomTextBoxComponent(
      "Trascina la freccia e poi lascia andare",
      _initialJackPosition + Vector2(0, BoulesJack.radius * 2),
      autoDismiss: true,
      scale: 1 / zoom,
    );
    // ignore: avoid-async-call-in-sync-function
    add(_hint!);
  }

  @override
  bool containsLocalPoint(Vector2 p) {
    return (screenToWorld(p).y > _startPosition.y)
        ? false
        : super.containsLocalPoint(p);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_hint?.isRemoved ?? true) {
      super.onDragStart(event);
    } else {
      _hint?.dismiss();
    }
  }

  @override
  void onRelevantDragEnd() {
    if (dragged != null) {
      _activeBowl.launchTowards(dragged!.position);
      remove(dragged!);
      remove(_arrowHead);
      Delay.after(3, () {
        _beholdTheOutcome = true;
        for (var bowl in _bowls) {
          bowl.prepareToStop();
        }
        // ignore: avoid-non-ascii-symbols
        displayMessage?.call("Aspettiamo che le bocce si fermino…");
        _onBowlChangedState();
      });
    }
  }

  void _onBowlChangedState() {
    if (_beholdTheOutcome && _bowls.every((bowl) => bowl.sleeping)) {
      unawaited(TeamAware.storeSessionData({
        boulesSetupKey: _bowls.map((bowl) => bowl.toJson()).toList(),
      }));
      setReady(ready: true);
    }
  }
}
