import 'dart:async';

import 'package:flutter/material.dart';

import '/common/game_features.dart';
import '/games/turn_play.dart';
import '../common/fitted_text.dart';

class LargeShot extends TurnPlay {
  @override
  GameFeatures get gameFeatures => largeShot;

  const LargeShot({super.key});

  @override
  createState() => LargeShotState();
}

class LargeShotState extends TurnPlayState {
  Timer? _longPressTimer;

  int n = 0;
  _changeN(int delta) => setState(() => n += delta);

  @override
  int get points => n;

  void _longPressStart(int delta) {
    _longPressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _changeN(delta);
    });
  }

  _longPressEnd() {
    _longPressTimer?.cancel();
  }

  @override
  buildGameArea() {
    var primaryColor = Theme.of(context).colorScheme.primary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ArrowButton(
            icon: Icons.keyboard_arrow_up_rounded,
            delta: 1,
            color: primaryColor,
            changeN: _changeN,
            quickChangeNStart: _longPressStart,
            quickChangeNEnd: _longPressEnd,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: ContinuousRectangleBorder(
                side: BorderSide(color: primaryColor, width: 5),
              ),
            ),
            onPressed: () {
              setState(() => n = 0);
            },
            child: FittedText(n.toString(),
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ),
          ArrowButton(
            icon: Icons.keyboard_arrow_down_rounded,
            delta: -1,
            color: primaryColor,
            changeN: _changeN,
            quickChangeNStart: _longPressStart,
            quickChangeNEnd: _longPressEnd,
          ),
        ],
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

  const ArrowButton(
      {super.key,
      required this.icon,
      required this.delta,
      required this.color,
      required this.changeN,
      required this.quickChangeNStart,
      required this.quickChangeNEnd});

  @override
  build(context) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(icon, color: color, size: 100),
        onPressed: () => changeN(delta),
      ),
      onLongPress: () => quickChangeNStart(delta),
      onLongPressUp: () => quickChangeNEnd(),
    );
  }
}
