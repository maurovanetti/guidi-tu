import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'player.dart';
import 'team_aware.dart';

const String payerKey = 'payer';
const String driverKey = 'driver';
const String awardsTimeKey = 'awardsTime';
const Duration awardsExpirationTime = Duration(hours: 20);

mixin ScoreAware on TeamAware {
  static Map<Player, Score> scores = {};

  static List<Award> _cachedAwards = [];
  static List<Award> get awards {
    if (_cachedAwards.isEmpty) {
      var playersScores = scores.entries.toList()
        ..sort(
          (a, b) => a.value.compareTo(b.value),
        );
      for (var playerScore in playersScores) {
        var award = Award(playerScore.key, playerScore.value);
        _cachedAwards.add(Award(playerScore.key, playerScore.value));
        award.mustDrive = false;
      }
      _cachedAwards.first.mustPay = true;
      _cachedAwards.last.mustDrive = true;
    }
    return _cachedAwards;
  }

  recordScore(Player player, Score score) {
    scores[player] = score;
    _cachedAwards.clear(); // Invalidates cache
  }

  resetScores() {
    scores = {};
    _cachedAwards.clear(); // Invalidates cache
  }

  Future<void> storeAwards() async {
    var prefs = await SharedPreferences.getInstance();
    var payer = awards.first.player;
    var driver = awards.last.player;
    prefs.setString(payerKey, payer.name);
    prefs.setString(driverKey, driver.name);
    prefs.setInt(awardsTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<DriverAndPayer> retrieveCurrentDriverAndPayer() async {
    var prefs = await SharedPreferences.getInstance();
    var awardsTimeInMilliseconds = prefs.getInt(awardsTimeKey);
    var awardsTime =
        DateTime.fromMillisecondsSinceEpoch(awardsTimeInMilliseconds ?? 0);
    if (DateTime.now().difference(awardsTime) > awardsExpirationTime) {
      if (awardsTimeInMilliseconds != null) {
        debugPrint("Awards expired ($awardsTime)");
      }
      return DriverAndPayer(null, null);
    }
    return DriverAndPayer(
        prefs.getString(driverKey), prefs.getString(payerKey));
  }
}

class Score extends Comparable<Score> {
  final double points;
  final double time;

  Score({required this.points, required this.time});

  @override
  compareTo(Score other) {
    if (points != other.points) {
      return points.compareTo(other.points); // More points is better
    }
    return -time.compareTo(other.time); // Less time is better
  }
}

class Award {
  final Player player;
  final Score score;
  bool? mustDrive;
  bool? mustPay;

  bool? get canDrink => mustDrive == null ? null : !mustDrive!;
  set canDrink(bool? value) => mustDrive = value == null ? null : !value;

  Award(this.player, this.score);
}

class DriverAndPayer {
  final String? driver;
  final String? payer;

  DriverAndPayer(this.driver, this.payer);
}
