import 'package:intl/intl.dart';

class StringUtils {
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

  static String formatValorBRL(double value) {
    final NumberFormat brl =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return brl.format(value);
  }

  static String capitalize(String text) {
    if (text.isEmpty) {
      return '';
    }
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  static String formatByPattern(DateTime? date, String pattern) {
    if (date == null) {
      return '';
    }
    return DateFormat(pattern).format(date);
  }
}

DateFormat dateFormat() {
  return DateFormat("dd/MM/yyyy");
}

DateFormat horaFormat() {
  return DateFormat("HH:mm");
}
