import '../../data/models/exam_model.dart';
import '../../data/models/exam_result_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/subject_model.dart';

/// Type-safe route arguments — eliminates raw Map<String, dynamic> casts.

class SubjectExamsArgs {
  final SubjectModel subject;
  const SubjectExamsArgs({required this.subject});
}

class StartExamArgs {
  final ExamModel exam;
  final SubjectModel subject;
  const StartExamArgs({required this.exam, required this.subject});
}

class ExamSessionArgs {
  final ExamModel exam;
  final SubjectModel subject;
  final List<QuestionModel> questions;
  const ExamSessionArgs({
    required this.exam,
    required this.subject,
    required this.questions,
  });
}

class ExamResultArgs {
  final ExamResultModel result;
  const ExamResultArgs({required this.result});
}

/// Auth flow: email passed through forget → verify → reset chain.
class VerificationCodeArgs {
  final String email;
  const VerificationCodeArgs({required this.email});
}

class ResetPasswordArgs {
  final String email;
  const ResetPasswordArgs({required this.email});
}
