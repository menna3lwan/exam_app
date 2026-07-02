import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography tokens.
///
/// Font family and a few concrete size/weight pairs were read directly off
/// real text layers in the Figma file (not the bundled Material 3 kit
/// components, which don't reflect the app's actual type choices):
///   - App bar title  → Inter, weight 500 (Medium), 20px
///   - Button label   → Inter, weight 500 (Medium), 16px (Figma text style
///                       "Label Large")
///   - Form label/body→ Inter, weight 400 (Regular), 13px
///
/// The remaining sizes below fill in a standard Material 3 type scale using
/// the same font so every widget has a token to reach for; treat those as
/// provisional until more screens are reviewed, and adjust here only.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _inter({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.black,
    double? height,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Confirmed from Figma
  static TextStyle titleLarge = _inter(fontSize: 20, fontWeight: FontWeight.w500); // app bar title
  static TextStyle labelLarge = _inter(fontSize: 16, fontWeight: FontWeight.w500); // button label
  static TextStyle bodySmall = _inter(fontSize: 13, fontWeight: FontWeight.w400); // form labels

  // Provisional — fill out the rest of the M3 scale with the same font
  static TextStyle headlineLarge = _inter(fontSize: 32, fontWeight: FontWeight.w600);
  static TextStyle headlineMedium = _inter(fontSize: 28, fontWeight: FontWeight.w600);
  static TextStyle headlineSmall = _inter(fontSize: 24, fontWeight: FontWeight.w600);
  static TextStyle titleMedium = _inter(fontSize: 18, fontWeight: FontWeight.w500);
  static TextStyle titleSmall = _inter(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle bodyLarge = _inter(fontSize: 16, fontWeight: FontWeight.w400);
  static TextStyle bodyMedium = _inter(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle labelMedium = _inter(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle labelSmall = _inter(fontSize: 12, fontWeight: FontWeight.w500);
}
