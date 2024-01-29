// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'challenge/challenge_setup_screen.dart';
import 'info_screen.dart';
import 'tutorial_screen.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends TrackedState<TitleScreen> with ScoreAware {
  bool _loading = true;

  DriverAndPayer? _driverAndPayer;

  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() {
      debugPrint("Tutorial animation preloading...");
      var _ = AnimationLoader.load(TutorialCarousel.tutorialAnimation);
      debugPrint("Tutorial animation preloaded");
    });
    Delay.after(2, _revealRoles);
  }

  _revealRoles() {
    var driverAndPayer = ScoreAware.retrieveCurrentDriverAndPayer();
    debugPrint("Driver=${driverAndPayer.driver ?? 'N/A'}, "
        "Payer=${driverAndPayer.payer ?? 'N/A'}");
    if (mounted) {
      setState(() {
        _driverAndPayer = driverAndPayer;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.headlineMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guidi Tu"),
      ),
      body: WithBubbles(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/title/logo.png',
                ),
              ),
              const Gap(),
              Text('Chi guida stasera?', style: style),
              DriverOrPayerLabel(
                _driverAndPayer?.driver,
                labelKey: WidgetKeys.driver,
                loading: _loading,
              ),
              const Gap(),
              Text('Chi paga stasera?', style: style),
              DriverOrPayerLabel(
                _driverAndPayer?.payer,
                labelKey: WidgetKeys.payer,
                loading: _loading,
              ),
              const Gap(),
              CustomButton(
                key: WidgetKeys.toTutorial,
                text: _driverAndPayer?.driver == null
                    ? 'Gioca'
                    : 'Gioca di nuovo',
                onPressed:
                    Navigation.push(context, () => const TutorialScreen()).go,
              ),
              CustomButton(
                key: WidgetKeys.toChallengeSetup,
                text: 'Prova di abilità',
                onPressed:
                    Navigation.push(context, () => const ChallengeSetupScreen())
                        .go,
                important: false,
              ),
              CustomButton(
                text: 'Informazioni',
                onPressed:
                    Navigation.push(context, () => const InfoScreen()).go,
                important: false,
              ),
              const Gap(),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverOrPayerLabel extends StatelessWidget {
  const DriverOrPayerLabel(
    this.name, {
    super.key,
    required this.labelKey,
    required this.loading,
  });

  final String? name;
  final Key labelKey;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineLarge!;
    if (loading) {
      return SizedBox(
        height: style.fontSize! * style.height!,
        child: const LinearProgressIndicator(),
      );
    }
    // ignore: prefer-returning-conditional-expressions
    return FittedText(
      name ?? 'Decidetelo giocando!',
      key: labelKey,
      style: name == null
          ? style.copyWith(fontStyle: FontStyle.italic)
          : style.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
