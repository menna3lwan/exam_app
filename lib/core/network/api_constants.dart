import '../env/env.dart';

/// Base URL, sourced from the Postman collection ("Elevate Online Exams"):
/// https://exam.elevateegy.com/api/v1
///
/// Kept as a top-level constant (same shape as the reference architecture's
/// `api_constants.dart`), now backed by [Env] instead of a hardcoded string.
final String baseUrl = Env.baseUrl;

/// Auth header name observed in the Postman collection's example requests
/// (raw JWT, not an `Authorization: Bearer` scheme):
///   --header 'token: eyJhbGciOi...'
///
/// Not wired into Dio yet — Phase 1 is network *skeleton* only. The actual
/// auth interceptor (reading the persisted token and attaching this header)
/// is Phase 2 (Authentication module) business logic.
const String authTokenHeaderKey = 'token';
