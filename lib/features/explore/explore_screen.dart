import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/interest_chip.dart';
import '../../core/widgets/vibly_avatar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/social_post.dart';
import '../../data/repositories/vibly_repository.dart';
import 'widgets/comments_sheet.dart';
import 'widgets/create_post_sheet.dart';
import 'widgets/post_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String _activeTag = 'All';

  final List<String> _trendingTags = [
    'All',
    '#WeekendVibes',
    '#ArtStudio',
    '#Coffee',
    '#SunsetLovers',
    '#OutdoorLife',
    '#IndieMusic',
  ];

  void _openCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreatePostSheet(),
    );
  }

  void _openComments(SocialPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(post: post),
    );
  }

  void _sharePost(SocialPost post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vibly link copied! Share "${post.authorName}\'s post" with friends.'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(socialPostsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredPosts = _activeTag == 'All'
        ? posts
        : posts.where((p) {
            final tagClean = _activeTag.replaceAll('#', '').toLowerCase();
            return p.tags.any((t) => t.toLowerCase().contains(tagClean));
          }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Explore Feed',
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openCreatePost,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            tooltip: 'Share a Vibe',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(milliseconds: 500)),
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // Stories Row
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                      child: Text(
                        'Vibe Spotlights',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 104,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        children: [
                          // Your story / Add story
                          _buildStoryItem(
                            imageUrl: MockData.currentUser.photos.first,
                            name: 'Your Vibe',
                            isMe: true,
                            isDark: isDark,
                            onTap: _openCreatePost,
                          ),
                          ...MockData.discoverProfiles.map(
                            (p) => _buildStoryItem(
                              imageUrl: p.photos.first,
                              name: p.name.split(' ').first,
                              isMe: false,
                              isDark: isDark,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Viewing ${p.name}\'s Vibe Story! ✨'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Trending Interests Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _trendingTags.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final tag = _trendingTags[index];
                        final isSelected = _activeTag == tag;
                        return InterestChip(
                          label: tag,
                          isSelected: isSelected,
                          onTap: () => setState(() => _activeTag = tag),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Social Posts List
              if (filteredPosts.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.feed_outlined, size: 52, color: AppColors.textSecondaryLight),
                        const SizedBox(height: 12),
                        Text(
                          'No posts in this category yet',
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = filteredPosts[index];
                      return PostCard(
                        post: post,
                        onLike: () {
                          ref.read(socialPostsProvider.notifier).toggleLike(post.id);
                        },
                        onComment: () => _openComments(post),
                        onShare: () => _sharePost(post),
                      );
                    },
                    childCount: filteredPosts.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryItem({
    required String imageUrl,
    required String name,
    required bool isMe,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Stack(
              children: [
                ViblyAvatar(
                  imageUrl: imageUrl,
                  radius: 30,
                  hasStoryRing: true,
                ),
                if (isMe)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.bgDark : AppColors.bgLight,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 68,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 