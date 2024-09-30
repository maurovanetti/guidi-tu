import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/rps.dart';
import 'rps_board.dart';
import 'rps_item.dart';

class RockPaperScissorsModule extends FlameGame {
  late final RockPaperScissorsBoard board;
  final int gestureCount;
  final OnChangeReady onChangeReady;

  RockPaperScissorsSequence get currentSequence => board.sequence;

  RockPaperScissorsModule({
    required this.onChangeReady,
    required this.gestureCount,
  }) {
    assert(gestureCount > 1, "At least one gesture");
  }

  @override
  backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    double padding = size.x * 0.02;
    Rect grid = Rect.fromLTWH(
      padding,
      // Same padding for left and top is not a mistake.
      // ignore: no-equal-arguments
      padding,
      size.x - padding * 2,
      // Leave room for another line, but off-grid
      (size.y / 2) - padding,
    );
    // This only works if the GameWidget is never resized.
    board = RockPaperScissorsBoard(rect: grid, slots: gestureCount);
    await add(board);
    board.addListener(() {
      onChangeReady(ready: board.sequence.length >= gestureCount);
    });

    await add(RockPaperScissorsActiveItem(Rock(), board.cellAt(0, 0)));
    await add(RockPaperScissorsActiveItem(Paper(), board.cellAt(0, 1)));
    await add(RockPaperScissorsActiveItem(Scissors(), board.cellAt(0, 2)));
    await add(RockPaperScissorsActiveItem.backspace(board.cellAt(0, 3)));

    for (int i = 0; i < gestureCount; i++) {
      await add(RockPaperScissorsPassiveItem(board, i));
    }
  }
}
