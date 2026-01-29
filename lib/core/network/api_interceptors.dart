import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_starter_pro/core/constants/api_constants.dart';
import 'package:flutter_starter_pro/core/storage/secure_storage.dart';
import 'package:flutter_starter_pro/core/utils/logger.dart';

/// Interceptor for adding authentication headers
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix} $token';
    }

    return handler.next(options);
  }
}

/// Interceptor for logging requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      'REQUEST[${options.method}] => PATH: ${options.path}',
    );
    AppLogger.debug('Headers: ${options.headers}');
    if (options.data != null) {
      AppLogger.debug('Body: ${options.data}');
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.info(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      error: err,
    );
    return handler.next(err);
  }
}

/// Interceptor for handling token refresh
class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorage _secureStorage;
  bool _isRefreshing = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == HttpStatus.unauthorized && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _secureStorage.getRefreshToken();

        if (refreshToken != null) {
          final response = await _dio.post<Map<String, dynamic>>(
            ApiConstants.refreshToken,
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == HttpStatus.ok && response.data != null) {
            final newAccessToken = response.data!['access_token'] as String?;
            final newRefreshToken = response.data!['refresh_token'] as String?;

            if (newAccessToken != null) {
              await _secureStorage.saveAccessToken(newAccessToken);
            }
            if (newRefreshToken != null) {
              await _secureStorage.saveRefreshToken(newRefreshToken);
            }

            final opts = err.requestOptions;
            opts.headers[ApiConstants.authorizationHeader] =
                '${ApiConstants.bearerPrefix} $newAccessToken';

            final clonedRequest = await _dio.fetch<dynamic>(opts);
            return handler.resolve(clonedRequest);
          }
        }

        await _secureStorage.clearTokens();
        return handler.reject(err);
      } catch (e) {
        await _secureStorage.clearTokens();
        return handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    }

    return handler.next(err);
  }
}

/// Interceptor for retrying failed requests
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] as int? ?? 0;

    if (shouldRetry && retryCount < maxRetries) {
      final delay = retryDelays[retryCount];
      await Future<void>.delayed(delay);

      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        final response = await dio.fetch<dynamic>(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        // Retry failed, propagate original error
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
