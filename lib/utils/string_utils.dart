import 'package:intl/intl.dart';

NumberFormat valorFormat() {
  return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
}

DateFormat dateFormat() {
  return DateFormat('dd/MM/yyy');
}

DateFormat horaFormat() {
  return DateFormat("HH:mm");
}
