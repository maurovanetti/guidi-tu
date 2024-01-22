// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/common/common.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  InfoScreenState createState() => InfoScreenState();
}

class InfoScreenState extends TrackedState<InfoScreen> {
  static const disclaimer =
      "Applicazione realizzata nell'ambito del progetto \"Safe & Drive\", "
      "finanziato dal Consiglio dei Ministri - "
      "Dipartimento per le Politiche Antidroga, "
      "che ha come capofila la Città di Cuneo.\n"
      "L'obiettivo principale è la riduzione degli incidenti stradali "
      "correlati al consumo di alcol e sostanze.";

  static const newParagraph = TextSpan(text: '\n\n');

  String appName = "";
  String appVersion = "";
  String appBuild = "";

  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() async {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          appName = packageInfo.appName;
          appVersion = packageInfo.version;
          appBuild = packageInfo.buildNumber;
        });
      }
    });
  }

  String get appFullVersion {
    if (appVersion.isEmpty) {
      return '';
    }
    return kDebugMode ? " v$appVersion+$appBuild" : " v$appVersion";
  }

  @override
  Widget build(BuildContext context) {
    final regular = Theme.of(context).textTheme.bodyMedium;
    final bold = regular?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informazioni"),
      ),
      body: WithBubbles(
        behind: true,
        child: Padding(
          padding: StyleGuide.widePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                style: regular,
                TextSpan(
                  children: [
                    TextSpan(text: appName, style: bold),
                    TextSpan(text: appFullVersion),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/title/logo.png',
                height: 100,
              ),
              const Gap(),
              Text.rich(
                style: regular,
                TextSpan(
                  children: [
                    const TextSpan(text: disclaimer),
                    newParagraph,
                    const TextSpan(text: "Prodotta nel 2024 da "),
                    TextSpan(text: "cooperativa sociale Alice\n", style: bold),
                    const TextSpan(text: "Pensata e sviluppata da "),
                    TextSpan(text: "Mauro Vanetti\n", style: bold),
                    const TextSpan(text: "Disegni e animazioni di "),
                    TextSpan(text: "Jacopo Rovida\n", style: bold),
                    const TextSpan(
                        text: "Collaudo e preziosi consigli sempre di "),
                    TextSpan(text: "Jacopo Rovida\n", style: bold),
                    newParagraph,
                    const TextSpan(
                        text: "Questa app è software libero. "
                            "Tutto il codice sorgente e gli asset si trovano su "
                            "GitHub (maurovanetti/guidi-tu) e possono essere "
                            "riutilizzati purché non a scopo di lucro "
                            "secondo la licenza indicata nel repository.\n"
                            "Se volete aggiungere un minigioco, segnalare dei bug, "
                            "proporre migliorie, aggiungere traduzioni, intervenite "
                            "pure direttamente lì."),
                    newParagraph,
                  ],
                ),
              ),
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
