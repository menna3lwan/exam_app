import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

/// Single answer option card matching the Figma exam question screens.
///
/// Supports two modes based on [isMultiSelect]:
///   false → radio button (circle indicator) — single-select
///   true  → checkbox (square indicator) — multi-select
///
/// States:
///   Unselected: gray outline circle/square + text in bordered card
///   Selected:   filled blue circle/square + text in blue-tinted card
class AnswerOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const AnswerOptionCard({
    super.key,
    required this.text,
    required this.isSelected,
    this.isMultiSelect = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightBlue,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // ---- Indicator (radio or checkbox) ----
            _buildIndicator(),
            const SizedBox(width: AppDimensions.md),
            // ---- Option text ----
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    if (isMultiSelect) {
      return _buildCheckbox();
    }
    return _buildRadio();
  }

  Widget _buildRadio() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.gray,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Center(
              child: Icon(
                Icons.circle,
                size: 10,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.gray,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Center(
              child: Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
