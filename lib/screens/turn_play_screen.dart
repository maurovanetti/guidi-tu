import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'completion_screen.dart';
import 'turn_instructions_screen.dart';

abstract class TurnPlayScreen extends GameSpecificStatefulWidget {
  bool get isReadyAtStart => true;

  const TurnPlayScreen({super.key, required super.gameFeatures});

  @override
  State createState();
}

// In most cases there's no need to subclass this, all specific logic can go in
// the GameAreaState and T. But there are some special cases like Stopwatch that
// modifies the time logic.
class TurnPlayState<T extends Move> extends GameSpecificState<TurnPlayScreen>
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

  void setReady(bool ready) {
    if (this.ready != ready) {
      debugPrint("Ready changed to $ready");
      setState(() {
        this.ready = ready;
      });
    }
  }

  void completeTurn(Duration duration) {
    // ignore: no-magic-number
    recordMove(receiveMove(), duration.inMicroseconds / 1000000);
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
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
        actions: [
          if (repeatable)
            IconButton(
              icon: const Icon(Icons.replay_rounded),
              onPressed: () {
                Navigation.replaceAll(context, widget.gameFeatures.playWidget)
                    .go();
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
              child: widget.gameFeatures.buildGameArea(
                startTime: _startTime,
                setReady: setReady,
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
