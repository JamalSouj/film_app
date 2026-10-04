import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Factory that produces a pre‑configured [Dio] instance.
///
/// Features:
///  • Base URL set to the TMDB v3 API root.
///  • `api_key` query parameter injected on every request.
///  • Request / response / error logging via [LogInterceptor].
///  • 15‑second connect & receive timeouts.
abstract final class DioClient {
  /// Returns a singleton‑ready [Dio] instance.
  ///
  /// In production you would typically register this via Riverpod
  /// or a service locator; we expose a static getter for simplicity.
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.tmdbBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        queryParameters: {
          'api_key': AppConstants.tmdbApiKey,
        },
      ),
    );

    // ── Interceptors ───────────────────────────────────────
    dio.interceptors.addAll([
      // Pretty‑print request / response in debug builds.
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),

      // Custom error‑mapping interceptor.
      _ErrorInterceptor(),
    ]);

    return dio;
  }
}

/// Maps raw [DioException] types to domain‑friendly messages
/// that the UI can display without leaking implementation details.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String message;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
      case DioExceptionType.badResponse:
        message = _mapStatusCode(err.response?.statusCode);
      default:
        message = 'An unexpected error occurred.';
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message,
      ),
    );
  }

  String _mapStatusCode(int? code) {
    if (code == null) return 'Request failed with an unknown status.';
    return switch (code) {
      401 => 'Invalid API key.',
      404 => 'The requested resource was not found.',
      429 => 'Too many requests. Please wait a moment.',
      >= 500 => 'Server error. Please try again later.',
      _ => 'Request failed (status $code).',
    };
  }
}
