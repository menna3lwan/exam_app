import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../network/api_constants.dart';

/// Carried over from the reference architecture unchanged (same timeouts,
/// same logger config), only the `baseUrl` now comes from Env.
@module
abstract class NetworkModule {
  @singleton
  Dio provideDio() {
    Dio dio = Dio();
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    // Auth interceptor (attaching the `token` header from local storage)
    // is intentionally NOT added here — that is Phase 2 business logic.
    return dio;
  }
}
