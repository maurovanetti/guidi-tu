// Some people don't follow the gender binary, but the current purpose for this
// is to select the proper grammar gender in Italian, so we'll stick to the
// binary for now. Localizations will improve from here.
// ignore_for_file: avoid-non-ascii-symbols
class Gender {
  static const male = Gender('m', '♂');
  static const female = Gender('f', '♀');
  static const neuter = Gender('n', '');

  final String letter;
  final String symbol;

  const Gender(this.letter, this.symbol);

  @override
  toString() => letter;
}

mixin Gendered {
  Gender gender = Gender.neuter;

  String t(String masculine, String feminine, [String? neutral]) {
    switch (gender) {
      case Gender.male:
        return masculine;
      case Gender.female:
        return feminine;
      default:
        return neutral ?? masculine; // Arguable
    }
  }
}
