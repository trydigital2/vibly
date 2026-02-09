import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/vibly_logo.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/vibly_repository.dart';
import 'widgets/action_button_row.dart';
import 'widgets/filter_modal.dart';
import 'widgets/match_dialog.dart';
import 'widgets/profile_detail_modal.dart';
import 'widgets/swipeable_card_stack.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final GlobalKey<SwipeableCardStackState> _stackKey = GlobalKey<SwipeableCardStackState>();

  void _onSwipeLeft(UserProfile user) {
    ref.read(discoverProfilesProvider.notifier).swipeLeft(user.id);
  }

  void _onSwipeRight(UserProfile user) {
    final isMatch = ref.read(discoverProfilesProvider.notifier).swipeRight(user.id);
    if (isMatch) {
      ref.read(matchesProvider.notifier).addMatch(user);
      _showMatchCelebration(user);
    }
  }

  void _onSuperLike(UserProfile user) {
    ref.read(discoverProfilesProvider.notifier).superLike(user.id);
    ref.read(matchesProvider.notifier).addMatch(user);
    _showMatchCelebration(user);
  }

  void _showMatchCelebration(UserProfile matchedUser) {
    final currentUser = ref.read(currentUserProvider);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => MatchDialog(
        matchedUser: matchedUser,
        currentUser: currentUser,
        onSendMessage: () {
          Navigator.pop(ctx);
          // Route to chats tab or detail
          final matches = ref.read(matchesProvider);
          final match = matches.firstWhere(
            (m) => m.user.id == matchedUser.id,
            orElse: () => matches.first,
          );
          context.push('/chat/${match.id}');
        },
        onKeepSwiping: () => Navigator.pop(ctx),
      ),
    );
  }

  void _openDetail(UserProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileDetailModal(
        profile: profile,
        onLike: () {
          _onSwipeRight(profile);
        },
        onPass: () {
          _onSwipeLeft(profile);
        },
      ),
    );
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterModal(),
    );
  }

  void _onBoost() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.bolt_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Vibly Boost activated! Your profile is now top 1 in Brooklyn for 30 mins!'),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(discoverProfilesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const ViblyLogo(size: 36, fontSize: 22),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
            onPressed: _openFilters,
            tooltip: 'Discovery Preferences',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Swipeable Card Stack Area
            Expanded(
              child: SwipeableCardStack(
                key: _stackKey,
                profiles: profiles,
                onSwipeLeft: _onSwipeLeft,
                onSwipeRight: _onSwipeRight,
                onSuperLike: _onSuperLike,
                onOpenDetail: _openDetail,
                onRefresh: () => ref.read(discoverProfilesProvider.notifier).reset(),
              ),
            ),

            // Bottom Action Button Row
            if (profiles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 4),
                child: ActionButtonRow(
                  onRewind: () => ref.read(discoverProfilesProvider.notifier).rewind(),
                  onPass: () => _stackKey.currentState?.swipeLeftProgrammatic(),
                  onSuperLike: () => _stackKey.currentState?.superLikeProgrammatic(),
                  onLike: () => _stackKey.currentState?.swipeRightProgrammatic(),
                  onBoost: _onBoost,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
 