import 'package:flutter/foundation.dart';

import 'common.dart';

mixin ScoreAware {
  static const awardsExpirationTime = Duration(hours: 20);

  static final scores = <Player, Score>{};
  static final _cachedAwards = <Award>[];

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
        "Awards: ${_cachedAwards.map((a) => a.player.name).join(", ")}",
      );
    }
    // ignore: match-getter-setter-field-names
    return _cachedAwards;
  }

  // Rarely modifies score's time.
  static void recordScore(Player player, Score score) {
    const tieBreakerDeltaTime = 0.01;
    for (var otherScore in scores.values) {
      if (score.compareTo(otherScore) == 0) {
        // This is to prevent the very unlikely case of exactly identical scores
        // ignore: avoid-mutating-parameters
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

  static void storeAwards() {
    var payer = awards.first.player;
    var driver = awards.last.player;
    var now = DateTime.now();
    db.set(Persistence.payerKey, payer.name);
    db.set(Persistence.driverKey, driver.name);
    db.set(Persistence.awardsTimeKey, now.millisecondsSinceEpoch);
    debugPrint("Stored awards: $payer must pay, $driver must drive");
  }

  // ignore: prefer-getter-over-method
  static DriverAndPayer retrieveCurrentDriverAndPayer() {
    var awardsTimeInMilliseconds = db.getInt(Persistence.awardsTimeKey);
    var awardsTime =
        DateTime.fromMillisecondsSinceEpoch(awardsTimeInMilliseconds);
    if (DateTime.now().difference(awardsTime) > awardsExpirationTime) {
      if (awardsTimeInMilliseconds != 0) {
        debugPrint("Awards expired ($awardsTime)");
      }
      return const DriverAndPayer(null, null);
    }
    return DriverAndPayer(
      db.getString(Persistence.driverKey),
      db.getString(Persistence.payerKey),
    );
  }
}

class Score implements Comparable<Score> {
  final int points;
  final bool pointsMatter;
  final bool timeDisplayed;
  double time;
  final bool lessIsMore;
  final bool longerIsBetter;
  final ScoreFormatter onFormatPoints;

  String formattedPoints(AppLocalizations $) => onFormatPoints(points, $);
  String formattedTime(AppLocalizations $) => $.xSeconds(time);
  String displayedFirst(AppLocalizations $) =>
      pointsMatter ? formattedPoints($) : formattedTime($);
  String displayedSecond(AppLocalizations $) =>
      pointsMatter && timeDisplayed ? formattedTime($) : '';

  Score({
    required this.points,
    this.pointsMatter = true,
    this.timeDisplayed = true,
    required this.time,
    this.lessIsMore = false,
    this.longerIsBetter = false,
    required this.onFormatPoints,
  }) {
    assert(pointsMatter || timeDisplayed);
  }

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

  // ignore: match-getter-setter-field-names
  set canDrink(bool value) => mustDrive = !value;

  Award(this.player, this.score);

  @override
  toString() => "$player: $score, mustDrive: $mustDrive, mustPay: $mustPay";
}

class DriverAndPayer {
  final String? driver;
  final String? payer;

  const DriverAndPayer(this.driver, this.payer);
}
