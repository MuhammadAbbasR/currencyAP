import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get exKey => dotenv.env['API_EX'] ?? '';
  static String get exUrl => 'https://v6.exchangerate-api.com/v6=$exKey';

  static String get currencyUrl =>
      'https://openexchangerates.org/api/latest.json?app_id=$apiKey';
}