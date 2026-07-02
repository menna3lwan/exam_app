/// Minimal environment configuration skeleton.
///
/// The reference architecture hardcodes its base URL directly in
/// `api_constants.dart`. Exam App needs environment awareness (the Postman
/// collection only exposes one environment so far: production-style
/// `https://exam.elevateegy.com`), so this is a small, dependency-free
/// addition using `--dart-define`, not a new architectural pattern.
///
/// Usage: `flutter run --dart-define=ENV=staging` (falls back to
/// [Environment.dev] when not provided).
library;

enum Environment { dev, staging, prod }

class Env {
  Env._();

  static const String _envName = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static Environment get current {
    switch (_envName) {
      case 'staging':
        return Environment.staging;
      case 'prod':
        return Environment.prod;
      case 'dev':
      default:
        return Environment.dev;
    }
  }

  /// Base URL per environment.
  ///
  /// Only one backend has been shared via the Postman collection so far
  /// (Elevate Online Exams). Staging/prod are placeholders until the
  /// corresponding URLs are confirmed.
  static String get baseUrl {
    switch (current) {
      case Environment.dev:
      case Environment.staging:
      case Environment.prod:
        return 'https://exam.elevateegy.com/api/v1';
    }
  }
}
