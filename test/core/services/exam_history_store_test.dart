// ExamHistoryStore is the local-first fix for the Results tab: the real
// API's history endpoint only returns a single answer record (or null),
// so every completed exam is summarized and cached here immediately
// after submission. Tests use a real (mocked-initial-values)
// SharedPreferences instance plus a mocked TokenService, since the
// store's whole purpose is scoping data per user id.
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:exam_app/core/services/exam_history_store.dart';
import 'package:exam_app/data/models/exam_history_model.dart';

import '../../helpers/mocks.dart';

ExamHistoryModel _entry(String id, {int correct = 1}) => ExamHistoryModel(
      id: id,
      examTitle: 'Exam $id',
      subjectName: 'Subject',
      numberOfQuestions: 5,
      durationMinutes: 10,
      correctAnswers: correct,
      timeSpentMinutes: 3,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTokenService tokenService;
  late ExamHistoryStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    tokenService = MockTokenService();
    store = ExamHistoryStore(prefs: prefs, tokenService: tokenService);
  });

  group('when there is no logged-in user id', () {
    test('getAll returns an empty list instead of throwing', () async {
      when(() => tokenService.getUserId()).thenAnswer((_) async => null);
      expect(await store.getAll(), isEmpty);
    });

    test('save is a silent no-op', () async {
      when(() => tokenService.getUserId()).thenAnswer((_) async => null);
      await store.save(_entry('1'));
      expect(await store.getAll(), isEmpty);
    });
  });

  group('when scoped to a user', () {
    setUp(() {
      when(() => tokenService.getUserId()).thenAnswer((_) async => 'user-1');
    });

    test('starts empty', () async {
      expect(await store.getAll(), isEmpty);
    });

    test('save then getAll returns the saved entry', () async {
      await store.save(_entry('exam-1'));
      final all = await store.getAll();

      expect(all, hasLength(1));
      expect(all.first.id, 'exam-1');
    });

    test('newest submission is inserted first', () async {
      await store.save(_entry('exam-1'));
      await store.save(_entry('exam-2'));

      final all = await store.getAll();
      expect(all.map((e) => e.id).toList(), ['exam-2', 'exam-1']);
    });

    test('saving an entry with the same id replaces the old one (dedup by id)', () async {
      await store.save(_entry('exam-1', correct: 2));
      await store.save(_entry('exam-1', correct: 5));

      final all = await store.getAll();
      expect(all, hasLength(1));
      expect(all.first.correctAnswers, 5);
    });

    test('clearForCurrentUser removes only that user\'s history', () async {
      await store.save(_entry('exam-1'));
      await store.clearForCurrentUser();

      expect(await store.getAll(), isEmpty);
    });

    test('two different users do not see each other\'s history', () async {
      await store.save(_entry('exam-1'));

      when(() => tokenService.getUserId()).thenAnswer((_) async => 'user-2');
      expect(await store.getAll(), isEmpty);

      await store.save(_entry('exam-2'));
      expect((await store.getAll()).map((e) => e.id), ['exam-2']);
    });
  });
}
