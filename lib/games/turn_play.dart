import 'package:flutter/material.dart';

import '/common/custom_button.dart';
import '/common/navigation.dart';
import '/common/gap.dart';
import '/common/player.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';

abstract class TurnPlay extends StatefulWidget {
  const TurnPlay({super.key});

  String get gameName;
  Widget get gamePlay;

  @override
  TurnPlayState createState() => TurnPlayState();
}

class TurnPlayState extends State<TurnPlay> with TeamAware, TurnAware {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameName),
      ),
        body: ListView(
            shrinkWrap: true,
            children: [
              PlayerTag(TurnAware.currentPlayer),
              Text("CONTATEMPO"),
              const Gap(),
              Text("AREA DI GIOCO"),
              const Gap(),
              CustomButton(
                text: "Ho finito!",
                onPressed: () => Navigation.push(context, widget.interstitial),
              ),
            ],
          ),
        ),
  }

}
