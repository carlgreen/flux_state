import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Show 1240 as "1,240", keep small numbers as-is.
  static String quantity(int qty) {
    if (qty >= 1000) return NumberFormat('#,###').format(qty);
    return qty.toString();
  }
}
