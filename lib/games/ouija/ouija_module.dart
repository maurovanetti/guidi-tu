import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'ouija_board.dart';
import 'ouija_frame.dart';
import 'ouija_item.dart';

class OuijaModule extends FlameGame {
  static const gridColumns = 6;
  static const gridRows = 4;
  static const essentialAlphabet = 'ABCDEFGHILMNOPQRSTUVZ';
  static const extraAlphabet = 'JKWXY';
  static const ouijaAlphabetKey = 'ouijaAlphabet';

  late final OuijaBoard board;
  late final int letterCount;
  final void Function(bool) setReady;

  String get currentWord => board.word;
  int get capacity => gridColumns * gridRows - 1; // -1 for the backspace

  OuijaModule({
    required this.setReady,
    required this.letterCount,
  }) {
    assert(letterCount > 1, "At least one letter");
    assert(essentialAlphabet.length < capacity,
        "There's only room for $capacity letters");
  }

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
      (size.y - padding * 2) * (gridRows / (gridRows + 1)),
    );
    // This only works if the GameWidget is never resized.
    board = OuijaBoard(
      rect: grid,
      gridColumns: gridColumns,
      gridRows: gridRows,
      slots: letterCount,
    );
    await add(board);
    board.wordNotifier.addListener(() {
      setReady(board.word.length >= letterCount);
    });

    String alphabet;
    var sessionData = await TeamAware.retrieveSessionData();
    if (sessionData.containsKey(ouijaAlphabetKey)) {
      alphabet = sessionData[ouijaAlphabetKey];
    } else {
      List<String> letters = 'ABCDEFGHILMNOPQRSTUVZ'.split('');
      List<String> extraLetters = 'JKWXY'.split('')..shuffle();
      for (int i = 0; essentialAlphabet.length + i < capacity; i++) {
        letters.add(extraLetters[i]);
      }
      letters.shuffle();
      alphabet = letters.join();
      TeamAware.storeSessionData({ouijaAlphabetKey: alphabet});
    }
    String alphabetEtc = alphabet + OuijaActiveItem.backspace;
    for (int i = 0; i < alphabetEtc.length; i++) {
      int row = i ~/ gridColumns;
      int column = i % gridColumns;
      await add(OuijaActiveItem(alphabetEtc[i], board.cellAt(row, column)));
    }

    for (int i = 0; i < letterCount; i++) {
      await add(OuijaPassiveItem(board, i));
    }

    await add(OuijaFrame(board, size: board.cellSize));
  }
}
