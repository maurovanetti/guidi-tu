import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'player.dart';
import 'team_aware.dart';

mixin ScoreAware on TeamAware {
  Future<void> storeScore(Player player, Score score) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("points___${player.name}", score.points);
    await prefs.setDouble("time___${player.name}", score.time);
  }

  Future<Map<Player, Score>> retrieveScores() async {
    await retrieveTeam();
    var prefs = await SharedPreferences.getInstance();
    var scores = <Player, Score>{};
    for (var player in players) {
      var points = prefs.getDouble("points___${player.name}");
      var time = prefs.getDouble("time___${player.name}");
      scores[player] = Score(points: points!, time: time!);
      // TODO Handle exception
    }
    storeAwards(scores);
    return scores;
  }

  Future<void> storeAwards(Map<Player, Score> scores) async {
    var prefs = await SharedPreferences.getInstance();
    var sortedScores = scores.entries.toList().sort();
  }
}

class Score {
  final double points;
  final double time;

  Score({required this.points, required this.time});
}
