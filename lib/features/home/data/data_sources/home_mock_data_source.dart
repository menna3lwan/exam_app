import '../../../../core/constants/app_assets.dart';
import '../../../../data/models/subject_model.dart';

/// Mock data source for home/explore.
///
/// Subjects match the Figma "Explore" screen exactly.
/// Will be replaced by a remote data source (Retrofit) in API phase.
class HomeMockDataSource {
  static const _mockDelay = Duration(milliseconds: 400);

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
