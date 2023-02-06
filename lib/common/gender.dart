// Some people don't follow the gender binary, but the current purpose for this
// is to select the proper grammar gender in Italian, so we'll stick to the
// binary for now. Localizations will improve from here.
class Gender {
  final String letter;
  final String symbol;
  const Gender(this.letter, this.symbol);

  @override
  toString() => letter;
}

const male = Gender('m', '♂');
const female = Gender('f', '♀');
const neuter = Gender('n', '');

mixin Gendered {
  Gender gender = neuter;

  String t(String masculine, String feminine, [String? neutral]) {
    switch (gender) {
      case male:
        return masculine;
      case female:
        return feminine;
      default:
        return neutral ?? masculine; // Arguable
    }
  }
}
