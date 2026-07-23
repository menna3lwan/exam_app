import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_constants.dart';
import '../network/auth_interceptor.dart';
import '../services/exam_history_store.dart';
import '../services/session_event_bus.dart';
import '../services/token_service.dart';

// ── Auth feature ──
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repository_impl.dart';
import '../../features/auth/domain/repos/auth_repository.dart';
import '../../features/auth/domain/use_cases/change_password_use_case.dart';
import '../../features/auth/domain/use_cases/forget_password_use_case.dart';
import '../../features/auth/domain/use_cases/get_profile_use_case.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/logout_use_case.dart';
import '../../features/auth/domain/use_cases/reset_password_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/update_profile_use_case.dart';
import '../../features/auth/domain/use_cases/verify_code_use_case.dart';
import '../../features/auth/presentation/cubits/forget_password/forget_password_cubit.dart';
import '../../features/auth/presentation/cubits/login/login_cubit.dart';
import '../../features/auth/presentation/cubits/logout/logout_cubit.dart';
import '../../features/auth/presentation/cubits/profile/profile_cubit.dart';
import '../../features/auth/presentation/cubits/reset_password/reset_password_cubit.dart';
import '../../features/auth/presentation/cubits/sign_up/sign_up_cubit.dart';
import '../../features/auth/presentation/cubits/verify_code/verify_code_cubit.dart';

// ── Home feature ──
import '../../features/home/data/data_sources/home_data_source.dart';
import '../../features/home/data/data_sources/home_remote_data_source.dart';
import '../../features/home/data/repos/home_repository_impl.dart';
import '../../features/home/domain/repos/home_repository.dart';
import '../../features/home/domain/use_cases/get_subjects_use_case.dart';
import '../../features/home/presentation/cubits/explore/explore_cubit.dart';
import '../../features/home/presentation/cubits/results/results_cubit.dart';

// ── Exam feature ──
import '../../features/exam/data/data_sources/exam_data_source.dart';
import '../../features/exam/data/data_sources/exam_remote_data_source.dart';
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
/// [prefs] must be pre-initialized in main() before calling this,
/// because SharedPreferences.getInstance() is async and DI registration
/// must be synchronous.
///
/// Registration order:
///   1. Infrastructure (secure storage, SharedPreferences, TokenService,
///      SessionEventBus, Dio + AuthInterceptor, AssetBundle)
///   2. Data sources (registered against abstract contracts)
///   3. Repositories (registered against abstract contracts)
///   4. Use cases
///   5. Cubits (factory — new instance per BlocProvider)
void configureDependencies(SharedPreferences prefs) {
  // ───────────────────────── Infrastructure ─────────────────────────

  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<TokenService>(
    TokenService(
      secureStorage: getIt<FlutterSecureStorage>(),
      prefs: getIt<SharedPreferences>(),
    ),
  );
  getIt.registerSingleton<ExamHistoryStore>(
    ExamHistoryStore(
      prefs: getIt<SharedPreferences>(),
      tokenService: getIt<TokenService>(),
    ),
  );
  getIt.registerSingleton<SessionEventBus>(SessionEventBus());
  getIt.registerSingleton<Dio>(
    _createDio(
      tokenService: getIt<TokenService>(),
      sessionEventBus: getIt<SessionEventBus>(),
    ),
  );
  getIt.registerSingleton<AssetBundle>(rootBundle);

  // ───────────────────────── Auth ─────────────────────────

  getIt.registerSingleton<AuthDataSource>(
    AuthRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      getIt<AuthDataSource>(),
      getIt<TokenService>(),
    ),
  );

  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => ForgetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => VerifyCodeUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => ResetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => LogoutUseCase(getIt<AuthRepository>()));

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
  getIt.registerFactory(() => LogoutCubit(getIt<LogoutUseCase>()));

  // ── Profile (uses Auth endpoints) ──
  getIt.registerFactory(() => GetProfileUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => UpdateProfileUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => ChangePasswordUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
    ),
  );

  // ───────────────────────── Home ─────────────────────────

  getIt.registerSingleton<HomeDataSource>(
    HomeRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(getIt<HomeDataSource>()),
  );

  getIt.registerFactory(() => GetSubjectsUseCase(getIt<HomeRepository>()));
  getIt.registerFactory(() => ExploreCubit(getIt<GetSubjectsUseCase>()));

  // ───────────────────────── Exam ─────────────────────────

  getIt.registerSingleton<ExamDataSource>(
    ExamRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerSingleton<ExamRepository>(
    ExamRepositoryImpl(
      getIt<ExamDataSource>(),
      getIt<ExamHistoryStore>(),
    ),
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
    () => ExamSessionCubit(
      getIt<SubmitExamUseCase>(),
      getIt<ExamHistoryStore>(),
    ),
  );

  // ── Results (Home tab) ──
  getIt.registerFactory(
    () => ResultsCubit(getIt<GetExamHistoryUseCase>()),
  );
}

Dio _createDio({
  required TokenService tokenService,
  required SessionEventBus sessionEventBus,
}) {
  final dio = Dio();
  dio.options = BaseOptions(
    baseUrl: baseUrl,
    receiveTimeout: const Duration(seconds: 60),
    connectTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  );

  // Auth interceptor — attaches token header + handles 401/403.
  dio.interceptors.add(
    AuthInterceptor(
      tokenService: tokenService,
      onSessionExpired: () => sessionEventBus.fire(SessionEvent.expired),
    ),
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
