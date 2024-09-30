import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import '/common/common.dart';
import 'boules_replay.dart';

class FinalBoulesOutcome extends StatelessWidget {
  const FinalBoulesOutcome({super.key});

  @override
  Widget build(BuildContext context) {
    final $ = get$(context);
    final replay = BoulesReplay($: (
      dragAndRelease: $.dragAndRelease,
      waitForBoules: $.waitForBoules,
    ));
    return Center(
      child: SqueezeOrScroll(
        centralChild: Padding(
          padding: StyleGuide.regularPadding,
          child: AspectRatio(
            aspectRatio: 1.0, // It's a square
            child: GameWidget(game: replay),
          ),
        ),
        bottomChildren: [
          Text(
            $.onlyOneBowlCounts,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
