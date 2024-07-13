import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../constants/string_constants.dart';

class DateTimeService {
  static String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();

    final now = DateTime.now();
    final difference = now.difference(dateTime.toLocal());

    if (difference.inMinutes < 1) {
      return StringConstants().justNow;
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      final int minutes = difference.inMinutes.remainder(60);
      return '${StringConstants().thereIs} ${hours > 0 ? '$hours ${StringConstants().hour}${hours > 1 ? 's' : ''}' : ''} $minutes ${StringConstants().minutes}';
    }

    final String dateFormated = DateFormat(
      'EEEE d MMMM yyyy',
      'fr_FR',
    ).format(dateTime.toLocal());
    return dateFormated;
  }

  static String formatDateToDayMonthYear(DateTime dateTime) {
    final String dateFormated = DateFormat(
      'EEEE d MMMM yyyy',
      'fr_FR',
    ).format(dateTime.toLocal());
    return dateFormated;
  }

  static String formatTimeToString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String formatNbDayMonth(DateTime dateTime) {
    return DateFormat(
      'dd MMMM',
      'fr_FR',
    ).format(dateTime);
  }
}
