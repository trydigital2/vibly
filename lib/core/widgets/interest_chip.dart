import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../constants/app_typography.dart';

class InterestChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isGradient;

  const InterestChip({
    super.key,
    required this.label,
    this.emoji,
    this.isSelected = false,
    this.onTap,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration;
    TextStyle textStyle;

    if (isSelected || isGradient) {
      decoration = BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
      textStyle = AppTypography.labelLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      );
    } else {
      decoration = BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      );
      textStyle = AppTypography.labelLarge.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      );
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
        ],
        Text(label, style: textStyle),
      ],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: decoration,
        child: content,
      ),
    );
  }
}

