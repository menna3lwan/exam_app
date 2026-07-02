/// Spacing scale used across paddings/margins/gaps.
///
/// The 4/8/16/24 rhythm below matches the paddings observed on the Figma
/// "Login" screen components (e.g. text field padding 16, button padding
/// 10/24, gaps 8/10/24).
class AppDimensions {
  AppDimensions._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Common component heights seen in the Figma file
  static const double inputHeight = 56;
  static const double buttonHeight = 48;
}
