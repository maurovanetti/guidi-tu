// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/common/common.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  InfoScreenState createState() => InfoScreenState();
}

class InfoScreenState extends TrackedState<InfoScreen> {
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
    // ignore: no-magic-string
    return kDebugMode ? " v$appVersion+$appBuild" : " v$appVersion";
  }

  @override
  Widget build(BuildContext context) {
    final regular = Theme.of(context).textTheme.bodyMedium;
    final bold = regular?.copyWith(fontWeight: FontWeight.bold);
    const logoHeight = 150.0;

    return Scaffold(
      appBar: AppBar(
        title: Text($.info),
      ),
      body: WithBubbles(
        behind: true,
        child: Padding(
          padding: StyleGuide.widePadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Text.rich(
                  style: regular,
                  TextSpan(
                    children: [
                      TextSpan(text: appName, style: bold),
                      TextSpan(text: appFullVersion),
                    ],
                  ),
                ),
              ),
              Image.asset(
                $.logoPath,
                height: logoHeight,
              ),
              const Gap(),
              MarkdownBody(
                data: $.mainCredits,
                styleSheet: MarkdownStyleSheet(
                  p: regular,
                ),
              ),
              const Gap(),
              ClipRRect(
                borderRadius: StyleGuide.borderRadius / 2,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Image.asset(
                    $.sponsorsPath,
                    // ignore: no-magic-number
                    width: 1240,
                    // ignore: no-magic-number
                    height: 354,
                  ),
                ),
              ),
              const Gap(),
              Text.rich(
                style: regular,
                TextSpan(
                  children: [
                    TextSpan(text: $.disclaimer),
                  ],
                ),
              ),
              const Gap(),
              Center(
                child: CustomButton(
                  text: $.softwareLicences,
                  // ignore: prefer-correct-handler-name
                  onPressed: () => showLicensePage(
                    context: context,
                    applicationVersion: appFullVersion,
                    applicationIcon: Image.asset($.logoPath),
                    // Always in English on purpose
                    applicationLegalese: "Contact posta@maurovanetti.info\n"
                        "for any clarification needed\n"
                        "and for localisation proposals.",
                  ),
                  important: false,
                ),
              ),
              const Gap(),
              Text.rich(
                TextSpan(
                  text: $.freeSoftwareCredits,
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
      name ?? get$(context).findOutPlaying,
      key: labelKey,
      style: name == null
          ? style.copyWith(fontStyle: FontStyle.italic)
          : style.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
