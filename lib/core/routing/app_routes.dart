/// Route name constants.
///
/// Named after the screen inventory visible in the Figma file's "Main app"
/// page (Login, Sign up, Forget/Reset password, Verification code, Home/
/// Explore, Exam flow, Results, Profile). No screens are registered against
/// these yet — Phase 1 is routing *skeleton* only; each name is wired up to
/// a real widget in the phase that builds that module.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';

  // Auth (Phase 2)
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgetPassword = '/forget-password';
  static const String verificationCode = '/verification-code';
  static const String resetPassword = '/reset-password';

  // Home (Phase 3)
  static const String home = '/home';

  // Exam flow (Phase 4)
  static const String examDetails = '/exam-details';
  static const String startExam = '/start-exam';
  static const String examSession = '/exam-session';
  static const String examResult = '/exam-result';

  // Results & Profile (Phase 5)
  static const String results = '/results';
  static const String profile = '/profile';
}
