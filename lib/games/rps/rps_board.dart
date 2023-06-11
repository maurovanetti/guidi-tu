import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/rps.dart';
import '../flame/custom_board.dart';
import 'rps_item.dart';

class RockPaperScissorsBoard extends CustomBoard<RockPaperScissorsBoardCell>
    with CustomNotifier {
  final int slots;
  late final List<RockPaperScissorsPassiveItem?> _passiveItems;
  final RockPaperScissorsSequence _sequence =
      RockPaperScissorsSequence.empty(growable: true);
  RockPaperScissorsSequence get sequence => _sequence;

  @override
  Paint get paint => Paint()
    ..color = Colors.yellow.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  double get slotWidth => size.x / slots;
  double get slotHeight => cellHeight;
  Vector2 get slotSize => Vector2(slotWidth, slotHeight);

  RockPaperScissorsBoard({
    required super.rect,
    required this.slots,
  }) : super(gridColumns: 4, gridRows: 1) {
    _passiveItems = List.filled(slots, null);
  }

  @override
  RockPaperScissorsBoardCell createCell(int row, int column) =>
      RockPaperScissorsBoardCell(this, row, column);

  void registerSlotItem(int slot, RockPaperScissorsPassiveItem item) {
    assert(slot >= 0 && slot < slots);
    _passiveItems[slot] = item;
  }

  bool addGesture(RockPaperScissorsGesture gesture) {
    if (sequence.length >= slots) {
      return false;
    }
    sequence.add(gesture);
    _refreshSlots();
    return true;
  }

  bool removeGesture() {
    if (sequence.isNotEmpty) {
      var _ = sequence.removeLast();
      _refreshSlots();
      return true;
    }
    return false;
  }

  void _refreshSlots() {
    for (int slot = 0; slot < slots; slot++) {
      _passiveItems[slot]?.gesture =
          slot < sequence.length ? sequence[slot] : null;
    }
    notifyListeners();
  }
}

class RockPaperScissorsBoardCell extends CustomBoardCell {
  @override
  final RockPaperScissorsBoard board;

  RockPaperScissorsBoardCell(this.board, super.row, super.column);
}
