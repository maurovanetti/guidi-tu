import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i18n.dart';
import 'player.dart';

mixin ScoreAware {
  static const String payerKey = 'payer';
  static const String driverKey = 'driver';
  static const String awardsTimeKey = 'awardsTime';
  static const Duration awardsExpirationTime = Duration(hours: 20);

  static final Map<Player, Score> scores = {};
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
      debugPrint(
          "Awards: ${_cachedAwards.map((a) => a.player.name).join(", ")}");
    }
    return _cachedAwards;
  }

  static void recordScore(Player player, Score score) {
    const tieBreakerDeltaTime = 0.01;
    for (var otherScore in scores.values) {
      if (score.compareTo(otherScore) == 0) {
        // This is to prevent the very unlikely case of exactly identical scores
        score.time += tieBreakerDeltaTime;
      }
    }
    scores[player] = score;
    _cachedAwards.clear(); // Invalidates cache
  }

  static void resetScores() {
    scores.clear();
    _cachedAwards.clear(); // Invalidates cache
  }

  static Future<void> storeAwards() async {
    var prefs = await SharedPreferences.getInstance();
    var payer = awards.first.player;
    var driver = awards.last.player;
    var now = DateTime.now();
    assert(await prefs.setString(payerKey, payer.name));
    assert(await prefs.setString(driverKey, driver.name));
    assert(await prefs.setInt(awardsTimeKey, now.millisecondsSinceEpoch));
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
  final bool pointsMatter;
  double time;
  final bool lessIsMore;
  final bool longerIsBetter;
  final String Function(int) formatPoints;

  String get formattedPoints => formatPoints(points);
  String get formattedTime => '${I18n.secondsFormat.format(time)}"';

  Score({
    required this.points,
    this.pointsMatter = true,
    required this.time,
    this.lessIsMore = false,
    this.longerIsBetter = false,
    required this.formatPoints,
  });

  @override
  compareTo(Score other) {
    if (pointsMatter && points != other.points) {
      int diffPoints = points.compareTo(other.points);
      if (lessIsMore != other.lessIsMore) {
        // This is just theoretical
        diffPoints = -diffPoints;
      }
      return lessIsMore ? diffPoints : -diffPoints;
    }
    int diffTime = time.compareTo(other.time);
    if (longerIsBetter != other.longerIsBetter) {
      // This is just theoretical
      diffTime = -diffTime;
    }
    return longerIsBetter ? -diffTime : diffTime;
  }

  @override
  toString() => "(points: $points, time: $time)";
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
