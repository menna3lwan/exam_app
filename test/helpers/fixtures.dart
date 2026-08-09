// Shared sample model instances used across multiple test files.
//
// Centralizing these avoids each test file inventing slightly different
// fake data (which tends to hide bugs when, say, one test's "exam" has
// numberOfQuestions that doesn't match its own questions list).
import 'package:exam_app/data/models/exam_model.dart';
import 'package:exam_app/data/models/question_model.dart';
import 'package:exam_app/data/models/subject_model.dart';
import 'package:exam_app/features/auth/data/models/user_model.dart';

final testUser = UserModel(
  id: 'user-1',
  username: 'testuser',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@test.com',
  phone: '01012345678',
  role: 'user',
  isVerified: true,
);

const testSubject = SubjectModel(
  id: 'subject-1',
  name: 'JavaScript',
  icon: 'https://example.com/icon.png',
);

const testExam = ExamModel(
  id: 'exam-1',
  title: 'JS Basics',
  duration: 20, // minutes
  subject: 'subject-1',
  numberOfQuestions: 3,
);

/// 3 questions, each with a distinct correct key — convenient for
/// constructing "all correct" / "all wrong" / "partial" answer maps.
final testQuestions = [
  const QuestionModel(
    id: 'q1',
    question: 'Q1?',
    a1: 'opt A1',
    a2: 'opt A2',
    a3: 'opt A3',
    a4: 'opt A4',
    correct: 'A1',
    subjectId: 'subject-1',
    examId: 'exam-1',
  ),
  const QuestionModel(
    id: 'q2',
    question: 'Q2?',
    a1: 'opt A1',
    a2: 'opt A2',
    a3: 'opt A3',
    a4: 'opt A4',
    correct: 'A2',
    subjectId: 'subject-1',
    examId: 'exam-1',
  ),
  const QuestionModel(
    id: 'q3',
    question: 'Q3?',
    a1: 'opt A1',
    a2: 'opt A2',
    a3: 'opt A3',
    a4: 'opt A4',
    correct: 'A3',
    subjectId: 'subject-1',
    examId: 'exam-1',
  ),
];
