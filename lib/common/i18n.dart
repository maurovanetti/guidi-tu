import 'package:intl/intl.dart';

abstract final class I18n {
  static const locale = 'it_IT';
  static final centimetersFormat = NumberFormat('0.0', locale);
  static final secondsFormat = NumberFormat('0.00', locale);
  static final preciserSecondsFormat = NumberFormat('0.0000', locale);

  static final dateTimeFormat = DateFormat('dd/MM HH:mm', locale);
}
