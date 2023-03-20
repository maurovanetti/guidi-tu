// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

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
    const bold = TextStyle(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Come funziona?'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: StyleGuide.getImportantBorder(context),
              ),
              padding: StyleGuide.regularPadding,
              margin: StyleGuide.regularPadding,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView(
                  padding: StyleGuide.scrollbarPadding,
                  children: const [
                    Text(
                      "😱 Chi beve alcolici non può guidare: troppo pericoloso.",
                      style: bold,
                    ),
                    Text(
                      "Ogni gruppo che esce dovrebbe avere un Guidatore Sobrio "
                      "Designato o una Guidatrice Sobria Designata, che quella "
                      "sera non beve alcolici. 🤷",
                    ),
                    Gap(),
                    Text(
                      "🎯 Ma come scegliere chi guida e chi invece beve?",
                      style: bold,
                    ),
                    Text(
                      "Con questa app! 📲",
                      style: bold,
                    ),
                    Text("Giocando a uno dei minigiochi dell'app, il gruppo "
                        "stabilisce chi guida e chi beve. 🎲"),
                    Gap(),
                    Text(
                      "🚕 Chi arriva in ultima posizione, guida e non beve.",
                      style: bold,
                    ),
                    Text(
                      "🥇 Ma attenzione: chi arriva in prima posizione, può bere ma "
                      "deve pagare.",
                      style: bold,
                    ),
                    Text(
                      "Decidete prima di giocare cosa dovrà pagare chi arriva "
                      "primo o prima. 🤝",
                    ),
                    Text("Paga da bere analcolici a chi guiderà? ☕️"),
                    Text(
                      "Paga il biglietto d'ingresso al locale a chi guiderà? 🎟️",
                    ),
                    Text("Paga snack per tutto il gruppo? 🍟"),
                    Text("Paga la benzina? ⛽"),
                    Gap(),
                    Text(
                      "✨ Buona serata e… "
                      "che guidi il peggiore e che paghi il migliore!",
                      style: bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(),
          const InterstitialAnimation(prefix: 'tutorial/Transition_mezzaria 2'),
        ],
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
