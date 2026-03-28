import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/vibly_avatar.dart';
import '../../../core/widgets/vibly_button.dart';
import '../../../data/models/user_profile.dart';

class MatchDialog extends StatelessWidget {
  final UserProfile matchedUser;
  final UserProfile currentUser;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

  const MatchDialog({
    super.key,
    required this.matchedUser,
    required this.currentUser,
    required this.onSendMessage,
    required this.onKeepSwiping,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF161420),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating match stars
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accentAmber,
              size: 32,
            ).animate().scale(duration: 400.ms),

            const SizedBox(height: 8),

            // It's a Match Header
            ShaderMask(
              shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
              child: Text(
                "It's a Match!",
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                ),
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),

            const SizedBox(height: 8),
            Text(
              'You and ${matchedUser.name} vibed with each other!',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 32),

            // Two Avatars Intersecting
            SizedBox(
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 45,
                    child: ViblyAvatar(
                      imageUrl: currentUser.photos.first,
                      radius: 46,
                      hasStoryRing: true,
                    ).animate().slideX(begin: -0.3, end: 0, duration: 600.ms),
                  ),
                  Positioned(
                    right: 45,
                    child: ViblyAvatar(
                      imageUrl: matchedUser.photos.first,
                      radius: 46,
                      hasStoryRing: true,
                    ).animate().slideX(begin: 0.3, end: 0, duration: 600.ms),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ).animate().scale(delay: 300.ms, duration: 500.ms, curve: Curves.elasticOut),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Send Message Button
            ViblyPrimaryButton(
              text: 'Say Hello to ${matchedUser.name}',
              icon: Icons.chat_bubble_rounded,
              onPressed: onSendMessage,
            ),

            const SizedBox(height: 14),

            // Keep Swiping Button
            TextButton(
              onPressed: onKeepSwiping,
              child: Text(
                'Keep Swiping',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

