import 'package:flutter/material.dart';

import '/common/common.dart';
import 'placement_screen.dart';

abstract class OutcomeScreen extends GameSpecificStatefulWidget {
  const OutcomeScreen({super.key, required super.gameFeatures});

  @override
  OutcomeScreenState createState();
}

abstract class OutcomeScreenState<T extends Move>
    extends ForwardOnlyState<OutcomeScreen>
    with Gendered, TeamAware, ScoreAware, TurnAware<T> {
  late final Widget outcomeWidget;
  bool repeatable = false;

  void _handleRevealPlacement() {
    for (var player in players) {
      var score = Score(
        points: getPoints(player),
        time: getTime(player),
        lessIsMore: widget.gameFeatures.lessIsMore,
        longerIsBetter: widget.gameFeatures.longerIsBetter,
        pointsMatter: widget.gameFeatures.pointsMatter,
        timeDisplayed: widget.gameFeatures.externalClock,
        onFormatPoints: widget.gameFeatures.onFormatPoints,
      );
      ScoreAware.recordScore(player, score);
      debugPrint("${player.name} scored ${ScoreAware.scores[player] ?? 'N/A'} "
          "at ${widget.gameFeatures.name}");
    }
    if (mounted) {
      Navigation.replaceAll(context, () => const PlacementScreen()).go();
    }
  }

  @override
  void didChangeDependencies() {
    initOutcome();
    super.didChangeDependencies();
  }

  // Override this to tailor the outcome screen
  void initOutcome() {
    debugPrint("Please implement initOutcome() in $runtimeType");
    // Just a placeholder
    outcomeWidget = Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          widget.gameFeatures.name($),
          // ignore: no-magic-number
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (repeatable)
            IconButton(
              icon: const Icon(Icons.replay_rounded),
              onPressed: () {
                Navigation.replaceLast(
                  context,
                  widget.gameFeatures.onBuildOutcomeScreen,
                ).go();
              },
            ),
        ],
        title: Text($.outcome),
      ),
      body: outcomeWidget,
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toPlacement,
        tooltip: $.ranking,
        icon: Icons.skip_next_rounded,
        onPressed: _handleRevealPlacement,
      ),
    );
  }
}
