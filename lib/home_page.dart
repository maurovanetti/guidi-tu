import 'package:flutter/material.dart';

import 'common/bubble.dart';
import 'common/custom_button.dart';
import 'common/gap.dart';
import 'common/navigation.dart';
import 'tutorial_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guidi Tu"),
      ),
      body: WithBubbles(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Chi guida stasera?',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
              Text('(Non è ancora stato deciso)',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall),
              const Gap(),
              Text('Chi paga stasera?',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
              Text('(Non è ancora stato deciso)',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall),
              const Gap(),
              CustomButton(
                text: 'Gioca di nuovo',
                onPressed:
                Navigation
                    .push(context, () => const TutorialPage())
                    .go,
              ),
              CustomButton(
                text: 'Informazioni',
                onPressed: () {
                  // TODO
                },
                important: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
