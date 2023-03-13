import 'package:flutter/material.dart';

import '/common/common.dart';
import 'team_page.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends TrackedState<TutorialScreen> {
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
            InterstitialAnimation(prefix: 'tutorial/Transition_mezzaria 2'),
            Text("Spiegazione"),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toTeam,
        onPressed: Navigation.replaceLast(context, () => const TeamPage()).go,
        tooltip: 'Avanti',
        icon: Icons.arrow_forward,
      ),
    );
  }
}
