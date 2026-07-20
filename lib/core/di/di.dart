import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../network/api_constants.dart';

// ── Auth feature ──
import '../../features/auth/data/data_sources/auth_mock_data_source.dart';
import '../../features/auth/data/repos/auth_repository_impl.dart';
import '../../features/auth/domain/repos/auth_repository.dart';
import '../../features/auth/domain/use_cases/forget_password_use_case.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/reset_password_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/verify_code_use_case.dart';
import '../../features/auth/presentation/cubits/forget_password/forget_password_cubit.dart';
import '../../features/auth/presentation/cubits/login/login_cubit.dart';
import '../../features/auth/presentation/cubits/reset_password/reset_password_cubit.dart';
import '../../features/auth/presentation/cubits/sign_up/sign_up_cubit.dart';
import '../../features/auth/presentation/cubits/verify_code/verify_code_cubit.dart';

// ── Home feature ──
import '../../features/home/data/data_sources/home_mock_data_source.dart';
import '../../features/home/data/repos/home_repository_impl.dart';
import '../../features/home/domain/repos/home_repository.dart';
import '../../features/home/domain/use_cases/get_subjects_use_case.dart';
import '../../features/home/presentation/cubits/explore/explore_cubit.dart';
import '../../features/home/presentation/cubits/results/results_cubit.dart';

// ── Exam feature ──
import '../../features/exam/data/data_sources/exam_mock_data_source.dart';
import '../../features/exam/data/repos/exam_repository_impl.dart';
import '../../features/exam/domain/repos/exam_repository.dart';
import '../../features/exam/domain/use_cases/get_exam_history_use_case.dart';
import '../../features/exam/domain/use_cases/get_exams_use_case.dart';
import '../../features/exam/domain/use_cases/get_questions_use_case.dart';
import '../../features/exam/domain/use_cases/submit_exam_use_case.dart';
import '../../features/exam/presentation/cubits/exam_session/exam_session_cubit.dart';
import '../../features/exam/presentation/cubits/start_exam/start_exam_cubit.dart';
import '../../features/exam/presentation/cubits/subject_exams/subject_exams_cubit.dart';

final getIt = GetIt.instance;

/// Manual DI registration — no build_runner needed.
///
/// Registration order:
///   1. Infrastructure (Dio, AssetBundle)
///   2. Data sources
///   3. Repositories (registered against abstract contracts)
///   4. Use cases
///   5. Cubits (factory — new instance per BlocProvider)
void configureDependencies() {
  // ───────────────────────── Infrastructure ─────────────────────────

  getIt.registerSingleton<Dio>(_createDio());
  getIt.registerSingleton<AssetBundle>(rootBundle);

  // ───────────────────────── Auth ─────────────────────────

  getIt.registerSingleton<AuthMockDataSource>(AuthMockDataSource());
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<AuthMockDataSource>()),
  );

  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => ForgetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => VerifyCodeUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => ResetPasswordUseCase(getIt<AuthRepository>()));

  getIt.registerFactory(() => LoginCubit(getIt<LoginUseCase>()));
  getIt.registerFactory(() => SignUpCubit(getIt<SignUpUseCase>()));
  getIt.registerFactory(
    () => ForgetPasswordCubit(getIt<ForgetPasswordUseCase>()),
  );
  getIt.registerFactory(
    () => VerifyCodeCubit(
      getIt<VerifyCodeUseCase>(),
      getIt<ForgetPasswordUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ResetPasswordCubit(getIt<ResetPasswordUseCase>()),
  );

  // ───────────────────────── Home ─────────────────────────

  getIt.registerSingleton<HomeMockDataSource>(HomeMockDataSource());
  getIt.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(getIt<HomeMockDataSource>()),
  );

  getIt.registerFactory(() => GetSubjectsUseCase(getIt<HomeRepository>()));
  getIt.registerFactory(() => ExploreCubit(getIt<GetSubjectsUseCase>()));

  // ───────────────────────── Exam ─────────────────────────

  getIt.registerSingleton<ExamMockDataSource>(ExamMockDataSource());
  getIt.registerSingleton<ExamRepository>(
    ExamRepositoryImpl(getIt<ExamMockDataSource>()),
  );

  getIt.registerFactory(() => GetExamsUseCase(getIt<ExamRepository>()));
  getIt.registerFactory(() => GetQuestionsUseCase(getIt<ExamRepository>()));
  getIt.registerFactory(() => SubmitExamUseCase(getIt<ExamRepository>()));
  getIt.registerFactory(() => GetExamHistoryUseCase(getIt<ExamRepository>()));

  getIt.registerFactory(
    () => SubjectExamsCubit(getIt<GetExamsUseCase>()),
  );
  getIt.registerFactory(
    () => StartExamCubit(getIt<GetQuestionsUseCase>()),
  );
  getIt.registerFactory(
    () => ExamSessionCubit(getIt<SubmitExamUseCase>()),
  );

  // ── Results (Home tab) ──
  getIt.registerFactory(
    () => ResultsCubit(getIt<GetExamHistoryUseCase>()),
  );
}

Dio _createDio() {
  final dio = Dio();
  dio.options = BaseOptions(
    baseUrl: baseUrl,
    receiveTimeout: const Duration(seconds: 60),
    connectTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  );
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );
  return dio;
}
