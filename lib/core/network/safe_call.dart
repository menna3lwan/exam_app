import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_results.dart';

/// Error-handling foundation.
///
/// Carried over from the reference architecture unchanged. Every repository
/// method wraps its remote/local call with [safeCall], which is the single
/// exception boundary of the app: any [TimeoutException], [DioException],
/// [IOException], or generic [Exception] thrown by a datasource is caught
/// here and converted into a [Failure], so nothing above the repo layer
/// ever needs a try/catch.
Future<ApiResults<T>> safeCall<T>(
  Future<ApiResults<T>> Function() call,
) async {
  try {
    return await call();
  } on TimeoutException catch (e) {
    return Failure(e.toString(), e);
  } on DioException catch (e) {
    return Failure(e.toString(), e);
  } on IOException catch (e) {
    return Failure(e.toString(), e);
  } catch (e) {
    return Failure(e.toString(), e as Exception);
  }
}
