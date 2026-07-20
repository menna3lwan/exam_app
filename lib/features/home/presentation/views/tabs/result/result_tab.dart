import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

/// Result tab — placeholder for exam history.
class ResultTab extends StatelessWidget {
  const ResultTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          'Exam history will appear here',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray,
          ),
        ),
      ),
    );
  }
}
