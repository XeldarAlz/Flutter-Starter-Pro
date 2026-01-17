import 'package:dio/dio.dart';
import 'package:flutter_starter_pro/core/constants/api_constants.dart';
import 'package:flutter_starter_pro/core/errors/exceptions.dart';
import 'package:flutter_starter_pro/core/network/api_interceptors.dart';
import 'package:flutter_starter_pro/core/storage/secure_storage.dart';

/// API Client wrapper around Dio.
///
/// Provides a convenient interface for making HTTP requests with
/// automatic token management, error handling, and retry logic.
class ApiClient {
  /// Creates an ApiClient with the given configuration.
  ///
  /// [secureStorage] is required for token management.
  /// [baseUrl] defaults to ApiConstants.baseUrl if not provided.
  /// [connectionTimeout] and [receiveTimeout] can be customized per environment.
  /// [enableLogging] controls whether request/response logging is enabled.
  ApiClient({
    required SecureStorage secureStorage,
    String? baseUrl,
    Duration? connectionTimeout,
    Duration? receiveTimeout,
    bool enableLogging = true,
  }) : _secureStorage = secureStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: connectionTimeout ?? ApiConstants.connectionTimeout,
        receiveTimeout: receiveTimeout ?? ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
          ApiConstants.acceptHeader: ApiConstants.applicationJson,
        },
      ),
    );

    _setupInterceptors(enableLogging: enableLogging);
  }

  late final Dio _dio;
  final SecureStorage _secureStorage;

  /// Get the Dio instance
  Dio get dio => _dio;

  void _setupInterceptors({bool enableLogging = true}) {
    _dio.interceptors.addAll([
      if (enableLogging) LoggingInterceptor(),
      AuthInterceptor(_secureStorage),
      TokenRefreshInterceptor(_dio, _secureStorage),
      RetryInterceptor(dio: _dio),
    ]);
  }

  /// Perform a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Perform a DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to app exceptions
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.cancel:
        return const CancelledException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.badCertificate:
        return const ServerException(
          message: 'Invalid certificate',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return ServerException(
          message: error.message ?? 'Unknown error occurred',
          code: 'UNKNOWN',
        );
    }
  }

  AppException _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return const ServerException(
        message: 'No response from server',
        code: 'NO_RESPONSE',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    var message = 'Server error occurred';

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          data['error'] as String? ??
          'Server error occurred';
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message: message);
      case 401:
        return const UnauthorizedException();
      case 403:
        return AuthException(message: 'Access forbidden: $message');
      case 404:
        return const NotFoundException();
      case 422:
        final errors = data is Map<String, dynamic>
            ? data['errors'] as Map<String, dynamic>?
            : null;
        return ValidationException(
          message: message,
          errors: errors?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>).cast<String>(),
            ),
          ),
        );
      case 429:
        return const ServerException(
          message: 'Too many requests. Please try again later.',
          code: 'RATE_LIMITED',
          statusCode: 429,
        );
      case 500:
      case 502:
      case 503:
      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
    }
  }
}

