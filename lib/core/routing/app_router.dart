import 'package:flutter/material.dart';

import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/reset_password_view.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/auth/presentation/views/splash_view.dart';
import '../../features/auth/presentation/views/verification_code_view.dart';
import '../../features/exam/presentation/views/answers_review_view.dart';
import '../../features/exam/presentation/views/exam_result_view.dart';
import '../../features/exam/presentation/views/exam_session_view.dart';
import '../../features/exam/presentation/views/start_exam_view.dart';
import '../../features/exam/presentation/views/subject_exams_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --- Auth ---
      case AppRoutes.splash:
        return _page(settings, const SplashView());
      case AppRoutes.login:
        return _page(settings, const LoginView());
      case AppRoutes.signUp:
        return _page(settings, const SignUpView());
      case AppRoutes.forgetPassword:
        return _page(settings, const ForgetPasswordView());
      case AppRoutes.verificationCode:
        return _page(settings, const VerificationCodeView());
      case AppRoutes.resetPassword:
        return _page(settings, const ResetPasswordView());

      // --- Home ---
      case AppRoutes.home:
        return _page(settings, const HomeView());

      // --- Exam flow ---
      case AppRoutes.subjectExams:
        return _page(settings, const SubjectExamsView());
      case AppRoutes.startExam:
        return _page(settings, const StartExamView());
      case AppRoutes.examSession:
        return _page(settings, const ExamSessionView());

      case AppRoutes.examResult:
        return _page(settings, const ExamResultView());
      case AppRoutes.answersReview:
        return _page(settings, const AnswersReviewView());

      // --- Not yet implemented ---
      case AppRoutes.examDetails:
      case AppRoutes.results:
      case AppRoutes.profile:
        return _page(
          settings,
          _NotImplementedPage(routeName: settings.name ?? ''),
        );
      default:
        return _page(
          settings,
          _NotImplementedPage(routeName: settings.name ?? 'unknown'),
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => child);
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
