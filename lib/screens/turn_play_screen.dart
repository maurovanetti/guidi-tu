import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'completion_screen.dart';
import 'turn_instructions_screen.dart';

abstract class TurnPlayScreen extends GameSpecificStatefulWidget {
  bool get isReadyAtStart => true;

  Color? get backgroundColor => null;

  const TurnPlayScreen({super.key, required super.gameFeatures});

  @override
  State createState();
}

// In most cases there's no need to subclass this, all specific logic can go in
// the GameAreaState and T. But there are some special cases like Stopwatch that
// modifies the time logic.
class TurnPlayState<T extends Move> extends ForwardOnlyState<TurnPlayScreen>
    with Gendered, TeamAware, TurnAware<T>, MoveReceiver<T> {
  late bool ready;
  bool repeatable = kDebugMode;

  late DateTime _startTime;

  Duration get elapsed => DateTime.now().difference(_startTime);

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    ready = widget.isReadyAtStart;
  }

  // ignore: avoid-shadowing
  void setReady({bool ready = false}) {
    if (this.ready != ready) {
      debugPrint("Ready changed to $ready");
      setState(() {
        this.ready = ready;
      });
    }
  }

  void completeTurn(Duration duration) {
    final moveUpdates = receiveMoves();
    for (var entry in moveUpdates.updatedOldMoves.entries) {
      updateOldMoves(entry.key, entry.value);
    }
    recordMove(
      moveUpdates.newMove,
      duration.inMicroseconds / Duration.microsecondsPerSecond,
    );
    var hasEveryonePlayed = !nextTurn();
    if (mounted) {
      if (hasEveryonePlayed) {
        Navigation.replaceLast(
          context,
          () => CompletionScreen(
            gameFeatures: widget.gameFeatures,
          ),
        ).go();
      } else {
        Navigation.replaceLast(
          context,
          () => TurnInstructionsScreen(gameFeatures: widget.gameFeatures),
        ).go();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
        actions: [
          if (repeatable)
            IconButton(
              icon: const Icon(Icons.replay_rounded),
              onPressed: () {
                Navigation.replaceAll(
                  context,
                  widget.gameFeatures.onBuildTurnPlayScreen,
                ).go();
              },
            ),
        ],
      ),
      body: Center(
        child: SqueezeOrScroll(
          squeeze: widget.gameFeatures.usesRigidGameArea,
          topChildren: [
            PlayerTag(TurnAware.currentPlayer),
            const Gap(),
          ],
          centralChild: Padding(
            padding: StyleGuide.regularPadding,
            child: AspectRatio(
              key: WidgetKeys.gameArea,
              aspectRatio: 1.0, // It's a square
              child: widget.gameFeatures.onBuildGameArea(
                startTime: _startTime,
                onChangeReady: setReady,
                moveReceiver: this,
              ),
            ),
          ),
          bottomChildren: [
            const Gap(),
            CustomButton(
              key: WidgetKeys.toNextTurn,
              text: "Ho finito!",
              onPressed: ready
                  ? () {
                      completeTurn(elapsed);
                    }
                  : null,
            ),
            if (widget.gameFeatures.externalClock)
              Clock(_startTime, key: WidgetKeys.clock),
          ],
        ),
      ),
    );
  }
}
