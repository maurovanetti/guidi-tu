import 'dart:convert';

import 'gender.dart';
import 'persistence.dart';
import 'player.dart';

mixin TeamAware on Gendered {
  static List<Player> _players = [];

  List<Player> get players => _players;

  void retrieveTeam() {
    var team = db.getStringList(Persistence.playersKey);
    _players = [];
    int genderBalance = 0;
    for (var i = 0; i < team.length; i++) {
      var player = Player.fromJson(i, jsonDecode(team[i]));
      _players.add(player);
      if (player.gender case Gender.male) {
        genderBalance--;
      } else if (player.gender case Gender.female) {
        genderBalance++;
      }
    }
    // Majority rule
    if (genderBalance > 0) {
      gender = Gender.male;
    } else if (genderBalance < 0) {
      gender = Gender.female;
    }
  }

  void storeTeam() {
    var team = players.map((player) => jsonEncode(player.toJson()));
    db.set(Persistence.playersKey, team.toList());
    db.delete(Persistence.sessionKey);
  }

  static void storeSessionData(Map<String, dynamic> data) {
    db.set(Persistence.sessionKey, jsonEncode(data));
  }

  static Map<String, dynamic> retrieveSessionData() {
    var sessionData = db.getString(Persistence.sessionKey);
    return sessionData.isNotEmpty ? jsonDecode(sessionData) : {};
  }

  static Player getPlayer(int? id) => _players
      .firstWhere((player) => player.id == id, orElse: () => Player.none);
}
