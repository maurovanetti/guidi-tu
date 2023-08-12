import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import '/common/common.dart';
import 'boules_replay.dart';

class FinalBoulesOutcome extends StatelessWidget {
  const FinalBoulesOutcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SqueezeOrScroll(
        squeeze: false,
        centralChild: Padding(
          padding: StyleGuide.regularPadding,
          child: AspectRatio(
            aspectRatio: 1.0, // It's a square
            child: GameWidget(game: BoulesReplay()),
          ),
        ),
        bottomChildren: const [
          Text(
            "Contano solo le bocce migliori di ogni partecipante",
          ),
        ],
      ),
    );
  }
}
