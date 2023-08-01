import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/games/flame/custom_text_box_component.dart';
import 'battleship_board.dart';
import 'battleship_bomb.dart';
import 'battleship_ship.dart';

export 'battleship_item.dart';

class BattleshipModule extends FlameGame {
  static const gridColumns = 5;
  static const gridRows = 5;

  late final BattleshipBoard board;
  final int shipCount;
  final int bombCount;

  final void Function(bool ready) setReady;

  BattleshipModule({
    required this.setReady,
    this.shipCount = 3,
    this.bombCount = 5,
  }) {
    assert(bombCount <= 5, "Too many bombs");
    assert(shipCount <= gridRows + 3, "Too many ships");
    assert(shipCount <= gridColumns + 3, "Too many ships");
  }

  @override
  Color backgroundColor() => Colors.blue.shade900;

  @override
  // ignore: avoid-long-functions
  Future<void> onLoad() async {
    double padding = size.x * 0.02;
    // Same padding for left and top is not a mistake.
    // ignore: no-equal-arguments
    Rect grid = Rect.fromLTWH(padding, padding, size.x * 0.75, size.y * 0.75);
    // This only works if the GameWidget is never resized.
    board = BattleshipBoard(
      rect: grid,
      gridColumns: gridColumns,
      gridRows: gridRows,
    );
    await add(board);

    // A hint to place ships is displayed.
    var rightwardOneCell = Vector2(1, 0) * board.cellWidth;
    var downwardOneCell = Vector2(0, 1) * board.cellHeight;
    var shipsHint = CustomTextBoxComponent(
      "Trascina i galleggianti nelle caselle",
      rightwardOneCell + downwardOneCell,
    );
    await add(shipsHint);

    var bottomRightCorner = Vector2(
      size.x - padding - board.cellWidth / 2,
      size.y - padding - board.cellHeight / 2,
    );
    var bottomLeftCorner = Vector2(
      padding + board.cellWidth / 2,
      size.y - padding - board.cellHeight / 2,
    );
    var topRightCorner = Vector2(
      size.x - padding - board.cellWidth / 2,
      padding + board.cellHeight / 2,
    );
    // The ships are placed near the board.
    var smallShip = BattleshipShip(
      bottomRightCorner,
      cellSpan: 1,
      isVertical: false,
      board: board,
    );
    var mediumShip = BattleshipShip(
      topRightCorner,
      cellSpan: 2,
      isVertical: true,
      board: board,
    );
    var largeShip = BattleshipShip(
      bottomLeftCorner,
      cellSpan: 3,
      isVertical: false,
      board: board,
    );
    var rightOfLargeShip = largeShip.position + rightwardOneCell * 3;
    var belowMediumShip = mediumShip.position + downwardOneCell * 2;
    List<BattleshipShip> extra = [];
    var extraPositions = [
      belowMediumShip + downwardOneCell,
      rightOfLargeShip,
      belowMediumShip,
      rightOfLargeShip + rightwardOneCell,
      belowMediumShip + downwardOneCell * 2,
    ];
    for (int i = 0; i + 3 < shipCount; i++) {
      var extraShip = BattleshipShip(
        extraPositions[i],
        cellSpan: 1,
        isVertical: false,
        board: board,
      );
      extra.add(extraShip);
    }
    for (var ship in [smallShip, mediumShip, largeShip, ...extra]) {
      await add(ship);
    }

    // Callback used every time a ship is placed.
    void onPlaceShip() {
      if (board.isFull) {
        // The bombs are placed near the board.
        board.clearListeners();
        var bombPositions = [
          bottomRightCorner,
          bottomRightCorner - downwardOneCell,
          bottomRightCorner - rightwardOneCell,
          bottomRightCorner - downwardOneCell * 2,
          bottomRightCorner - rightwardOneCell * 2,
          bottomRightCorner - downwardOneCell * 3,
          bottomRightCorner - rightwardOneCell * 3,
          bottomRightCorner - downwardOneCell * 4,
          bottomRightCorner - rightwardOneCell * 4,
        ];
        for (int i = 0; i < bombCount; i++) {
          var bomb = BattleshipBomb(
            bombPositions[i],
            board: board,
          );
          add(bomb);
        }
        // A hint to place bombs is displayed.
        var bombsHint = CustomTextBoxComponent(
          "E ora decidi dove colpire",
          rightwardOneCell + downwardOneCell,
        );
        add(bombsHint);

        board.addListener(() {
          if (!board.isEmpty) {
            bombsHint.dismiss();
          }
          setReady(board.isFull);
        });
      } else if (!board.isEmpty) {
        // After the first ship is placed, the first hint is removed.
        shipsHint.dismiss();
      }
    }

    board.addListener(onPlaceShip);
  }
}
