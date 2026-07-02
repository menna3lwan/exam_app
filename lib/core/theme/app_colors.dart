import 'package:flutter/material.dart';

/// Design tokens extracted directly from the Figma file
/// ("Online exam (Copy)" → page "Design system" → frame "Colors").
///
/// Every hex value below was read from that frame's Dev-mode color
/// inspector, not guessed. If the Figma palette changes, update this file
/// only — nothing else in the app should hardcode a color.
class AppColors {
  AppColors._();

  // ---- Primary (Blue) ----
  static const Color primary = Color(0xFF02369C); // Blue / base
  static const Color primary10 = Color(0xFFCCD7EB);
  static const Color primary20 = Color(0xFFABBCDE);
  static const Color primary30 = Color(0xFF819BCE);
  static const Color primary40 = Color(0xFF5679BD);
  static const Color primary50 = Color(0xFF2C58AD);
  static const Color primary60 = Color(0xFF022D82);
  static const Color primary70 = Color(0xFF012468);
  static const Color primary80 = Color(0xFF011B4E);
  static const Color primary90 = Color(0xFF011234);
  static const Color primary100 = Color(0xFF000B1F);

  // ---- Neutral / Black scale ----
  static const Color black = Color(0xFF0F0F0F); // Black / base
  static const Color black10 = Color(0xFFCFCFCF);
  static const Color black20 = Color(0xFFAFAFAF);
  static const Color black30 = Color(0xFF878787);
  static const Color black40 = Color(0xFF5F5F5F);
  static const Color black50 = Color(0xFF373737);
  static const Color black60 = Color(0xFF0D0D0D);
  static const Color black70 = Color(0xFF0A0A0A);
  static const Color black80 = Color(0xFF080808);
  static const Color black90 = Color(0xFF050505);
  static const Color black100 = Color(0xFF030303);

  // ---- Standalone tokens ----
  static const Color white = Color(0xFFF9F9F9);
  static const Color gray = Color(0xFF535353);
  static const Color error = Color(0xFFCC1010);
  static const Color success = Color(0xFF11CE19);
  static const Color lightBlue = Color(0xFFEDEFF3);
  static const Color lightGreen = Color(0xFFCAF9CC);
  static const Color lightRed = Color(0xFFF8D2D2);
  static const Color placeholder = Color(0xFFA6A6A6);
}
