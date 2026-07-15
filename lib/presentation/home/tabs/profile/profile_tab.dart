import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Profile tab — placeholder for Step 8 implementation.
///
/// Will display user info from `GET /auth/profileData`.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          'Profile will appear here',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray,
          ),
        ),
      ),
    );
  }
}
