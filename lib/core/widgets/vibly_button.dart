import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../constants/app_typography.dart';

class ViblyPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final Gradient? gradient;

  const ViblyPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 54,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? const LinearGradient(
                colors: [Color(0xFFCCCCCC), Color(0xFFB0B0B0)],
              )
            : (gradient ?? AppGradients.primary),
        borderRadius: BorderRadius.circular(28),
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.32),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ViblySecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? borderColor;

  const ViblySecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 54,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = borderColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight);

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border, width: 1.5),
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

 