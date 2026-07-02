import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shadow tokens.
///
/// No dedicated elevation/shadow spec exists on the Figma "Design system"
/// page yet — these are conservative Material-style defaults, kept as a
/// single place to update once a shadow style is confirmed in the design.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: AppColors.black.withValues(alpha: 0.05),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}
