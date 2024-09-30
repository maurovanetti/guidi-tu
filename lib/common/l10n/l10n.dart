import 'package:flutter/material.dart';

import '/common/common.dart';

typedef LocalizedString = String Function(AppLocalizations);

final class L10n {
  static const _italian = 'it';

  static const _english = 'en';

  late String _userSelectedLanguage;

  static final _instance = L10n._internal();

  String get userSelectedLanguage => _userSelectedLanguage;

  bool get isLanguageSelected => _userSelectedLanguage.isNotEmpty;

  List<LocalizationsDelegate> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  Locale get currentLocale {
    return _userSelectedLanguage.isNotEmpty
        ? Locale(_userSelectedLanguage)
        : supportedLocales.first;
  }

  bool get isHeavilyGendered {
    switch (_userSelectedLanguage) {
      case _italian:
        return true;

      case _english:
      default:
        return false;
    }
  }

  set userSelectedLanguage(String value) {
    _userSelectedLanguage = value;
    db.set(Persistence.languageKey, value);
  }

  factory L10n() => _instance;

  L10n._internal() {
    _userSelectedLanguage = db.getString(Persistence.languageKey);
  }
}
