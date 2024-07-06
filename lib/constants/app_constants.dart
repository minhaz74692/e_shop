import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const favouriteTag = 'bookmark_tag';
  static String googleMapAPI = dotenv.env['GP_APIKEY'] ?? '';
  static const String adjustPin = "assets/images/adjustPin.png";
}
