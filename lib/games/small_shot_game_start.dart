import 'package:flutter/material.dart';

import 'turn_interstitial.dart';

class SmallShotGameStart extends TurnInterstitial {
  const SmallShotGameStart({super.key});

  @override
  String get gameName => "Cadere in basso";

  @override
  String get instructions => """
Scegli un numero intero qualunque. Cerca di sceglierlo piccolo!

Se scegli un numero più alto di tutti gli altri, guidi tu.

Ma attenzione: se scegli il numero più basso, paghi!
  """;

  @override
  Widget get gamePlay => throw UnimplementedError();
}
