import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: prefer-static-class
get localizationsDelegates => AppLocalizations.localizationsDelegates;

// ignore: prefer-static-class
get supportedLocales => AppLocalizations.supportedLocales;

mixin LocalizedWidget on Widget {
  $(BuildContext context) => LocalizedWidget.get$(context);

  static AppLocalizations get$(BuildContext context) =>
      AppLocalizations.of(context)!;
}

mixin Localized on State {
  get $ => AppLocalizations.of(context)!;
}
