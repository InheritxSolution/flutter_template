import '../../config/env/env_config.dart';

class ApiConstants {
  static String baseUrl = EnvConfig.apiBaseUrl;
  static const apiVersion = '/v1';

  // API Endpoints
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const profile = '/user/profile';
  static const todos = '/todos';

  // API Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API Timeout
  static const connectionTimeout = 30000; // 30 seconds
  static const receiveTimeout = 30000; // 30 seconds
}
