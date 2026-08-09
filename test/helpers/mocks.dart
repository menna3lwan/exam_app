// Central mock/fake declarations shared by every test file.
//
// Uses mocktail (no code generation). One class per collaborator that the
// tests need to fake: Repositories, DataSources, UseCases, and infra
// services (TokenService, ExamHistoryStore, FlutterSecureStorage).
//
// Keeping every Mock class in one place avoids duplicated declarations
// across feature test folders and matches the project's own DI wiring
// (core/di/di.dart), which is the single source of truth for what
// depends on what.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exam_app/core/services/exam_history_store.dart';
import 'package:exam_app/core/services/token_service.dart';

import 'package:exam_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:exam_app/features/auth/domain/repos/auth_repository.dart';
import 'package:exam_app/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/get_profile_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/update_profile_use_case.dart';
import 'package:exam_app/features/auth/domain/use_cases/verify_code_use_case.dart';

import 'package:exam_app/features/home/data/data_sources/home_data_source.dart';
import 'package:exam_app/features/home/domain/repos/home_repository.dart';
import 'package:exam_app/features/home/domain/use_cases/get_subjects_use_case.dart';

import 'package:exam_app/features/exam/data/data_sources/exam_data_source.dart';
import 'package:exam_app/features/exam/domain/repos/exam_repository.dart';
import 'package:exam_app/features/exam/domain/use_cases/get_exam_history_use_case.dart';
import 'package:exam_app/features/exam/domain/use_cases/get_exams_use_case.dart';
import 'package:exam_app/features/exam/domain/use_cases/get_questions_use_case.dart';
import 'package:exam_app/features/exam/domain/use_cases/submit_exam_use_case.dart';

// ── Infra ──
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockTokenService extends Mock implements TokenService {}

class MockExamHistoryStore extends Mock implements ExamHistoryStore {}

// ── Auth ──
class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase {}

class MockVerifyCodeUseCase extends Mock implements VerifyCodeUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

// ── Home ──
class MockHomeDataSource extends Mock implements HomeDataSource {}

class MockHomeRepository extends Mock implements HomeRepository {}

class MockGetSubjectsUseCase extends Mock implements GetSubjectsUseCase {}

// ── Exam ──
class MockExamDataSource extends Mock implements ExamDataSource {}

class MockExamRepository extends Mock implements ExamRepository {}

class MockGetExamsUseCase extends Mock implements GetExamsUseCase {}

class MockGetQuestionsUseCase extends Mock implements GetQuestionsUseCase {}

class MockSubmitExamUseCase extends Mock implements SubmitExamUseCase {}

class MockGetExamHistoryUseCase extends Mock implements GetExamHistoryUseCase {}
