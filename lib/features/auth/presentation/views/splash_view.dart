import 'package:flutter/material.dart';

import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/theme/app_colors.dart';

/// Splash screen — the app's entry point.
///
/// Checks the stored token + Remember Me flag:
/// - Token exists AND Remember Me → navigate to Home (auto-login).
/// - Otherwise → clear stale token → navigate to Login.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Brief visual pause so the splash is visible.
    await Future.delayed(const Duration(milliseconds: 800));

    final tokenService = getIt<TokenService>();

    // If Remember Me was not checked, clear any leftover token.
    await tokenService.clearSessionIfNotRemembered();

    final isLoggedIn = await tokenService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: 80, color: AppColors.white),
            SizedBox(height: 16),
            Text(
              'Exam App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
