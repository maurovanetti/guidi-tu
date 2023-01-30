import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'player.dart';

const String playersKey = 'players';

mixin TeamAware {
  List<Player> players = [];

  Future<void> retrieveTeam() async {
    var prefs = await SharedPreferences.getInstance();
    var team = prefs.getStringList(playersKey);
    players = [];
    if (team != null) {
      for (var i = 0; i < team.length; i++) {
        var player = Player.fromJson(i, jsonDecode(team[i]));
        players.add(player);
      }
    }
  }

  Future<void> storeTeam() async {
    var prefs = await SharedPreferences.getInstance();
    var team = players.map((player) => jsonEncode(player.toJson()));
    await prefs.setStringList(playersKey, team.toList());
  }
}
