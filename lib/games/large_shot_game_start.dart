import 'package:flutter/material.dart';

import 'turn_interstitial.dart';

class LargeShotGameStart extends TurnInterstitial {
  const LargeShotGameStart({super.key});

  @override
  String get gameName => "Spararla grossa";

  @override
  String get instructions => """
Scegli un numero intero qualunque. Cerca di sceglierlo grande!

Se scegli un numero più basso di tutti gli altri, guidi tu.

Ma attenzione: se scegli il numero più alto, paghi!
  """;

  @override
  Widget get gamePlay => const LargeShotGameStart();
}
