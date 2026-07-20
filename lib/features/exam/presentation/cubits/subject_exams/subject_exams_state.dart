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
  final Map<String, List<ExamModel>> groupedExams;
  const SubjectExamsLoaded({required this.subject, required this.groupedExams});
}

class SubjectExamsError extends SubjectExamsState {
  final String message;
  const SubjectExamsError(this.message);
}
