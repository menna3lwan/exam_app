// Runs once before every test file in this suite.
//
// mocktail needs a concrete "fallback" instance registered for any
// non-primitive type used with `any()`/`captureAny()` matchers (String,
// int, bool, double are supported out of the box). Registering them here,
// once, means individual test files never have to repeat this boilerplate
// or risk forgetting it and getting a cryptic "type X not registered"
// failure at runtime.
//
// Map<String, String> is the only non-primitive argument type passed to a
// mocked collaborator in this codebase: ExamRepository/ExamDataSource
// .submitExam(answers: Map<String, String>).
import 'dart:async';

import 'package:mocktail/mocktail.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  registerFallbackValue(<String, String>{});
  await testMain();
}
