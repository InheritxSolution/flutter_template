import '../services/api_service.dart';
import '../models/api_response.dart';

class BaseRepository {
  final ApiService _dioService = ApiService();

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    return _dioService.get<T>(
      path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    return _dioService.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }
}
