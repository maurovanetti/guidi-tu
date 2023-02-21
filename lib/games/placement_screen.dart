import 'package:flutter/material.dart';

import '/common/bubble.dart';
import '/common/custom_fab.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/score_aware.dart';
import '/common/team_aware.dart';
import '/home_page.dart';
import '../common/widget_keys.dart';

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  PlacementScreenState createState() => PlacementScreenState();
}

class PlacementScreenState extends State<PlacementScreen>
    with Gendered, TeamAware, ScoreAware {
  Future<void> _endGame() async {
    await ScoreAware.storeAwards();
    if (mounted) {
      Navigation.replaceAll(context, () => const HomePage()).go();
    }
  }

  List<Widget> _buildPlacements() => ScoreAware.awards
      .map((award) => PlacementCard(award))
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Classifica"),
        ),
        body: WithBubbles(
          behind: true,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: _buildPlacements(),
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          key: toHomeWidgetKey,
          tooltip: "Fine",
          icon: Icons.stop_rounded,
          onPressed: _endGame,
        ));
  }
}

class PlacementCard extends StatelessWidget {
  final Award award;

  const PlacementCard(this.award, {super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Building PlacementCard for $award…");
    TextStyle style = Theme.of(context).textTheme.bodyLarge!;
    String role = "";
    var grammar = award.player.t;
    if (award.mustPay) {
      role = grammar(
          "Generoso Benefattore Designato", "Generosa Benefattrice Designata");
      style = style.copyWith(fontWeight: FontWeight.bold);
    } else if (award.canDrink) {
      role = grammar("Bevitore Autorizzato", "Bevitrice Autorizzata");
    } else {
      role =
          grammar("Guidatore Sobrio Designato", "Guidatrice Sobria Designata");
      style = style.copyWith(fontWeight: FontWeight.bold);
    }
    debugPrint("Role: $role");
    return Card(
      child: ListTile(
        title: PlayerPlacement(award),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // This Text can be quite long and putting it into an Expanded
            // widget wraps it if necessary
            Expanded(child: Text(role, style: style)),
            // No need to expand the icons Row as long as it is so small
            Row(
              children: [
                if (award.canDrink) const Icon(Icons.local_bar_rounded),
                if (!award.canDrink) const Icon(Icons.no_drinks_rounded),
                if (award.mustPay) const Icon(Icons.attach_money_rounded),
                if (award.mustDrive) const Icon(Icons.drive_eta_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
