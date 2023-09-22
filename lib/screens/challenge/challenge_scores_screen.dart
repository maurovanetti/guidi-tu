// ignore_for_file: avoid-non-ascii-symbols

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ChallengeScoresScreenState extends State<ChallengeScoresScreen> {
  static const bigStar = '⭐';

  final _scores = <bool, List<String>>{};
  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() async {
      final prefs = await SharedPreferences.getInstance();
      final soberScores = prefs.getStringList(Persistence.soberScoresKey) ?? [];
      final drunkScores = prefs.getStringList(Persistence.drunkScoresKey) ?? [];
      var scores = widget.sober ? soberScores : drunkScores;
      scores.insert(
        0,
        jsonEncode({
          'player': prefs.getString(Persistence.challengerKey) ?? '???',
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
      bool stored = widget.sober
          ? await prefs.setStringList(Persistence.soberScoresKey, soberScores)
          : await prefs.setStringList(Persistence.drunkScoresKey, drunkScores);
      if (!stored) {
        debugPrint("Failed to store new challenge score");
      }
    });
  }

  Widget? _scoreBuilder(int index, {required bool sober}) {
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
                    textAlign: TextAlign.center,
                  ),
                  FittedText(
                    bigStar * widget.score,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  FittedText(
                    "Confrontalo coi risultati precedenti.",
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
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
                            _scoreBuilder(index, sober: true),
                      ),
                    ),
                    const Gap(),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) =>
                            _scoreBuilder(index, sober: false),
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
  });

  final bool sober;
  final String name;
  final int score;
  final DateTime timestamp;

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
              I18n.dateTimeFormat.format(timestamp),
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
