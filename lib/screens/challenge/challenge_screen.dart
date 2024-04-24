// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/steady_hand/challenge_module.dart';
import 'challenge_scores_screen.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    super.key,
    required this.name,
    required this.sober,
  });

  final String name;
  final bool sober;

  @override
  ChallengeScreenState createState() => ChallengeScreenState();
}

class ChallengeScreenState extends State<ChallengeScreen> {
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    // This is a workaround to avoid rendering the maze before the GameWidget is
    // resized at its final size.
    unawaited(Delay.waitFor(1, () {
      setState(() {
        _gameModule = ChallengeModule(notifyFallen: _handleFallen);
      });
    }));
  }

  void _handleFallen() {
    setState(() {
      _ended = true;
    });
  }

  void _displayScores() {
    Navigation.replaceLast(
      context,
      () => ChallengeScoresScreen(
        score: _gameModule?.score ?? 0,
        sober: widget.sober,
      ),
    ).go();
  }

  ChallengeModule? _gameModule;

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
                Player.forChallenge(widget.name, sober: widget.sober),
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
                child: _gameModule == null
                    ? const Center(child: CircularProgressIndicator())
                    : GameWidget(game: _gameModule!),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _ended
          ? CustomFloatingActionButton(
              key: WidgetKeys.toChallengeScores,
              // ignore: prefer-correct-handler-name
              onPressed: _displayScores,
              icon: Icons.stop_rounded,
            )
          : null,
    );
  }
}
