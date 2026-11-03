import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/vibly_avatar.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/social_post.dart';

class CommentsSheet extends StatefulWidget {
  final SocialPost post;

  const CommentsSheet({super.key, required this.post});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<CommentItem> _comments = [
    CommentItem(
      userName: 'Chloe Dubois',
      userAvatar:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80',
      text: 'This is absolutely gorgeous! Love the textures 🏺✨',
      timeAgo: '1h ago',
      likeCount: 4,
    ),
    CommentItem(
      userName: 'Lucas Vance',
      userAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      text: 'Need one of these mugs for my camp brews!',
      timeAgo: '45m ago',
      likeCount: 2,
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onAddComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add(
        CommentItem(
          userName: MockData.currentUser.name,
          userAvatar: MockData.currentUser.photos.first,
          text: text,
          timeAgo: 'Just now',
        ),
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag handle & title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Comments (${_comments.length})',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Comments List
          Expanded(
            child: _comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 48,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No comments yet',
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Be the first to share your thoughts!',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final c = _comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ViblyAvatar(imageUrl: c.userAvatar, radius: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      c.userName,
                                      style: AppTypography.labelLarge.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      c.timeAgo,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  c.text,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                c.isLiked = !c.isLiked;
                                c.likeCount += c.isLiked ? 1 : -1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: Column(
                                children: [
                                  Icon(
                                    c.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 16,
                                    color: c.isLiked
                                        ? AppColors.primary
                                        : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                  ),
                                  if (c.likeCount > 0) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '${c.likeCount}',
                                      style: AppTypography.labelSmall.copyWith(
                                        fontSize: 10,
                                        color: c.isLiked
                                            ? AppColors.primary
                                            : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        filled: true,
                        fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _onAddComment,
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem {
  final String userName;
  final String userAvatar;
  final String text;
  final String timeAgo;
  bool isLiked;
  int likeCount;

  CommentItem({
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.timeAgo,
    this.isLiked = false,
    this.likeCount = 0,
  });
}

