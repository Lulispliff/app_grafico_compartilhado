import 'package:intl/intl.dart';

String capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

NumberFormat valorFormat() {
  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
}

DateFormat dateFormat() {
  return DateFormat('dd/MM/yyy');
}
