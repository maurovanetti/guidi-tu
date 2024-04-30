import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import '/common/common.dart';
import 'boules_replay.dart';

class FinalBoulesOutcome extends StatelessWidget {
  const FinalBoulesOutcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SqueezeOrScroll(
        centralChild: Padding(
          padding: StyleGuide.regularPadding,
          child: AspectRatio(
            aspectRatio: 1.0, // It's a square
            child: GameWidget.controlled(gameFactory: BoulesReplay.new),
          ),
        ),
        bottomChildren: [
          Text(
            "Contano solo le bocce migliori di ogni partecipante",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
