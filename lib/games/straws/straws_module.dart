import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'straws_straw.dart';

class StrawsModule extends FlameGame {
  static const strawsCount = 25;
  static const minStrawLengthRatio = 0.4; // as fraction of game area width
  static const strawsSetupKey = "strawsSetup";

  final OnChangeReady onChangeReady;

  late final List<StrawsStraw> _straws;
  int _pickedStrawIndex = 0;

  StrawsStraw get pickedStraw => _straws[_pickedStrawIndex];

  StrawsModule({required this.onChangeReady});

  @override
  backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    var sprite = await loadSprite('straws/straw.png');
    _straws = retrieveStraws(sprite: sprite);
    for (var straw in _straws) {
      add(straw);
    }
    init();
  }

  List<StrawsStraw> retrieveStraws({required Sprite sprite}) {
    List<StrawsStraw> straws = [];
    var sessionData = TeamAware.retrieveSessionData();
    if (sessionData.containsKey(strawsSetupKey)) {
      debugPrint("Loading straws from session data");
      var strawsSetup = sessionData[strawsSetupKey];
      for (var strawSetup in strawsSetup) {
        var straw = StrawsStraw.fromJson(strawSetup, sprite);
        straws.add(straw);
      }
    } else {
      List<Map<String, dynamic>> strawsSetup = [];
      for (int i = 0; i < strawsCount; i++) {
        var straw = _randomStraw(
          minLength: size.x * minStrawLengthRatio,
          sprite: sprite,
        );
        straws.add(straw);
        strawsSetup.add(straw.toJson());
      }
      TeamAware.storeSessionData({strawsSetupKey: strawsSetup});
    }
    return straws;
  }

  void init() {
    pick(_straws.first);
  }

  void pick([StrawsStraw? straw]) {
    assert(_straws.isNotEmpty, "No straws to pick from");
    pickedStraw.isPicked = false;
    _pickedStrawIndex = straw == null
        ? (_pickedStrawIndex + 1) % _straws.length
        : _straws.indexOf(straw);
    pickedStraw.isPicked = true;
  }

  StrawsStraw _randomStraw({
    required double minLength,
    required Sprite sprite,
  }) {
    var from = _randomPositionInRect(size, 0.9);
    var to = _randomPositionInRect(size, 0.9);
    var delta = to - from;
    // Truncated to an integer number of pixels
    var length = delta.length.toInt();
    if (length < minLength) {
      return _randomStraw(minLength: minLength, sprite: sprite);
    }
    // The minus sign compensates for the different reference system
    var angle = -delta.angleToSigned(Vector2(1, 0));
    return StrawsStraw(from, angle: angle, length: length, sprite: sprite);
  }

  static Vector2 _randomPositionInRect(Vector2 size, double safeArea) {
    var offset = (1.0 - safeArea) / 2;
    safeRandom() => offset + safeArea * Random().nextDouble();
    return Vector2(
      // ignore: prefer-moving-to-variable
      size.x * safeRandom(),
      // ignore: prefer-moving-to-variable
      size.y * safeRandom(),
    );
  }
}
