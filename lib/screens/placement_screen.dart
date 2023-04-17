// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'title_screen.dart';

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  PlacementScreenState createState() => PlacementScreenState();
}

class PlacementScreenState extends TrackedState<PlacementScreen>
    with Gendered, TeamAware, ScoreAware {
  late final List<Widget> _placementCards;

  @override
  initState() {
    super.initState();
    _placementCards = ScoreAware.awards
        .map((award) => PlacementCard(award))
        .toList(growable: false);
  }

  Future<void> _endGame() async {
    await ScoreAware.storeAwards();
    if (mounted) {
      Navigation.replaceAll(context, () => const TitleScreen()).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classifica"),
      ),
      body: WithBubbles(
        behind: true,
        child: ListView(
          padding: StyleGuide.regularPadding,
          children: _placementCards,
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toHome,
        tooltip: "Fine",
        icon: Icons.stop_rounded,
        // On press, a short async computation is required
        // ignore: avoid-passing-async-when-sync-expected
        onPressed: _endGame,
      ),
    );
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
        "Generoso Benefattore Designato",
        "Generosa Benefattrice Designata",
      );
      style = style.copyWith(fontWeight: FontWeight.bold);
    } else if (award.canDrink) {
      role = grammar(
        "Bevitore Autorizzato",
        "Bevitrice Autorizzata",
      );
    } else {
      role = grammar(
        "Guidatore Sobrio Designato",
        "Guidatrice Sobria Designata",
      );
      style = style.copyWith(fontWeight: FontWeight.bold);
    }
    debugPrint("Role: $role");
    return Card(
      child: ListTile(
        contentPadding: StyleGuide.stripePadding,
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
