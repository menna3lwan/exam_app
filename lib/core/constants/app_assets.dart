/// Central asset-path registry so no widget ever hardcodes a path string.
///
/// Folders are created and declared in `pubspec.yaml` (Phase 1), but no
/// actual image/icon files have been provided yet — this file is a mapping
/// skeleton to fill in as assets arrive.
class AppAssets {
  AppAssets._();

  static const String imagesDir = 'assets/images';
  static const String iconsDir = 'assets/icons';
  static const String filesDir = 'assets/files';

  // Example placeholders — replace/extend once real assets are supplied:
  // static const String logo = '$imagesDir/logo.png';
  // static const String splashBackground = '$imagesDir/splash_bg.png';
}
