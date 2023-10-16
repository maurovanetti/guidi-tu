import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/flame/custom_text_box_component.dart';
import '/games/flame/forge2d_game_with_dragging.dart';
import 'boules_bowl.dart';
import 'boules_drag_projection.dart';
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
  late final BoulesDragProjection _dragProjection;
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

  Rect get view => camera.visibleWorldRect;

  Vector2 get _initialJackPosition =>
      Vector2(view.center.dx, view.top + view.height / 5);

  BoulesModule({required this.setReady, this.displayMessage})
      : super(minDragDuration: _minDragDuration);

  @override
  backgroundColor() => Colors.green[900]!;

  @override
  Future<void> onLoad() async {
    world.setGravity(Vector2.zero());
    camera.viewfinder.anchor = Anchor.topLeft;
    debugPrint("camera.viewport.size: ${camera.viewport.size}");
    debugPrint("camera.visibleWorldRect: ${camera.visibleWorldRect}");
    debugPrint("camera.viewport.position: ${camera.viewport.position}");
    world.add(BoulesWall(
      view.topLeft.toVector2(),
      view.topRight.toVector2(),
    ));
    world.add(BoulesWall(
      view.topRight.toVector2(),
      view.bottomRight.toVector2(),
    ));
    world.add(BoulesWall(
      view.bottomRight.toVector2(),
      view.bottomLeft.toVector2(),
    ));
    world.add(BoulesWall(
      view.bottomLeft.toVector2(),
      view.topLeft.toVector2(),
    ));
    _bowls = await retrieveBowls();
    init();
    for (var bowl in _bowls) {
      world.add(bowl);
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
      debugPrint("initial jack position: $_initialJackPosition");
      _jack = BoulesJack(_initialJackPosition);
      bowls.add(_jack);
      TeamAware.storeSessionData({
        boulesSetupKey: [_jack.toJson()],
      });
    }
    return bowls;
  }

  void init() {
    _startPosition =
        (view.bottomCenter + const Offset(0, -BoulesBowl.radius * (3 / 2)))
            .toVector2();
    _activeBowl = BoulesBowl(_startPosition, player: TurnAware.currentPlayer);
    _bowls.add(_activeBowl);
    _target = PositionComponent(
      position: _startPosition - Vector2(0, BoulesBowl.radius * 4),
    );
    // ignore: avoid-async-call-in-sync-function
    world.add(_target);
    _dragProjection = BoulesDragProjection(
      origin: _startPosition,
      target: _target,
    );
    // ignore: avoid-async-call-in-sync-function
    world.add(ClipComponent.rectangle(
      size: view.toVector2(),
      children: [_dragProjection],
    ));
    _arrowHead = BoulesArrowHead(
      origin: _startPosition,
      target: _target,
      referenceColor: TurnAware.currentPlayer.color,
    );
    // ignore: avoid-async-call-in-sync-function
    world.add(_arrowHead);
    _hint = CustomTextBoxComponent(
      "Trascina la freccia e poi lascia andare",
      _initialJackPosition + Vector2(0, BoulesJack.radius * 2),
      autoDismiss: true,
      scale: 1 / camera.viewfinder.zoom,
    );
    // ignore: avoid-async-call-in-sync-function
    world.add(_hint!);
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
      world.remove(dragged!);
      world.remove(_arrowHead);
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
