import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

import 'l10n.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

// to build the AppLocalizations file from the arb files -> flutter gen-l10n

AppLocalizations get$(BuildContext context) =>
    AppLocalizations.of(context) ?? AppLocalizationsEn();

mixin Localized<T extends StatefulWidget> on State<T> {
  AppLocalizations get $ => get$(context);

  void cycleLanguage() {
    final locales = L10n().supportedLocales;
    for (int i = 0; i < locales.length; i++) {
      if (locales[i] == L10n().currentLocale) {
        setLanguage(locales[(i + 1) % locales.length].languageCode);
        break;
      }
    }
  }

  void setLanguage(String language) {
    L10n().userSelectedLanguage = language;
    debugPrint("Switching to $language");
    context.findAncestorStateOfType<State<MaterialApp>>()!.setState(() {});
  }
}
