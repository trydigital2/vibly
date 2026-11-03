import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_typography.dart';
import '../../data/repositories/vibly_repository.dart';
import '../chat/chats_screen.dart';
import '../discover/discover_screen.dart';
import '../explore/explore_screen.dart';
import '../likes/likes_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  final List<Widget> _screens = const [
    DiscoverScreen(),
    ExploreScreen(),
    LikesScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(selectedTabProvider);
    final likesCount = ref.watch(likesProvider).length;
    final matches = ref.watch(matchesProvider);
    final unreadChats = matches.fold<int>(0, (sum, m) => sum + m.unreadCount);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          height: 68,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.cardDark : Colors.white).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.8),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    currentIndex: currentIndex,
                    icon: Icons.local_fire_department_rounded,
                    label: 'Discover',
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 1,
                    currentIndex: currentIndex,
                    icon: Icons.explore_rounded,
                    label: 'Explore',
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 2,
                    currentIndex: currentIndex,
                    icon: Icons.favorite_rounded,
                    label: 'Likes',
                    badgeCount: likesCount,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 3,
                    currentIndex: currentIndex,
                    icon: Icons.chat_bubble_rounded,
                    label: 'Chats',
                    badgeCount: unreadChats,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 4,
                    currentIndex: currentIndex,
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    int badgeCount = 0,
    required bool isDark,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(selectedTabProvider.notifier).state = index;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                  ),
                ),
              ],
            ),

            // Badge
            if (badgeCount > 0)
              Positioned(
                top: -2,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Center(
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

