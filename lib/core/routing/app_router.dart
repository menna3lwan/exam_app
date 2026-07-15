import 'package:flutter/material.dart';

import '../../presentation/auth/forget_password/forget_password_view.dart';
import '../../presentation/auth/login/login_view.dart';
import '../../presentation/auth/reset_password/reset_password_view.dart';
import '../../presentation/auth/sign_up/sign_up_view.dart';
import '../../presentation/auth/verification_code/verification_code_view.dart';
import '../../presentation/home/home_view.dart';
import 'app_routes.dart';

/// Routing (Navigator 1.0 / `onGenerateRoute`), matching the reference
/// architecture's preference for plain Flutter APIs.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --- Auth flow ---
      case AppRoutes.splash:
        // For now, splash redirects to login
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginView(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginView(),
        );
      case AppRoutes.signUp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignUpView(),
        );
      case AppRoutes.forgetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgetPasswordView(),
        );
      case AppRoutes.verificationCode:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VerificationCodeView(),
        );
      case AppRoutes.resetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ResetPasswordView(),
        );

      // --- Home (bottom nav shell) ---
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeView(),
        );

      // --- Screens not yet implemented ---
      case AppRoutes.examDetails:
      case AppRoutes.startExam:
      case AppRoutes.examSession:
      case AppRoutes.examResult:
      case AppRoutes.results:
      case AppRoutes.profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => _NotImplementedPage(routeName: settings.name ?? ''),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              _NotImplementedPage(routeName: settings.name ?? 'unknown'),
        );
    }
  }
}

class _NotImplementedPage extends StatelessWidget {
  final String routeName;

  const _NotImplementedPage({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route "$routeName" is not implemented yet.'),
      ),
    );
  }
}
