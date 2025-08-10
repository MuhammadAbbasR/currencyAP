import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Api_constants.dart';


class AppUrl {
  static final urlexchange =
      ' https://v6.exchangerate-api.com/v6/${ApiConstants.exKey}';
  static final url =
      'https://openexchangerates.org/api/latest.json?app_id=${ApiConstants.apiKey}';
  static final currenciesurl =
      'https://openexchangerates.org/api/currencies.json';
}
