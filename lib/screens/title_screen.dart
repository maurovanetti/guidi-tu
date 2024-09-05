// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/screens/language_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '/common/common.dart';
import 'challenge/challenge_setup_screen.dart';
import 'info_screen.dart';
import 'tutorial_screen.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  static const googlePlayUrl =
      'https://play.google.com/store/apps/details?id=net.coopalice.guiditu';
  static const appStoreUrl =
      'https://apps.apple.com/it/app/guidi-tu/id6476491805';

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends TrackedState<TitleScreen>
    with ScoreAware, Localized {
  bool _loading = true;

  DriverAndPayer? _driverAndPayer;

  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() {
      debugPrint("Tutorial animation preloading...");
      try {
        // ignore: avoid-ignoring-return-values
        AnimationLoader.load(TutorialCarousel.tutorialAnimation);
        debugPrint("Tutorial animation preloaded");
      } catch (error) {
        debugPrint("Tutorial animation preloading failed: $error");
      }
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
        title: Text($.appName),
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
              Text($.whoDrivesTonight, style: style),
              DriverOrPayerLabel(
                _driverAndPayer?.driver,
                labelKey: WidgetKeys.driver,
                loading: _loading,
              ),
              const Gap(),
              Text($.whoPaysTonight, style: style),
              DriverOrPayerLabel(
                _driverAndPayer?.payer,
                labelKey: WidgetKeys.payer,
                loading: _loading,
              ),
              const Gap(),
              CustomButton(
                key: WidgetKeys.toTutorial,
                text: _driverAndPayer?.driver == null ? $.play : $.playAgain,
                onPressed:
                    Navigation.push(context, () => const TutorialScreen()).go,
              ),
              if (!kIsWeb)
                CustomButton(
                  key: WidgetKeys.toChallengeSetup,
                  text: $.challenge,
                  onPressed: Navigation.push(
                    context,
                    () => const ChallengeSetupScreen(),
                  ).go,
                  important: false,
                ),
              CustomButton(
                text: $.info,
                onPressed:
                    Navigation.push(context, () => const InfoScreen()).go,
                important: false,
              ),
              CustomButton(
                text: $.changeLanguage,
                onPressed:
                    Navigation.replaceAll(context, () => const LanguageScreen())
                        .go,
                important: false,
              ),
              if (kIsWeb)
                CustomButton(
                  text: $.downloadFromGooglePlay,
                  onPressed: () => unawaited(
                    launchUrl(Uri.parse(TitleScreen.googlePlayUrl)),
                  ),
                  important: false,
                ),
              if (kIsWeb)
                CustomButton(
                  text: $.downloadFromAppStore,
                  onPressed: () =>
                      unawaited(launchUrl(Uri.parse(TitleScreen.appStoreUrl))),
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
