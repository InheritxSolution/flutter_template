import 'package:flutter/foundation.dart';

class EnvConfig {
  static String get environment => kDebugMode ? 'development' : 'production';

  static String get apiBaseUrl => kDebugMode
      ? 'https://jsonplaceholder.typicode.com'
      : 'https://jsonplaceholder.typicode.com';
}
