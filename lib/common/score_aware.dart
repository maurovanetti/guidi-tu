import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i18n.dart';
import 'player.dart';

const String payerKey = 'payer';
const String driverKey = 'driver';
const String awardsTimeKey = 'awardsTime';
const Duration awardsExpirationTime = Duration(hours: 20);

mixin ScoreAware {
  static Map<Player, Score> scores = {};
  static final List<Award> _cachedAwards = [];
  static List<Award> get awards {
    if (_cachedAwards.isEmpty) {
      var playersScores = scores.entries.toList()
        ..sort(
          (a, b) => a.value.compareTo(b.value),
        );
      for (var playerScore in playersScores) {
        var award = Award(playerScore.key, playerScore.value);
        _cachedAwards.add(award);
      }
      _cachedAwards.first.mustPay = true;
      _cachedAwards.last.mustDrive = true;
    }
    debugPrint("Awards: ${_cachedAwards.map((a) => a.player.name).join(", ")}");
    debugPrint("Must Pay: ${_cachedAwards.first.mustPay}");
    return _cachedAwards;
  }

  static void recordScore(Player player, Score score) {
    for (var otherScore in scores.values) {
      if (score.compareTo(otherScore) == 0) {
        // This is to prevent the very unlikely case of exactly identical scores
        score = Score(points: score.points, time: score.time + 0.01);
      }
    }
    scores[player] = score;
    _cachedAwards.clear(); // Invalidates cache
  }

  static void resetScores() {
    scores = {};
    _cachedAwards.clear(); // Invalidates cache
  }

  static Future<void> storeAwards() async {
    var prefs = await SharedPreferences.getInstance();
    var payer = awards.first.player;
    var driver = awards.last.player;
    await prefs.setString(payerKey, payer.name);
    await prefs.setString(driverKey, driver.name);
    await prefs.setInt(awardsTimeKey, DateTime.now().millisecondsSinceEpoch);
    debugPrint("Stored awards: $payer must pay, $driver must drive");
  }

  static Future<DriverAndPayer> retrieveCurrentDriverAndPayer() async {
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
  final int points;
  final double time;

  String get formattedPoints => "$points pt.";
  String get formattedTime => '${secondsFormat.format(time)}"';

  Score({required this.points, required this.time});

  @override
  compareTo(Score other) {
    if (points != other.points) {
      return points.compareTo(other.points); // More points is better
    }
    return time.compareTo(other.time); // Less time is better
  }
}

class Award {
  final Player player;
  final Score score;
  bool mustDrive = false;
  bool mustPay = false;

  bool get canDrink => !mustDrive;
  set canDrink(bool value) => mustDrive = !value;

  Award(this.player, this.score);

  @override
  toString() => "$player: $score, mustDrive: $mustDrive, mustPay: $mustPay";
}

class DriverAndPayer {
  final String? driver;
  final String? payer;

  DriverAndPayer(this.driver, this.payer);
}
