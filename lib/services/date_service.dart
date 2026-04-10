import 'package:intl/intl.dart';

class DateService {

  static final _datetimeStorageMask = 'yyyy-MM-dd HH:mm:ss';
  static final _spreadsheetFilterMask = 'yyyy-MM%';

  static String formatToStorage(DateTime date) {
    return DateFormat(_datetimeStorageMask).format(date).toUpperCase();
  }

  static DateTime? parseFromStorage(String? str) {
    return str != null ? DateFormat(_datetimeStorageMask).parse(str) : null;
  }

  static String formatToSpreadsheetWhere(DateTime date) {
    return DateFormat(_spreadsheetFilterMask).format(date).toUpperCase();
  }

  static String getMonthDesc(DateTime date) {
    return DateFormat('MMMM').format(date).toUpperCase();
  }

  static String getMonthYearDesc(DateTime date) {
    return DateFormat('MMMM/y').format(date).toUpperCase();
  }

  static DateTime addMonths(DateTime dt, int value) {
    int currentMonth = dt.month;
    int currentYear = dt.year;

    if (currentMonth == 12) {
      currentMonth = 1;
      currentYear = currentYear + 1;
    }
    else {
      currentMonth = currentMonth + 1;
    }

    return new DateTime(currentYear, currentMonth, dt.day);
  }

  static DateTime subractMonths(DateTime dt, int value) {
    int currentMonth = dt.month;
    int currentYear = dt.year;

    if (currentMonth == 1) {
      currentMonth = 12;
      currentYear = currentYear - 1;
    }
    else {
      currentMonth = currentMonth - 1;
    }

    return new DateTime(currentYear, currentMonth, dt.day);
  }

}
