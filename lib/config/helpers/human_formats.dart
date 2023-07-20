

import 'package:intl/intl.dart';

class HumanFortmats {

  static String number( double number ) {

    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en'
    ).format(number);

    return formattedNumber;
  }

}