import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guidi_tu/common/turn_aware.dart';

import '/common/fitted_text.dart';
import '/common/snackbar.dart';
import '/games/turn_play.dart';

class ShotState<T extends ShotMove> extends TurnPlayState<ShotMove>
    with QuickMessage {
  Timer? _longPressTimer;

  int n = 0;
  changeN(int delta) => setState(() => n += delta);

  void longPressStart(int delta) {
    _longPressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      changeN(delta);
    });
  }

  void longPressEnd() {
    _longPressTimer?.cancel();
  }

  ArrowButton buildUpArrowButton() => ArrowButton(
        icon: Icons.keyboard_arrow_up_rounded,
        delta: 1,
        color: Theme.of(context).colorScheme.primary,
        changeN: changeN,
        quickChangeNStart: longPressStart,
        quickChangeNEnd: longPressEnd,
      );

  ArrowButton buildDownArrowButton() => ArrowButton(
        icon: Icons.keyboard_arrow_down_rounded,
        delta: -1,
        color: Theme.of(context).colorScheme.primary,
        changeN: changeN,
        quickChangeNStart: longPressStart,
        quickChangeNEnd: longPressEnd,
      );

  ElevatedButton buildNumberDisplay() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 5),
          ),
        ),
        onLongPress: () {
          setState(() => n = 0);
        },
        onPressed: () {
          showQuickMessage("Tieni premuto per azzerare", context: context);
        },
        child: FittedText(n.toString(),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
      );

  List<Widget> buildNumberControls() => [
        buildUpArrowButton(),
        buildNumberDisplay(),
        buildDownArrowButton(),
      ];

  @override
  ShotMove get lastMove => ShotMove(time: elapsedSeconds, n: n);

  @override
  buildGameArea() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buildNumberControls(),
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final int delta;
  final Color color;
  final void Function(int) changeN;
  final void Function(int) quickChangeNStart;
  final void Function() quickChangeNEnd;
  final bool enabled;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.delta,
    required this.color,
    required this.changeN,
    required this.quickChangeNStart,
    required this.quickChangeNEnd,
    this.enabled = true,
  });

  @override
  build(context) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(icon,
            color: enabled ? color : color.withOpacity(0.1), size: 100),
        onPressed: enabled ? () => changeN(delta) : null,
      ),
      onLongPress: () => quickChangeNStart(delta),
      onLongPressUp: () => quickChangeNEnd(),
    );
  }
}

class ShotMove extends Move {
  final int n;

  ShotMove({required this.n, required super.time});

  @override
  int getPointsWith(Iterable<Move> allMoves) => n;
}
