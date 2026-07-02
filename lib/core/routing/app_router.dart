import 'package:flutter/material.dart';

import 'app_routes.dart';

/// Routing skeleton (Navigator 1.0 / `onGenerateRoute`), matching the
/// reference architecture's preference for plain Flutter APIs over an
/// extra routing package.
///
/// No feature screens exist yet, so every route currently resolves to
/// [_NotImplementedPage] — a scaffolding placeholder, not a designed
/// screen. Each Phase 2+ module replaces its own `case` here with the real
/// widget as it gets built.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
      case AppRoutes.login:
      case AppRoutes.signUp:
      case AppRoutes.forgetPassword:
      case AppRoutes.verificationCode:
      case AppRoutes.resetPassword:
      case AppRoutes.home:
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
          builder: (_) => _NotImplementedPage(routeName: settings.name ?? 'unknown'),
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
