import 'dart:ui';

import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/rps.dart';

class IncrementalRockPaperScissorsOutcome extends StatefulWidget {
  final List<IncrementalRockPaperScissorsScore> incrementalScores;

  const IncrementalRockPaperScissorsOutcome({
    super.key,
    required this.incrementalScores,
  });

  @override
  IncrementalRockPaperScissorsOutcomeState createState() =>
      IncrementalRockPaperScissorsOutcomeState();
}

// Very similar to the one for Ouija, can consider refactoring.
class IncrementalRockPaperScissorsOutcomeState
    extends State<IncrementalRockPaperScissorsOutcome> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () async {
      var gestureCount = widget.incrementalScores.first.gestures.length;
      for (int i = 0; i < gestureCount; i++) {
        await schedule([_resolve(i)], 1.0);
      }
    });
  }

  Future<void> schedule(Iterable<Future<void>> tasks, double seconds) async {
    if (!mounted) return;
    var _ = await Future.wait(tasks);
    if (!mounted) return;
    return Future.delayed(Duration(
      milliseconds: (Duration.millisecondsPerSecond * seconds).toInt(),
    ));
  }

  Future<void> _shortPause() async {
    // ignore: avoid-ignoring-return-values
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _resolve(int position) async {
    if (mounted) {
      for (var beingChecked in widget.incrementalScores) {
        var gesture = beingChecked.gestures[position];
        List<RockPaperScissorsGesture> others = [];
        for (var other in widget.incrementalScores) {
          if (beingChecked == other) continue;
          others.add(other.gestures[position].gesture);
        }
        setState(() {
          gesture.fightWith(others);
          if (gesture.type == RockPaperScissorsGestureOutcomeType.victory) {
            beingChecked.points++;
          }
        });
        await _shortPause();
      }
    }
  }

  get _tableStyle => Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontFeatures: [const FontFeature.tabularFigures()],
      );

  TableRow _buildTableRow(IncrementalRockPaperScissorsScore incrementalScore) {
    var heightFactor = 1.1;
    return TableRow(children: [
      Center(
        heightFactor: heightFactor,
        child: PlayerIcon.color(incrementalScore.player),
      ),
      ...incrementalScore.gestures.map((gesture) {
        return Center(
          child: Image(
            image: AssetImage('assets/images/${gesture.gesture.assetPath}'),
            width: StyleGuide.iconSize,
            color: gesture.colorByType,
          ),
        );
      }).toList(),
      Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minWidth: 100.0),
        child: Text(
          incrementalScore.points.toString(),
          style: _tableStyle,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SqueezeOrScroll(
        squeeze: false,
        topChildren: const [],
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
          Center(child: Text("1 pt. per giocata vincente.")),
          Center(child: Text("0 pt. per pareggio o stallo.")),
        ],
      ),
    );
  }
}

class IncrementalRockPaperScissorsScore {
  late final Player player;
  late final List<RockPaperScissorsGestureOutcome> gestures;
  late int points;

  IncrementalRockPaperScissorsScore({
    required RecordedMove<RockPaperScissorsMove> recordedMove,
  }) {
    player = recordedMove.player;
    gestures = recordedMove.move.sequence.map((gesture) {
      return RockPaperScissorsGestureOutcome(gesture);
    }).toList();
    points = 0;
  }
}

enum RockPaperScissorsGestureOutcomeType {
  pending,
  tie,
  standoff,
  victory,
  defeat,
}

class RockPaperScissorsGestureOutcome {
  final RockPaperScissorsGesture gesture;
  RockPaperScissorsGestureOutcomeType type;

  Color? get colorByType {
    switch (type) {
      case RockPaperScissorsGestureOutcomeType.pending:
        return Colors.grey.shade500;
      case RockPaperScissorsGestureOutcomeType.tie:
        return Colors.grey.shade400;
      case RockPaperScissorsGestureOutcomeType.standoff:
        return Colors.orange.shade200;
      case RockPaperScissorsGestureOutcomeType.victory:
        return Colors.green.shade300;
      case RockPaperScissorsGestureOutcomeType.defeat:
        return Colors.red.shade800;
    }
  }

  bool get isThickByType {
    switch (type) {
      case RockPaperScissorsGestureOutcomeType.pending:
      case RockPaperScissorsGestureOutcomeType.tie:
      case RockPaperScissorsGestureOutcomeType.standoff:
      case RockPaperScissorsGestureOutcomeType.defeat:
        return false;
      case RockPaperScissorsGestureOutcomeType.victory:
        return true;
    }
  }

  RockPaperScissorsGestureOutcome(
    this.gesture, [
    this.type = RockPaperScissorsGestureOutcomeType.pending,
  ]);

  void fightWith(RockPaperScissorsSequence others) {
    if (gesture.winsOver(others)) {
      type = RockPaperScissorsGestureOutcomeType.victory;
    } else if (gesture.losesTo(others)) {
      type = RockPaperScissorsGestureOutcomeType.defeat;
    } else if (gesture.standsOffWith(others)) {
      type = RockPaperScissorsGestureOutcomeType.standoff;
    } else {
      type = RockPaperScissorsGestureOutcomeType.tie;
    }
  }
}
