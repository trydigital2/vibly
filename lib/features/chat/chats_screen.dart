import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/vibly_avatar.dart';
import '../../data/models/match_item.dart';
import '../../data/repositories/vibly_repository.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(matchesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Messages',
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SafeArea(
        child: matches.isEmpty
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
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Conversations Yet',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Swipe right on people you like to start matching!',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                slivers: [
                  // New Matches Story Row
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                          child: Row(
                            children: [
                              Text(
                                'New Matches',
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppGradients.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${matches.length}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 106,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: matches.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final m = matches[index];
                              return GestureDetector(
                                onTap: () => context.push('/chat/${m.id}'),
                                child: Column(
                                  children: [
                                    ViblyAvatar(
                                      imageUrl: m.user.photos.first,
                                      radius: 30,
                                      hasStoryRing: true,
                                      isOnline: m.isOnline,
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: 64,
                                      child: Text(
                                        m.user.name.split(' ').first,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.labelSmall.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Conversations List Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      child: Text(
                        'Recent Chats',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ),

                  // Chat Item Rows
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final m = matches[index];
                        return _buildChatListItem(context, m, isDark);
                      },
                      childCount: matches.length,
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
      ),
    );
  }

  Widget _buildChatListItem(BuildContext context, MatchItem match, bool isDark) {
    return InkWell(
      onTap: () => context.push('/chat/${match.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            ViblyAvatar(
              imageUrl: match.user.photos.first,
              radius: 28,
              isOnline: match.isOnline,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        match.user.name,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (match.user.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.accentCyan,
                          size: 16,
                        ),
                      ],
                      const Spacer(),
                      Text(
                        DateFormat('h:mm a').format(match.lastMessageTime),
                        style: AppTypography.labelSmall.copyWith(
                          color: match.unreadCount > 0
                              ? AppColors.primary
                              : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                          fontWeight: match.unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          match.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 14,
                            color: match.unreadCount > 0
                                ? (isDark ? AppColors.white : AppColors.textPrimaryLight)
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            fontWeight: match.unreadCount > 0 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (match.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            gradient: AppGradients.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${match.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
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

