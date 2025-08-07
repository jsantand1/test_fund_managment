import 'package:intl/intl.dart';

class UtilsApp {
  static String currencyFormat(num value, String currency) {
    final format = NumberFormat.decimalPattern('es_CO');
    return '$currency ${format.format(value)}';
  }
}
