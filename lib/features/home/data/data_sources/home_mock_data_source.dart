import '../../../../core/constants/app_assets.dart';
import '../../../../data/models/subject_model.dart';
import 'home_data_source.dart';

/// Mock data source for home/explore.
///
/// Subjects match the Figma "Explore" screen exactly.
/// Retained for testing; production uses [HomeRemoteDataSource].
class HomeMockDataSource implements HomeDataSource {
  static const _mockDelay = Duration(milliseconds: 400);

  @override
  Future<List<SubjectModel>> getSubjects() async {
    await Future.delayed(_mockDelay);
    return _subjects;
  }

  static const _subjects = [
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
}
