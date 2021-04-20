import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format(String format, {String local}) {
    return DateFormat(format, local != null ? local : 'en_US').format(this);
  }
}
