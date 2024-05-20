import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDateSimple(DateTime? date) {
    return formatByPattern(date, 'dd/MM/yyyy');
  }

  static String formatDateHoraeMinuto(DateTime? date) {
    return formatByPattern(date, 'dd/MM/yyyy HH:mm');
  }

  static String formatDateComplete(DateTime? date) {
    return formatByPattern(date, 'dd/MM/yyyy HH:mm:ss');
  }

  static String formatHoraeMinuto(DateTime? date) {
    return formatByPattern(date, 'HH:mm');
  }

  static String formatByPattern(DateTime? date, String pattern) {
    if (date == null) {
      return '';
    }
    return DateFormat(pattern).format(date);
  }
}

NumberFormat valorFormat() {
  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
}

DateFormat dateFormat() {
  return DateFormat("dd/MM/yyyy");
}

DateFormat horaFormat() {
  return DateFormat("HH:mm");
}
