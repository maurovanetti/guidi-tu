import 'dart:ui';

import 'package:flame/game.dart';

import 'ouija_board.dart';

class OuijaModule extends FlameGame {
  static const gridColumns = 6;
  static const gridRows = 5;

  late final OuijaBoard board;
  late final int letterCount;

  String currentWord = '';

  final void Function(bool) setReady;

  OuijaModule({
    required this.setReady,
    required this.letterCount,
  }) {
    assert(letterCount > 1, "At least one letter");
  }

  @override
  Future<void> onLoad() async {
    double padding = size.x * 0.02;
    // Same padding for left and top is not a mistake.
    // ignore: no-equal-arguments
    Rect grid = Rect.fromLTRB(padding, padding, padding, padding);
    // This only works if the GameWidget is never resized.
    board = OuijaBoard(
      rect: grid,
      gridColumns: gridColumns,
      gridRows: gridRows,
    );
    await add(board);
  }
}
