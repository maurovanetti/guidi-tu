import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

extension FindingByKey on Key {
  Finder found() => find.byKey(this);
}

extension FindingByText on String {
  Finder found() => find.text(this);
}
