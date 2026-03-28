import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/interest_chip.dart';
import '../../../core/widgets/vibly_button.dart';
import '../../../data/models/user_profile.dart';

class ProfileDetailModal extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onLike;
  final VoidCallback onPass;

  const ProfileDetailModal({
    super.key,
    required this.profile,
    required this.onLike,
    required this.onPass,
  });

  @override
  State<ProfileDetailModal> createState() => _ProfileDetailModalState();
}

class _ProfileDetailModalState extends State<ProfileDetailModal> {
  final PageController _photoController = PageController();
  int _activePhotoIndex = 0;

  @override
  void dispose() {
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = widget.profile;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Carousel
                Stack(
                  children: [
                    SizedBox(
                      height: 420,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _photoController,
                        itemCount: p.photos.length,
                        onPageChanged: (idx) => setState(() => _activePhotoIndex = idx),
                        itemBuilder: (context, idx) {
                          return CachedNetworkImage(
                            imageUrl: p.photos[idx],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          );
                        },
                      ),
                    ),

                    // Top Gradient & Indicators
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: List.generate(
                          p.photos.length,
                          (i) => Expanded(
                            child: Container(
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: _activePhotoIndex == i
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Close Button
                    Positioned(
                      top: 32,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),

                // Profile Details
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Age Row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  '${p.name}, ${p.age}',
                                  style: AppTypography.displayMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 26,
                                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                                if (p.isVerified) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: AppColors.accentCyan,
                                    size: 24,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Compatibility Score Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: AppGradients.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${p.compatibilityScore}% Match',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Location & Distance
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${p.location} • ${p.distanceKm.toStringAsFixed(1)} km away',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Bio
                      Text(
                        'About Me',
                        style: AppTypography.titleMedium.copyWith(
                          color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.bio,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 15,
                          height: 1.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Info Chips (Occupation, Education, Intentions)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildDetailChip(Icons.work_outline_rounded, p.occupation, isDark),
                          if (p.education != null)
                            _buildDetailChip(Icons.school_outlined, p.education!, isDark),
                          _buildDetailChip(Icons.favorite_outline_rounded, p.intention, isDark),
                          if (p.height != null)
                            _buildDetailChip(Icons.height_rounded, p.height!, isDark),
                          if (p.zodiac != null)
                            _buildDetailChip(Icons.nightlight_outlined, p.zodiac!, isDark),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Passions / Interests
                      Text(
                        'Passions',
                        style: AppTypography.titleMedium.copyWith(
                          color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: p.interests
                            .map((tag) => InterestChip(label: tag, isGradient: false))
                            .toList(),
                      ),

                      const SizedBox(height: 28),

                      // Prompts Cards
                      if (p.prompts.isNotEmpty) ...[
                        Text(
                          'Conversations Starters',
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...p.prompts.entries.map((entry) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: AppTypography.labelLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  entry.value,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 15,
                                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Actions
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Row(
              children: [
                Expanded(
                  child: ViblySecondaryButton(
                    text: 'Pass',
                    icon: Icons.close_rounded,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onPass();
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ViblyPrimaryButton(
                    text: 'Like',
                    icon: Icons.favorite_rounded,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onLike();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

