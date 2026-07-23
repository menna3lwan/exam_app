import 'package:flutter_test/flutter_test.dart';

import 'package:exam_app/data/models/exam_history_model.dart';

void main() {
  group('ExamHistoryModel API history shapes', () {
    test('fromJson tolerates string/double numeric fields', () {
      final model = ExamHistoryModel.fromJson({
        '_id': 'h1',
        'examTitle': 'JS Basics',
        'subjectName': 'JavaScript',
        'numberOfQuestions': '10',
        'durationMinutes': 20.0,
        'correctAnswers': '5',
        'timeSpentMinutes': 4.2,
      });

      expect(model.numberOfQuestions, 10);
      expect(model.durationMinutes, 20);
      expect(model.correctAnswers, 5);
      expect(model.timeSpentMinutes, 4);
    });

    test('fromAnswerHistory maps checkAnswer and avgAnswerTime', () {
      final model = ExamHistoryModel.fromAnswerHistory(
        record: {
          '_id': 'hist1',
          'checkAnswer': 'correct',
          'avgAnswerTime': '0.8',
          'QID': {
            'exam': 'exam1',
            'subject': 'subj1',
          },
        },
        examTitle: 'JS Basics',
        subjectName: 'JavaScript',
        numberOfQuestions: 10,
        durationMinutes: 20,
      );

      expect(model.examTitle, 'JS Basics');
      expect(model.subjectName, 'JavaScript');
      expect(model.correctAnswers, 1);
      expect(model.numberOfQuestions, 10);
      expect(model.timeSpentMinutes, 1);
    });

    test('fromAnswerHistory tolerates Infinity/NaN avgAnswerTime', () {
      final model = ExamHistoryModel.fromAnswerHistory(
        record: {
          '_id': 'hist1',
          'checkAnswer': 'wrong',
          'avgAnswerTime': 'Infinity',
          'QID': {'exam': 'exam1'},
        },
        examTitle: 'JS Basics',
        subjectName: 'JavaScript',
      );

      expect(model.timeSpentMinutes, 0);
      expect(model.correctAnswers, 0);
    });
  });
}
