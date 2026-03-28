import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/vibly_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: AppStrings.onb1Title,
      description: AppStrings.onb1Desc,
      icon: Icons.explore_rounded,
      badgeText: 'Nearby Vibes',
      gradient: const LinearGradient(
        colors: [Color(0xFFFF5B78), Color(0xFFFF8E53)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      illustrationType: 0,
    ),
    OnboardingItem(
      title: AppStrings.onb2Title,
      description: AppStrings.onb2Desc,
      icon: Icons.auto_awesome_rounded,
      badgeText: '96% Vibe Match',
      gradient: AppGradients.primary,
      illustrationType: 1,
    ),
    OnboardingItem(
      title: AppStrings.onb3Title,
      description: AppStrings.onb3Desc,
      icon: Icons.chat_bubble_rounded,
      badgeText: 'Real Conversations',
      gradient: const LinearGradient(
        colors: [Color(0xFF7557F7), Color(0xFF2C73D2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      illustrationType: 2,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _onSkip() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: AppTypography.labelLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView Area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Visual Illustration Card
                        _buildIllustrationCard(item, isDark),
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayMedium.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 14),

                        // Description
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Section: Dots & Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  // Smooth Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : (isDark ? AppColors.surfaceDark : AppColors.borderLight),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Button
                  ViblyPrimaryButton(
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                    icon: _currentPage == _pages.length - 1
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustrationCard(OnboardingItem item, bool isDark) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: item.gradient.colors.first.withValues(alpha: 0.18),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Gradient Blob
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: item.gradient,
              boxShadow: [
                BoxShadow(
                  color: item.gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                item.icon,
                size: 80,
                color: Colors.white,
              ),
            ),
          ).animate().scale(
                duration: 600.ms,
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),

          // Floating Vibe Badge
          Positioned(
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.badgeText,
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.4, end: 0, duration: 500.ms).fadeIn(),
          ),

          // Floating mini heart chip
          Positioned(
            top: 28,
            right: 28,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final String badgeText;
  final LinearGradient gradient;
  final int illustrationType;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.badgeText,
    required this.gradient,
    required this.illustrationType,
  });
}

