import 'package:flutter/material.dart';

import '/common/common.dart';
import 'title_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  LanguageScreenState createState() => LanguageScreenState();
}

class LanguageScreenState extends State<LanguageScreen> with Localized {
  _select(String language, {required BuildContext context}) {
    setLanguage(language);
    Navigation.replaceAll(context, () => const TitleScreen()).go();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              key: WidgetKeys.selectEnglish,
              text: 'English',
              onPressed: () {
                _select('en', context: context);
              },
            ),
            const Gap(),
            CustomButton(
              key: WidgetKeys.selectItalian,
              text: 'Italiano',
              onPressed: () {
                _select('it', context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
