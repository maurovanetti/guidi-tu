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
  late final ClipComponent _dragProjection;
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
  void onLoad() {
    world.gravity = Vector2.zero();
    camera.viewfinder.anchor = Anchor.topLeft;
    debugPrint("camera.viewport.size: ${camera.viewport.size}");
    debugPrint("camera.visibleWorldRect: ${camera.visibleWorldRect}");
    debugPrint("camera.viewport.position: ${camera.viewport.position}");
    final topLeft = view.topLeft.toVector2();
    final topRight = view.topRight.toVector2();
    final bottomLeft = view.bottomLeft.toVector2();
    final bottomRight = view.bottomRight.toVector2();
    // ignore: avoid-async-call-in-sync-function
    world.add(BoulesWall(topLeft, topRight));
    // ignore: avoid-async-call-in-sync-function
    world.add(BoulesWall(topRight, bottomRight));
    // ignore: avoid-async-call-in-sync-function
    world.add(BoulesWall(bottomRight, bottomLeft));
    // ignore: avoid-async-call-in-sync-function
    world.add(BoulesWall(bottomLeft, topLeft));
    _bowls = retrieveBowls();
    init();
    for (var bowl in _bowls) {
      // ignore: avoid-async-call-in-sync-function
      world.add(bowl);
      bowl.addListener(_onBowlChangedState);
    }
  }

  List<BoulesBowl> retrieveBowls() {
    List<BoulesBowl> bowls = [];
    var sessionData = TeamAware.retrieveSessionData();
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
    final wholeDragProjection = BoulesDragProjection(
      origin: _startPosition,
      target: _target,
    );
    _dragProjection = ClipComponent.rectangle(
      size: view.toVector2(),
      children: [wholeDragProjection],
      priority: -100,
    );
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
  bool containsLocalPoint(Vector2 point) {
    return (screenToWorld(point).y > _startPosition.y)
        ? false
        : super.containsLocalPoint(point);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _projectDrag(false);
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _projectDrag(false);
    super.onDragCancel(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_hint?.isRemoved ?? true) {
      _projectDrag(true);
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

  void _projectDrag(bool visible) {
    if (visible) {
      // ignore: avoid-async-call-in-sync-function
      world.add(_dragProjection);
    } else if (world.children.contains(_dragProjection)) {
      world.remove(_dragProjection);
    }
  }

  void _onBowlChangedState() {
    if (_beholdTheOutcome && _bowls.every((bowl) => bowl.sleeping)) {
      TeamAware.storeSessionData({
        boulesSetupKey: _bowls.map((bowl) => bowl.toJson()).toList(),
      });
      setReady(ready: true);
    }
  }
}
