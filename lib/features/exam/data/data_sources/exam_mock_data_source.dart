import '../../../../data/models/exam_history_model.dart';
import '../../../../data/models/exam_model.dart';
import '../../../../data/models/exam_result_model.dart';
import '../../../../data/models/question_model.dart';

/// Mock data source for exam operations.
///
/// Contains all exam/question mock data previously in MockData class.
class ExamMockDataSource {
  static const _mockDelay = Duration(milliseconds: 400);

  Future<List<ExamModel>> getExamsForSubject(String subjectId) async {
    await Future.delayed(_mockDelay);
    return _exams.where((e) => e.subject == subjectId).toList();
  }

  Future<List<QuestionModel>> getQuestionsForExam(String examId) async {
    await Future.delayed(_mockDelay);
    return _questions.where((q) => q.exam == examId).toList();
  }

  Future<ExamResultModel> submitExam({
    required String examId,
    required Map<String, String> answers,
    required int timeSpentSeconds,
  }) async {
    await Future.delayed(_mockDelay);

    // Calculate result from mock questions
    final examQuestions = _questions.where((q) => q.exam == examId).toList();
    int correct = 0;
    int wrong = 0;
    final wrongList = <WrongQuestionInfo>[];

    for (final q in examQuestions) {
      final userAnswer = answers[q.id];
      if (userAnswer == q.correct) {
        correct++;
      } else {
        wrong++;
        if (userAnswer != null) {
          wrongList.add(WrongQuestionInfo(
            questionId: q.id,
            userAnswer: userAnswer,
            correctAnswer: q.correct,
          ));
        }
      }
    }

    return ExamResultModel(
      correct: correct,
      wrong: wrong,
      total: examQuestions.length,
      wrongQuestions: wrongList,
    );
  }

  Future<List<ExamHistoryModel>> getExamHistory() async {
    await Future.delayed(_mockDelay);
    return _examHistory;
  }

  // ── Static mock data ──

  static const _exams = [
    ExamModel(id: 'exam_eng_1', title: 'English', duration: 30, subject: 'subj_lang', numberOfQuestions: 20),
    ExamModel(id: 'exam_eng_2', title: 'English', duration: 30, subject: 'subj_lang', numberOfQuestions: 20),
    ExamModel(id: 'exam_eng_3', title: 'English', duration: 30, subject: 'subj_lang', numberOfQuestions: 20),
    ExamModel(id: 'exam_spa_1', title: 'Spanish', duration: 30, subject: 'subj_lang', numberOfQuestions: 20),
    ExamModel(id: 'exam_spa_2', title: 'Spanish', duration: 30, subject: 'subj_lang', numberOfQuestions: 20),
    ExamModel(id: 'exam_math_1', title: 'Algebra', duration: 25, subject: 'subj_math', numberOfQuestions: 15),
    ExamModel(id: 'exam_math_2', title: 'Geometry', duration: 20, subject: 'subj_math', numberOfQuestions: 10),
    ExamModel(id: 'exam_art_1', title: 'Art History', duration: 20, subject: 'subj_art', numberOfQuestions: 15),
    ExamModel(id: 'exam_sci_1', title: 'Biology', duration: 30, subject: 'subj_sci', numberOfQuestions: 20),
    ExamModel(id: 'exam_sci_2', title: 'Chemistry', duration: 25, subject: 'subj_sci', numberOfQuestions: 15),
  ];

  static const _questions = [
    QuestionModel(id: 'q1', question: 'Select the correctly punctuated sentence.', a1: 'Its going to rain today.', a2: "It's going to rain today.", a3: 'Its going to rain today.', a4: 'Its going to rain today.', correct: 'A2', subject: 'subj_lang', exam: 'exam_eng_1'),
    QuestionModel(id: 'q2', question: 'Which sentence uses the correct form of "their"?', a1: "Their going to the store.", a2: "There going to the store.", a3: "They're going to the store.", a4: "Thier going to the store.", correct: 'A3', subject: 'subj_lang', exam: 'exam_eng_1'),
    QuestionModel(id: 'q3', question: 'Choose the correct past tense of "run".', a1: 'Runned', a2: 'Ran', a3: 'Runed', a4: 'Running', correct: 'A2', subject: 'subj_lang', exam: 'exam_eng_1'),
    QuestionModel(id: 'q4', question: 'Which word is a synonym for "happy"?', a1: 'Sad', a2: 'Angry', a3: 'Joyful', a4: 'Tired', correct: 'A3', subject: 'subj_lang', exam: 'exam_eng_1'),
    QuestionModel(id: 'q5', question: 'Select the sentence with correct subject-verb agreement.', a1: 'The dogs runs fast.', a2: 'The dogs run fast.', a3: 'The dog run fast.', a4: 'The dogs running fast.', correct: 'A2', subject: 'subj_lang', exam: 'exam_eng_1'),
  ];

  static const _examHistory = [
    ExamHistoryModel(id: 'h1', examTitle: 'High level', subjectName: 'Language', numberOfQuestions: 20, durationMinutes: 30, correctAnswers: 18, timeSpentMinutes: 25),
    ExamHistoryModel(id: 'h2', examTitle: 'High level', subjectName: 'Language', numberOfQuestions: 20, durationMinutes: 30, correctAnswers: 18, timeSpentMinutes: 25),
    ExamHistoryModel(id: 'h3', examTitle: 'Algebra', subjectName: 'Math', numberOfQuestions: 20, durationMinutes: 30, correctAnswers: 18, timeSpentMinutes: 25),
    ExamHistoryModel(id: 'h4', examTitle: 'Algebra', subjectName: 'Math', numberOfQuestions: 20, durationMinutes: 30, correctAnswers: 18, timeSpentMinutes: 25),
  ];
}
