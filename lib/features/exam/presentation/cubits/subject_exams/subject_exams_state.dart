import '../../../../../data/models/exam_model.dart';
import '../../../../../data/models/subject_model.dart';

sealed class SubjectExamsState {
  const SubjectExamsState();
}

class SubjectExamsInitial extends SubjectExamsState {
  const SubjectExamsInitial();
}

class SubjectExamsLoading extends SubjectExamsState {
  const SubjectExamsLoading();
}

class SubjectExamsLoaded extends SubjectExamsState {
  final SubjectModel subject;
  final List<ExamModel> exams;
  const SubjectExamsLoaded({required this.subject, required this.exams});
}

class SubjectExamsError extends SubjectExamsState {
  final String message;
  const SubjectExamsError(this.message);
}
