import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/di.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/services/session_event_bus.dart';
import 'core/theme/app_theme.dart';

// TODO(Phase 2+): once `flutter gen-l10n` has been run (see l10n.yaml +
// lib/l10n/*.arb), import the generated AppLocalizations and add
// `AppLocalizations.delegate` to `localizationsDelegates` below so ARB
// strings are usable via `AppLocalizations.of(context)`.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences must be initialized before DI because
  // TokenService depends on it synchronously.
  final prefs = await SharedPreferences.getInstance();
  configureDependencies(prefs);

  runApp(const ExamApp());
}

/// Global navigator key — used by [SessionEventBus] listener to force
/// logout navigation without requiring a BuildContext.
final navigatorKey = GlobalKey<NavigatorState>();

class ExamApp extends StatefulWidget {
  const ExamApp({super.key});

  @override
  State<ExamApp> createState() => _ExamAppState();
}

class _ExamAppState extends State<ExamApp> {
  StreamSubscription<SessionEvent>? _sessionSub;

  /// Prevents duplicate session-expired navigations. Multiple concurrent
  /// API failures can fire the event bus several times; we only act once.
  bool _isNavigatingToLogin = false;

  @override
  void initState() {
    super.initState();
    _sessionSub = getIt<SessionEventBus>().stream.listen(_onSessionEvent);
  }

  void _onSessionEvent(SessionEvent event) {
    if (event == SessionEvent.expired && !_isNavigatingToLogin) {
      _isNavigatingToLogin = true;
      // Force-navigate to login, clearing the entire stack.
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
      // Reset the flag after navigation completes so future genuine
      // session expiry (after re-login) can trigger again.
      Future.delayed(const Duration(milliseconds: 500), () {
        _isNavigatingToLogin = false;
      });
    }
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
