import 'package:flutter/material.dart';

enum Gender {
  m,
  f,
}

class Player {
  int id;
  String name;
  Gender gender;

  Player(this.id, this.name, this.gender);

  static const _icons = [
    '🎹',
    '🎸',
    '🎷',
    '🎤',
    '🎻',
    '🥁',
    '🎺',
  ];
  String get icon => _icons[id % _icons.length];

  String get genderSymbol {
    switch (gender) {
      case Gender.f:
        return "♀";
      case Gender.m:
        return "♂";
    }
  }

  static final _foregroundColors = [
    Colors.purple.shade900,
    Colors.pink.shade900,
    Colors.brown.shade900,
    Colors.indigo.shade900,
    Colors.green.shade900,
    Colors.black87,
    Colors.deepOrange.shade900,
  ];
  static final _backgroundColors = [
    Colors.purpleAccent.shade100,
    Colors.pinkAccent.shade100,
    Colors.brown.shade300,
    Colors.indigoAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.grey.shade100,
    Colors.deepOrangeAccent.shade100,
  ];
  Color get background => _backgroundColors[id % _backgroundColors.length];
  Color get foreground => _foregroundColors[id % _foregroundColors.length];

  @override
  String toString() => "$id:$name";
}
