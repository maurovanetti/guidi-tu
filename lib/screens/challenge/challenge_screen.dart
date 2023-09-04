import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/games/steady_hand/steady_hand_module.dart';

import '/common/common.dart';

class ChallengeScreen extends StatefulWidget {
  final String name;
  final bool sober;

  const ChallengeScreen({
    Key? key,
    required this.name,
    required this.sober,
  }) : super(key: key);

  @override
  ChallengeScreenState createState() => ChallengeScreenState();
}

class ChallengeScreenState extends State<ChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sfida di abilità'),
      ),
      body: WithBubbles(
        n: widget.sober ? 0 : 5,
        child: Center(
          child: SqueezeOrScroll(
            squeeze: true,
            topChildren: [
              const Gap(),
              PlayerButtonStructure(
                Player(
                  widget.sober ? Player.soberPlayerId : Player.drunkPlayerId,
                  widget.name,
                  Gender.neuter,
                ),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.sober
                          ? const Icon(Icons.no_drinks_rounded, color: color)
                          : const Icon(Icons.local_bar_rounded, color: color),
                      const Gap(),
                      Text(widget.name),
                    ],
                  ),
                ),
              ),
              const Gap(),
            ],
            centralChild: Padding(
              padding: StyleGuide.regularPadding,
              child: AspectRatio(
                key: WidgetKeys.gameArea,
                aspectRatio: 1.0, // It's a square
                child: GameWidget(game: SteadyHandModule(notifyFallen: () {})),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
