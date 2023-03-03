import 'package:flutter/material.dart';

import '/common/squeeze_or_scroll.dart';
import '/common/clock.dart';
import '/common/move.dart';
import '/common/custom_button.dart';
import '/common/game_aware.dart';
import '/common/gap.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/style_guide.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';
import '/common/widget_keys.dart';
import '/games/turn_interstitial.dart';
import 'completion_screen.dart';

abstract class TurnPlay extends GameSpecificStatefulWidget {
  bool get isReadyAtStart => true;

  const TurnPlay({super.key, required super.gameFeatures});

  @override
  State createState();
}

// No need to subclass this, all specific logic is in the GameAreaState and T.
class TurnPlayState<T extends Move> extends GameSpecificState<TurnPlay>
    with Gendered, TeamAware, TurnAware<T>, MoveReceiver<T> {
  late bool ready;

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
          () => TurnInterstitial(gameFeatures: widget.gameFeatures),
        ).go();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
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
            Clock(_startTime, key: WidgetKeys.clock),
          ],
        ),
      ),
    );
  }
}
