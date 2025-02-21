import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/utils/extensions/string_extension.dart';

import '../constants/api_constants.dart';
import '../constants/text_constants.dart';
import '../models/api_exception.dart';
import '../models/api_response.dart';
import '../utils/logger.dart';
import 'storage_service.dart';
import 'network_service.dart';

class ApiService {
  late Dio _dio;
  static final ApiService _instance = ApiService._internal();
  static final _networkService = NetworkService();
  static final _storageService = StorageService();

  factory ApiService() => _instance;

  ApiService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: ApiConstants.connectionTimeout),
        receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeout),
        responseType: ResponseType.json,
        headers: ApiConstants.headers,
      ),
    );

    _dio.interceptors.addAll([
      _authInterceptor(),
      _loggerInterceptor(),
      _responseInterceptor(),
    ]);

    // Use AppLogger for other service-level logs
    AppLogger.info('Dio initialized with base URL: ${ApiConstants.baseUrl}');
  }

  Interceptor _responseInterceptor() {
    return InterceptorsWrapper(
      onResponse: (response, handler) {
        // Standardize successful responses
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        // Convert DioException to our custom ApiException
        return handler.reject(error);
      },
    );
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _storageService.authToken;
        if (token.isNotNullAndNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Implement token refresh logic here
          try {
            final newToken = await _refreshToken();
            if (newToken != null) {
              // Retry the original request with new token
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            }
          } catch (e) {
            // Handle refresh token failure
            // You might want to logout the user here
          }
        }
        return handler.next(error);
      },
    );
  }

  PrettyDioLogger _loggerInterceptor() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }

  Future<String?> _refreshToken() async {
    // Implement your token refresh logic here
    // Return new token if successful, null otherwise
    return null;
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      if (!await _networkService.isConnected()) {
        AppLogger.error(TextConstants.internetError);
        throw ApiException(message: TextConstants.internetError);
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _processResponse<T>(response);
    } catch (e) {
      if (e is DioException) {
        AppLogger.error('API Error', e);
        throw _handleError(e);
      }
      throw ApiException(message: e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      if (!await _networkService.isConnected()) {
        AppLogger.error(TextConstants.internetError);
        throw ApiException(message: TextConstants.internetError);
      }

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _processResponse<T>(response);
    } catch (e) {
      if (e is DioException) {
        AppLogger.error('API Error', e);
        throw _handleError(e);
      }
      throw ApiException(message: e.toString());
    }
  }

  ApiResponse<T> _processResponse<T>(Response response) {
    return ApiResponse<T>(
      data: response.data,
      message: response.statusMessage,
      success: response.statusCode?.toString().startsWith('2') ?? false,
      statusCode: response.statusCode,
    );
  }

  ApiException _handleError(DioException error) {
    if (error.type != DioExceptionType.badResponse) {
      return _handleConnectionError(error);
    }

    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final serverMessage = data is Map ? data['message'] : null;

    switch (statusCode) {
      case 400:
        return ApiException(
            message: serverMessage ?? TextConstants.badRequest,
            statusCode: statusCode,
            data: data);
      case 401:
        return ApiException(
            message: serverMessage ?? TextConstants.unauthorized,
            statusCode: statusCode,
            data: data);
      case 403:
        return ApiException(
            message: serverMessage ?? TextConstants.forbidden,
            statusCode: statusCode,
            data: data);
      case 404:
        return ApiException(
            message: serverMessage ?? TextConstants.notFound,
            statusCode: statusCode,
            data: data);
      case 405:
        return ApiException(
            message: serverMessage ?? TextConstants.methodNotAllowed,
            statusCode: statusCode,
            data: data);
      case 409:
        return ApiException(
            message: serverMessage ?? TextConstants.conflict,
            statusCode: statusCode,
            data: data);
      case 429:
        return ApiException(
            message: serverMessage ?? TextConstants.tooManyRequests,
            statusCode: statusCode,
            data: data);
      case 500:
        return ApiException(
            message: serverMessage ?? TextConstants.internalServer,
            statusCode: statusCode,
            data: data);
      case 503:
        return ApiException(
            message: serverMessage ?? TextConstants.serviceUnavailable,
            statusCode: statusCode,
            data: data);
      default:
        return ApiException(
            message: serverMessage ?? TextConstants.generalError,
            statusCode: statusCode,
            data: data);
    }
  }

  ApiException _handleConnectionError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: TextConstants.timeoutError,
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ApiException(message: TextConstants.internetError);
        }
        return ApiException(message: TextConstants.generalError);
      default:
        return ApiException(
          message: error.message ?? TextConstants.generalError,
          statusCode: error.response?.statusCode,
        );
    }
  }
}
