import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/ouija.dart';

class IncrementalOuijaOutcome extends StatefulWidget {
  const IncrementalOuijaOutcome({
    super.key,
    required this.incrementalScores,
  });

  final List<IncrementalOuijaScore> incrementalScores;

  @override
  IncrementalOuijaOutcomeState createState() => IncrementalOuijaOutcomeState();
}

class IncrementalOuijaOutcomeState extends State<IncrementalOuijaOutcome> {
  @override
  initState() {
    super.initState();
    Delay.after(1, () async {
      int letterCount =
          widget.incrementalScores.firstOrNull?.letters.length ?? 0;
      for (int i = 0; i < letterCount; i++) {
        await _schedule([_resolve(i)], 1.0);
      }
    });
  }

  Future<void> _schedule(Iterable<Future<void>> tasks, double seconds) async {
    if (!mounted) return;
    var _ = await Future.wait(tasks);
    if (!mounted) return;
    return Delay.waitFor(seconds);
  }

  Future<void> _shortPause() async {
    await Delay.waitFor(1 / 2);
  }

  Future<void> _resolve(int position) async {
    if (mounted) {
      for (var beingChecked in widget.incrementalScores) {
        var letter = beingChecked.letters[position];
        letter.type = OuijaGuessType.none;
        for (var other in widget.incrementalScores) {
          if (beingChecked == other) continue;
          var positionInOther = other.positionOf(letter);
          if (positionInOther == position) {
            letter.type = OuijaGuessType.guess;
            break;
          }
          if (positionInOther != -1) {
            letter.type = OuijaGuessType.miss;
            continue;
          }
        }
        switch (letter.type) {
          case OuijaGuessType.guess:
            beingChecked.pointsForGuesses += Ouija.guessValue;
            break;

          case OuijaGuessType.miss:
            beingChecked.pointsForMisses += Ouija.missValue;
            break;

          case OuijaGuessType.pending:
          case OuijaGuessType.none:
            break;
        }
        // ignore: avoid-empty-setstate
        setState(() {});
        await _shortPause();
      }
    }
  }

  get _tableStyle => Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFeatures: [const FontFeature.tabularFigures()],
      );

  TableRow _buildTableRow(IncrementalOuijaScore incrementalScore) {
    const heightFactor = 1.1;
    final pointsForGuesses = incrementalScore.pointsForGuesses;
    final pointsForMisses = incrementalScore.pointsForMisses;
    const rowCells = <Widget>[];
    rowCells.add(Center(
      heightFactor: heightFactor,
      child: PlayerIcon.color(incrementalScore.player),
    ));
    for (var ouijaGuess in incrementalScore.letters) {
      rowCells.add(Center(
        child: Text(
          ouijaGuess.letter,
          style: _tableStyle.copyWith(
            color: ouijaGuess.colorByType,
            fontWeight: ouijaGuess.weightByType,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
    rowCells.add(Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(minWidth: 100.0),
      child: Text(
        "$pointsForGuesses + $pointsForMisses",
        style: _tableStyle,
      ),
    ));
    return const TableRow(children: rowCells);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SqueezeOrScroll(
        centralChild: Padding(
          padding: StyleGuide.regularPadding,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border:
                TableBorder.all(color: Theme.of(context).colorScheme.primary),
            children: widget.incrementalScores.map(_buildTableRow).toList(),
          ),
        ),
        bottomChildren: const [
          Center(
            child: Text("${Ouija.guessValue} pt. per lettera indovinata."),
          ),
          Center(
            child:
                Text("${Ouija.missValue} pt. per lettera nel posto sbagliato."),
          ),
        ],
      ),
    );
  }
}

class IncrementalOuijaScore {
  late final Player player;
  late final List<OuijaGuess> letters;
  late int pointsForGuesses;
  late int pointsForMisses;

  IncrementalOuijaScore({required RecordedMove<OuijaMove> recordedMove}) {
    player = recordedMove.player;
    letters = recordedMove.move.word.characters.map((letter) {
      return OuijaGuess(letter);
    }).toList();
    pointsForGuesses = 0;
    pointsForMisses = 0;
  }

  int positionOf(OuijaGuess guess) {
    for (int i = 0; i < letters.length; i++) {
      if (letters[i].letter == guess.letter) return i;
    }
    return -1;
  }
}

enum OuijaGuessType {
  pending,
  none,
  miss,
  guess,
}

class OuijaGuess {
  final String letter;
  OuijaGuessType type;

  Color? get colorByType {
    switch (type) {
      case OuijaGuessType.pending:
        return null;

      case OuijaGuessType.none:
        return Colors.red.shade800;

      case OuijaGuessType.miss:
        return Colors.orange.shade200;

      case OuijaGuessType.guess:
        return Colors.green.shade300;
    }
  }

  FontWeight get weightByType {
    switch (type) {
      case OuijaGuessType.pending:
      case OuijaGuessType.none:
        return FontWeight.normal;

      case OuijaGuessType.miss:
      case OuijaGuessType.guess:
        return FontWeight.bold;
    }
  }

  OuijaGuess(this.letter, [this.type = OuijaGuessType.pending]);
}
