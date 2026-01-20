import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../constants/app_typography.dart';

class ViblyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double fontSize;
  final Color? textColor;

  const ViblyLogo({
    super.key,
    this.size = 56,
    this.showText = true,
    this.fontSize = 28,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = textColor ?? (isDark ? AppColors.white : AppColors.textPrimaryLight);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Custom Logo Mark
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: size * 0.4,
                offset: Offset(0, size * 0.15),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: size * 0.54,
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.22),
          Text.rich(
            TextSpan(
              text: 'Vibly',
              style: AppTypography.displayLarge.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: textCol,
                letterSpacing: -0.5,
              ),
              children: const [
                TextSpan(
                  text: '•',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

 