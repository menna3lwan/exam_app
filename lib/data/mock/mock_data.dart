import '../../core/constants/app_assets.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';
import '../models/subject_model.dart';

/// Static mock data for UI development (Phase 1 — no backend).
///
/// Subject names and icons match the Figma "Explore" screen exactly.
/// Exam titles and groupings match the "Explore > Languages" screen.
/// Question texts match the Figma exam question screens.
class MockData {
  MockData._();

  // ──────────────────────────────────────────────
  // Subjects (Figma: Language, Math, Art, Science)
  // ──────────────────────────────────────────────
  static const subjects = [
    SubjectModel(
      id: 'subj_lang',
      name: 'Language',
      icon: AppAssets.illustrationLanguageTranslator,
    ),
    SubjectModel(
      id: 'subj_math',
      name: 'Math',
      icon: AppAssets.illustrationDraftingTools,
    ),
    SubjectModel(
      id: 'subj_art',
      name: 'Art',
      icon: AppAssets.illustrationColorPalette,
    ),
    SubjectModel(
      id: 'subj_sci',
      name: 'Science',
      icon: AppAssets.illustrationMicroscope,
    ),
  ];

  // ──────────────────────────────────────────────
  // Exams (Figma: grouped under Languages → English / Spanish)
  // ──────────────────────────────────────────────
  static const exams = [
    // Language exams
    ExamModel(
      id: 'exam_eng_1',
      title: 'English',
      duration: 30,
      subject: 'subj_lang',
      numberOfQuestions: 20,
    ),
    ExamModel(
      id: 'exam_eng_2',
      title: 'English',
      duration: 30,
      subject: 'subj_lang',
      numberOfQuestions: 20,
    ),
    ExamModel(
      id: 'exam_eng_3',
      title: 'English',
      duration: 30,
      subject: 'subj_lang',
      numberOfQuestions: 20,
    ),
    ExamModel(
      id: 'exam_spa_1',
      title: 'Spanish',
      duration: 30,
      subject: 'subj_lang',
      numberOfQuestions: 20,
    ),
    ExamModel(
      id: 'exam_spa_2',
      title: 'Spanish',
      duration: 30,
      subject: 'subj_lang',
      numberOfQuestions: 20,
    ),
    // Math exams
    ExamModel(
      id: 'exam_math_1',
      title: 'Algebra',
      duration: 25,
      subject: 'subj_math',
      numberOfQuestions: 15,
    ),
    ExamModel(
      id: 'exam_math_2',
      title: 'Geometry',
      duration: 20,
      subject: 'subj_math',
      numberOfQuestions: 10,
    ),
    // Art exams
    ExamModel(
      id: 'exam_art_1',
      title: 'Art History',
      duration: 20,
      subject: 'subj_art',
      numberOfQuestions: 15,
    ),
    // Science exams
    ExamModel(
      id: 'exam_sci_1',
      title: 'Biology',
      duration: 30,
      subject: 'subj_sci',
      numberOfQuestions: 20,
    ),
    ExamModel(
      id: 'exam_sci_2',
      title: 'Chemistry',
      duration: 25,
      subject: 'subj_sci',
      numberOfQuestions: 15,
    ),
  ];

  // ──────────────────────────────────────────────
  // Questions (sample set for the first Language/English exam)
  // Text matches Figma: "Select the correctly punctuated sentence."
  // ──────────────────────────────────────────────
  static const questions = [
    QuestionModel(
      id: 'q1',
      question: 'Select the correctly punctuated sentence.',
      a1: 'Its going to rain today.',
      a2: "It's going to rain today.",
      a3: 'Its going to rain today.',
      a4: 'Its going to rain today.',
      correct: 'A2',
      subject: 'subj_lang',
      exam: 'exam_eng_1',
    ),
    QuestionModel(
      id: 'q2',
      question: 'Which sentence uses the correct form of "their"?',
      a1: "Their going to the store.",
      a2: "There going to the store.",
      a3: "They're going to the store.",
      a4: "Thier going to the store.",
      correct: 'A3',
      subject: 'subj_lang',
      exam: 'exam_eng_1',
    ),
    QuestionModel(
      id: 'q3',
      question: 'Choose the correct past tense of "run".',
      a1: 'Runned',
      a2: 'Ran',
      a3: 'Runed',
      a4: 'Running',
      correct: 'A2',
      subject: 'subj_lang',
      exam: 'exam_eng_1',
    ),
    QuestionModel(
      id: 'q4',
      question: 'Which word is a synonym for "happy"?',
      a1: 'Sad',
      a2: 'Angry',
      a3: 'Joyful',
      a4: 'Tired',
      correct: 'A3',
      subject: 'subj_lang',
      exam: 'exam_eng_1',
    ),
    QuestionModel(
      id: 'q5',
      question: 'Select the sentence with correct subject-verb agreement.',
      a1: 'The dogs runs fast.',
      a2: 'The dogs run fast.',
      a3: 'The dog run fast.',
      a4: 'The dogs running fast.',
      correct: 'A2',
      subject: 'subj_lang',
      exam: 'exam_eng_1',
    ),
  ];

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  /// Returns all exams for a given subject ID.
  static List<ExamModel> examsForSubject(String subjectId) =>
      exams.where((e) => e.subject == subjectId).toList();

  /// Returns all questions for a given exam ID.
  static List<QuestionModel> questionsForExam(String examId) =>
      questions.where((q) => q.exam == examId).toList();

  /// Finds a subject by ID, or null.
  static SubjectModel? subjectById(String id) {
    try {
      return subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Groups exams for a subject by their `title` (which acts as category
  /// in the Figma design — e.g. "English", "Spanish" under Languages).
  static Map<String, List<ExamModel>> examsGroupedByTitle(String subjectId) {
    final subjectExams = examsForSubject(subjectId);
    final grouped = <String, List<ExamModel>>{};
    for (final exam in subjectExams) {
      grouped.putIfAbsent(exam.title, () => []).add(exam);
    }
    return grouped;
  }
}
