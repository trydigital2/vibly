import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_typography.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/vibly_repository.dart';
import '../discover/widgets/match_dialog.dart';

class LikesScreen extends ConsumerStatefulWidget {
  const LikesScreen({super.key});

  @override
  ConsumerState<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends ConsumerState<LikesScreen> {
  void _onMatchBack(UserProfile user) {
    ref.read(likesProvider.notifier).removeLike(user.id);
    ref.read(matchesProvider.notifier).addMatch(user);

    final currentUser = ref.read(currentUserProvider);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => MatchDialog(
        matchedUser: user,
        currentUser: currentUser,
        onSendMessage: () {
          Navigator.pop(ctx);
          final matches = ref.read(matchesProvider);
          final match = matches.firstWhere((m) => m.user.id == user.id);
          context.push('/chat/${match.id}');
        },
        onKeepSwiping: () => Navigator.pop(ctx),
      ),
    );
  }

  void _onPass(UserProfile user) {
    ref.read(likesProvider.notifier).removeLike(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final likes = ref.watch(likesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Likes',
              style: AppTypography.displayMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${likes.length}',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: likes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No New Likes Yet',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Keep discovering or boost your profile to get more vibes!',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(selectedTabProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 18),
                      label: const Text(
                        'Discover People',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        'People who liked your profile. Like them back to start chatting!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = likes[index];
                          return _buildLikeCard(user, isDark);
                        },
                        childCount: likes.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLikeCard(UserProfile user, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo
            CachedNetworkImage(
              imageUrl: user.photos.first,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              ),
            ),

            // Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cardOverlay,
              ),
            ),

            // Top Compatibility Tag
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.accentAmber, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '${user.compatibilityScore}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom User info & Action Buttons
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${user.name}, ${user.age}',
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.occupation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Actions: Pass & Match Back
                  Row(
                    children: [
                      // Pass Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onPass(user),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Match Back Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onMatchBack(user),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primary,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
