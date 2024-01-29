import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// ignore: prefer-static-class
late final Persistence db;

class Persistence {
  // Multiplayer games
  static const playersKey = 'players';
  static const sessionKey = 'session';
  static const payerKey = 'payer';
  static const driverKey = 'driver';
  static const awardsTimeKey = 'awardsTime';

  // Solo challenge
  static const challengerKey = 'challenger';
  static const soberScoresKey = 'soberScores';
  static const drunkScoresKey = 'drunkScores';

  static bool _initialized = false;

  late final Box _box;
  // Singleton
  Persistence._internal(Box box) {
    _box = box;
  }

  static Future<void> init({bool production = true}) async {
    if (!_initialized) {
      if (production) {
        Hive.init((await getApplicationDocumentsDirectory()).path);
      } else {
        Hive.init('./test/.hive');
      }
      var box = await Hive.openBox(production ? 'persistence' : 'mock');
      db = Persistence._internal(box);
    }
    _initialized = true;
  }

  // ignore: avoid-dynamic
  void set(String key, dynamic value) {
    unawaited(_box.put(key, value));
  }

  void delete(String key) {
    unawaited(_box.delete(key));
  }

  String getString(String key) => _box.get(key)?.toString() ?? '';

  int getInt(String key) => _box.get(key) ?? 0;

  List<String> getStringList(String key) =>
      _box.get(key) ?? List.empty(growable: true);

  Future<void> close() async {
    await _box.close();
  }

  void clear() {
    unawaited(_box.clear());
    debugPrint('Persistent data cleared');
  }
}
