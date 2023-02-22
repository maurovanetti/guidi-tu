import 'package:flutter/material.dart';

import 'common/custom_fab.dart';
import 'common/navigation.dart';
import 'common/tracked_state.dart';
import 'common/widget_keys.dart';
import 'team_page.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends TrackedState<TutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Come funziona?'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Spiegazione"),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: toTeamWidgetKey,
        onPressed: Navigation.replaceLast(context, () => const TeamPage()).go,
        tooltip: 'Avanti',
        icon: Icons.arrow_forward,
      ),
    );
  }
}
