import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../utils/validators.dart';

/// Displays password requirements as a checklist that updates in real time.
///
/// Each rule shows a green check when satisfied, a gray circle when not yet
/// attempted, keeping the UI encouraging rather than punitive.
class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final hasStarted = password.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequirementRow(
          label: 'At least 6 characters',
          passed: PasswordRules.hasMinLength(password),
          active: hasStarted,
        ),
        const SizedBox(height: AppDimensions.xs),
        _RequirementRow(
          label: 'One uppercase letter (A-Z)',
          passed: PasswordRules.hasUpperCase(password),
          active: hasStarted,
        ),
        const SizedBox(height: AppDimensions.xs),
        _RequirementRow(
          label: 'One lowercase letter (a-z)',
          passed: PasswordRules.hasLowerCase(password),
          active: hasStarted,
        ),
        const SizedBox(height: AppDimensions.xs),
        _RequirementRow(
          label: 'One number (0-9)',
          passed: PasswordRules.hasDigit(password),
          active: hasStarted,
        ),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool passed;
  final bool active; // user has started typing

  const _RequirementRow({
    required this.label,
    required this.passed,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor;
    final IconData icon;

    if (!active) {
      // Not started yet — neutral
      iconColor = AppColors.gray;
      icon = Icons.circle_outlined;
    } else if (passed) {
      iconColor = AppColors.success;
      icon = Icons.check_circle;
    } else {
      iconColor = AppColors.error;
      icon = Icons.cancel;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: active && passed ? AppColors.success : AppColors.gray,
            ),
          ),
        ),
      ],
    );
  }
}
