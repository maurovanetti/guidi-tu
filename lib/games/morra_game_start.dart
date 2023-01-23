import 'package:flutter/src/widgets/framework.dart';

import 'turn_interstitial.dart';

class MorraGameStart extends TurnInterstitial {
  const MorraGameStart({super.key});

  @override
  String get instructions => """
Scegli quante dita mostrare e cerca di indovinare la somma delle dita mostrate da tutti i giocatori.

Se tutti gli altri si avvicinano più di te alla somma giusta, guidi tu.

Ma attenzione: se sei tu ad avvicinarti di più, paghi!
""";

  @override
  Widget get gamePlay => throw UnimplementedError();
}
