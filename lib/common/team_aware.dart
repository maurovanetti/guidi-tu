import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'gender.dart';
import 'player.dart';

const String playersKey = 'players';

mixin TeamAware on Gendered {
  static List<Player> _players = [];
  List<Player> get players => _players;

  Future<void> retrieveTeam() async {
    var prefs = await SharedPreferences.getInstance();
    var team = prefs.getStringList(playersKey);
    _players = [];
    int genderBalance = 0;
    if (team != null) {
      for (var i = 0; i < team.length; i++) {
        var player = Player.fromJson(i, jsonDecode(team[i]));
        _players.add(player);
        switch (player.gender) {
          case male:
            genderBalance--;
            break;
          case female:
            genderBalance++;
            break;
        }
      }
    }
    // Majority rule
    if (genderBalance > 0) {
      gender = male;
    } else if (genderBalance < 0) {
      gender = female;
    }
  }

  Future<void> storeTeam() async {
    var prefs = await SharedPreferences.getInstance();
    var team = players.map((player) => jsonEncode(player.toJson()));
    assert(await prefs.setStringList(playersKey, team.toList()));
  }
}
