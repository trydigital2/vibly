import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  // Signature Vibly Gradient (Coral Pink -> Purple)
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle background glow
  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFFFF5B78),
      Color(0xFFB549B8),
      Color(0xFF7557F7),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Card Overlay Gradient for text readability
  static const LinearGradient cardOverlay = LinearGradient(
    colors: [
      Colors.transparent,
      Colors.transparent,
      Color(0x33000000),
      Color(0xCC000000),
      Color(0xEE000000),
    ],
    stops: [0.0, 0.45, 0.65, 0.88, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Like / Match Button Gradient
  static const LinearGradient match = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Super Like Gradient
  static const LinearGradient superLike = LinearGradient(
    colors: [Color(0xFF00C2FF), Color(0xFF0072FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Story / Avatar active ring gradient
  static const SweepGradient avatarRing = SweepGradient(
    colors: [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accentCyan,
      AppColors.primary,
    ],
  );

  // Soft glass highlight
  static const LinearGradient glassSurface = LinearGradient(
    colors: [
      Color(0x2AFFFFFF),
      Color(0x0EFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

