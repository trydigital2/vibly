import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/vibly_avatar.dart';
import '../../../data/models/social_post.dart';

class PostCard extends StatelessWidget {
  final SocialPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ViblyAvatar(
                  imageUrl: post.authorAvatar,
                  radius: 22,
                  hasStoryRing: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (post.location != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 13, color: AppColors.primary),
                            const SizedBox(width: 3),
                            Text(
                              post.location!,
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  _formatTime(post.createdAt),
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Content Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.content,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.5,
                height: 1.45,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),

          // Image (if any)
          if (post.imageUrl != null) ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 260,
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],

          // Tags
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: post.tags.map((tag) {
                  return Text(
                    '#$tag',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),

          // Actions Row (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Like Button
                IconButton(
                  onPressed: onLike,
                  icon: Icon(
                    post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: post.isLiked ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    size: 22,
                  ),
                ),
                Text(
                  '${post.likesCount}',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(width: 16),

                // Comment Button
                IconButton(
                  onPressed: onComment,
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    size: 20,
                  ),
                ),
                Text(
                  '${post.commentsCount}',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                ),

                const Spacer(),

                // Share Button
                IconButton(
                  onPressed: onShare,
                  icon: Icon(
                    Icons.share_outlined,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return DateFormat('MMM d').format(dt);
    }
  }
}

