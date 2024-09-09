// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:collection/collection.dart';
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
  late final List<List<Widget>> _placementGroups;

  void _handleEndGame() {
    ScoreAware.storeAwards();
    if (mounted) {
      Navigation.replaceAll(context, () => const TitleScreen()).go();
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    var placementCards =
        ScoreAware.awards.map((award) => PlacementCard(award, $: $)).toList();
    var payer = placementCards.removeAt(0);
    var driver = placementCards.removeLast();
    _placementGroups = [
      [payer],
      placementCards,
      [driver],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classifica"),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          primary: true,
          shrinkWrap: true,
          padding: StyleGuide.regularPadding,
          children: [
            // ignore: avoid-slow-collection-methods
            ..._placementGroups.mapIndexed(
              (i, group) => group.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyleGuide.getLabelOnImportantBorder(
                          context,
                          [
                            "Può bere ma paga",
                            if (group.length > 1)
                              "Possono bere"
                            else
                              "Può bere",
                            "Guida e non beve",
                          ].elementAt(i),
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            shape: StyleGuide.getImportantBorder(context),
                          ),
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: Column(
                            children: group,
                          ),
                        ),
                        const Gap(),
                      ],
                    )
                  : Container(),
            ),
            const SafeMarginForCustomFloatingActionButton(),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toHome,
        tooltip: "Fine",
        icon: Icons.stop_rounded,
        // On press, a short async computation is required
        onPressed: _handleEndGame,
      ),
    );
  }
}

class PlacementCard extends StatelessWidget {
  const PlacementCard(this.award, {super.key, required this.$});

  final Award award;
  final AppLocalizations $;

  @override
  Widget build(BuildContext context) {
    debugPrint("Building PlacementCard for $award…");
    TextStyle style = Theme.of(context).textTheme.bodyLarge!;
    String role = "";
    var grammar = award.player.t;
    if (award.mustPay) {
      role = grammar($.generousDesignatedBenefactor);
      style = style.copyWith(fontWeight: FontWeight.bold);
    } else if (award.canDrink) {
      role = grammar($.authorisedDrinker);
    } else {
      role = grammar($.soberDesignatedDriver);
      style = style.copyWith(fontWeight: FontWeight.bold);
    }
    debugPrint("Role: $role");
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: StyleGuide.borderRadius,
      ),
      child: ListTile(
        contentPadding: StyleGuide.stripePadding,
        title: PlayerPlacement(award),
        subtitle: Padding(
          padding: StyleGuide.sidePadding,
          child: Row(
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
      ),
    );
  }
}
