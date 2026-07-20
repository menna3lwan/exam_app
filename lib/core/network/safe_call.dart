import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_results.dart';

/// Error-handling boundary for the repository layer.
///
/// Every repository method wraps its remote/local call with [safeCall].
/// Any exception thrown by a datasource is caught here and converted
/// into a [Failure], so nothing above the repo layer ever needs try/catch.
Future<ApiResults<T>> safeCall<T>(
  Future<ApiResults<T>> Function() call,
) async {
  try {
    return await call();
  } on TimeoutException catch (e) {
    return Failure(e.message ?? 'Request timed out', e);
  } on DioException catch (e) {
    return Failure(
      e.response?.data?['message']?.toString() ?? e.message ?? 'Network error',
      e,
    );
  } on IOException catch (e) {
    return Failure('Connection error: ${e.toString()}', e);
  } on Exception catch (e) {
    return Failure(e.toString(), e);
  } catch (e) {
    // Non-Exception throwables (Error subclasses, etc.)
    return Failure(e.toString());
  }
}
