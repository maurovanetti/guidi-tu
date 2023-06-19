import 'package:intl/intl.dart';

class I18n {
  static const locale = 'it_IT';
  static final centimetersFormat = NumberFormat('0.0', locale);
  static final secondsFormat = NumberFormat('0.00', locale);
  static final preciserSecondsFormat = NumberFormat('0.0000', locale);
}
