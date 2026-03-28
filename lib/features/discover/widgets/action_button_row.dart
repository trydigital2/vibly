import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';

class ActionButtonRow extends StatelessWidget {
  final VoidCallback onRewind;
  final VoidCallback onPass;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onBoost;

  const ActionButtonRow({
    super.key,
    required this.onRewind,
    required this.onPass,
    required this.onSuperLike,
    required this.onLike,
    required this.onBoost,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rewind Button
        _buildCircleButton(
          size: 46,
          icon: Icons.replay_rounded,
          iconColor: const Color(0xFFF59E0B),
          onTap: onRewind,
          isDark: isDark,
          tooltip: 'Rewind',
        ),

        // Pass / Dislike Button
        _buildCircleButton(
          size: 60,
          icon: Icons.close_rounded,
          iconColor: AppColors.error,
          onTap: onPass,
          isDark: isDark,
          tooltip: 'Pass',
          iconSize: 32,
        ),

        // Super Like Button
        _buildCircleButton(
          size: 50,
          icon: Icons.star_rounded,
          iconColor: AppColors.accentCyan,
          onTap: onSuperLike,
          isDark: isDark,
          tooltip: 'Super Like',
          iconSize: 28,
        ),

        // Like Button (Gradient)
        _buildGradientCircleButton(
          size: 64,
          icon: Icons.favorite_rounded,
          gradient: AppGradients.primary,
          onTap: onLike,
          tooltip: 'Like',
          iconSize: 34,
        ),

        // Boost / Info Button
        _buildCircleButton(
          size: 46,
          icon: Icons.bolt_rounded,
          iconColor: AppColors.secondary,
          onTap: onBoost,
          isDark: isDark,
          tooltip: 'Boost',
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required double size,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDark,
    required String tooltip,
    double iconSize = 22,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: iconSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCircleButton({
    required double size,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    required String tooltip,
    double iconSize = 28,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.38),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: iconSize),
            ),
          ),
        ),
      ),
    );
  }
}

