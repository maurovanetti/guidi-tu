// ignore_for_file: avoid-non-ascii-symbols

import 'dart:convert';

import 'package:flutter/material.dart';

import '/common/common.dart';
import '../title_screen.dart';

class ChallengeScoresScreen extends StatefulWidget {
  const ChallengeScoresScreen({
    super.key,
    required this.score,
    required this.sober,
  });

  final bool sober;
  final int score;

  @override
  ChallengeScoresScreenState createState() => ChallengeScoresScreenState();
}

class ChallengeScoresScreenState extends State<ChallengeScoresScreen>
    with Localized {
  static const bigStar = '⭐';

  final _scores = <bool, List<String>>{};

  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() {
      final soberScores = db.getStringList(Persistence.soberScoresKey);
      final drunkScores = db.getStringList(Persistence.drunkScoresKey);
      var challenger = db.getString(Persistence.challengerKey);
      if (challenger.isEmpty) {
        challenger = '???';
      }
      var scores = widget.sober ? soberScores : drunkScores;
      scores.insert(
        0,
        jsonEncode({
          'player': challenger,
          'score': widget.score,
          't': DateTime.now().toIso8601String(),
        }),
      );
      while (scores.length > 100) {
        String removed = scores.removeLast();
        debugPrint("Removed old score: $removed");
      }
      if (mounted) {
        setState(() {
          _scores[true] = soberScores;
          _scores[false] = drunkScores;
        });
      }
      if (widget.sober) {
        db.set(Persistence.soberScoresKey, soberScores);
      } else {
        db.set(Persistence.drunkScoresKey, drunkScores);
      }
    });
  }

  Widget? _handleScore(int index, {required bool sober}) {
    List<String> scores = _scores[sober] ?? [];
    if (index >= scores.length) {
      return null;
    }
    var scoreData = jsonDecode(scores[index]);
    if (scoreData
        case {
          'player': String name,
          'score': int score,
          't': String t,
        }) {
      DateTime timestamp = DateTime.parse(t);
      return ChallengeScore(
        sober: sober,
        name: name,
        score: score,
        timestamp: timestamp,
        $: $,
      );
    }
    debugPrint("Invalid score data: $scoreData");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    String stars = widget.score == 1 ? "stellina" : "stelline";
    String mark;
    switch (widget.score) {
      case 0:
        mark = "…";
        break;

      case 1:
      case 2:
      case 3:
        mark = ".";
        break;

      default:
        mark = "!";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punteggi'),
      ),
      body: _scores.isEmpty
          ? null
          : Padding(
              padding: StyleGuide.regularPadding,
              child: SqueezeOrScroll(
                squeeze: true,
                topChildren: [
                  FittedText(
                    "Hai raccolto ${widget.score} $stars$mark",
                    style: textTheme.headlineLarge,
                  ),
                  FittedText(
                    bigStar * widget.score,
                    style: textTheme.headlineLarge,
                  ),
                  FittedText(
                    "Confrontalo coi risultati precedenti.",
                    style: textTheme.headlineSmall,
                  ),
                  const Gap(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Senza bere:",
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      const Gap(),
                      Expanded(
                        child: Text(
                          "Bevendo:",
                          style: textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ],
                centralChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) =>
                            _handleScore(index, sober: true),
                      ),
                    ),
                    const Gap(),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) =>
                            _handleScore(index, sober: false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: CustomFloatingActionButton(
        tooltip: "Fine",
        icon: Icons.stop_rounded,
        onPressed: Navigation.replaceAll(context, () => const TitleScreen()).go,
      ),
    );
  }
}

class ChallengeScore extends StatelessWidget {
  const ChallengeScore({
    super.key,
    required this.sober,
    required this.name,
    required this.score,
    required this.timestamp,
    required this.$,
  });

  final bool sober;
  final String name;
  final int score;
  final DateTime timestamp;
  final AppLocalizations $;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    String starSymbol;
    switch (score) {
      case 0:
      case 1:
        starSymbol = '✦';
        break;

      case 2:
      case 3:
      case 4:
      case 5:
        starSymbol = '★';
        break;

      default:
        starSymbol = '✸';
        break;
    }
    return Container(
      margin: StyleGuide.separationMargin,
      decoration: BoxDecoration(
        color: Player.forChallenge(name, sober: sober).background,
        borderRadius: StyleGuide.borderRadius,
      ),
      child: Padding(
        padding: StyleGuide.narrowPadding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedText(
                    name.toUpperCase(),
                    style: textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: Text(
                    "$score $starSymbol",
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            FittedText(
              $.dateTime(timestamp),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
