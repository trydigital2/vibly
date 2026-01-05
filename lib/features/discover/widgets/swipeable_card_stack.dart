import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/user_profile.dart';

class SwipeableCardStack extends StatefulWidget {
  final List<UserProfile> profiles;
  final Function(UserProfile) onSwipeLeft;
  final Function(UserProfile) onSwipeRight;
  final Function(UserProfile) onSuperLike;
  final Function(UserProfile) onOpenDetail;
  final VoidCallback onRefresh;

  const SwipeableCardStack({
    super.key,
    required this.profiles,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSuperLike,
    required this.onOpenDetail,
    required this.onRefresh,
  });

  @override
  State<SwipeableCardStack> createState() => SwipeableCardStackState();
}

class SwipeableCardStackState extends State<SwipeableCardStack>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  double _angle = 0.0;
  int _activePhotoIndex = 0;
  late AnimationController _animController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _animController.addListener(() {
      if (_slideAnimation != null) {
        setState(() {
          _dragOffset = _slideAnimation!.value;
          _angle = (_dragOffset.dx / 300) * (math.pi / 16);
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void swipeRightProgrammatic() {
    if (widget.profiles.isEmpty) return;
    _triggerSwipeAnimation(const Offset(500, 0), () {
      widget.onSwipeRight(widget.profiles.first);
    });
  }

  void swipeLeftProgrammatic() {
    if (widget.profiles.isEmpty) return;
    _triggerSwipeAnimation(const Offset(-500, 0), () {
      widget.onSwipeLeft(widget.profiles.first);
    });
  }

  void superLikeProgrammatic() {
    if (widget.profiles.isEmpty) return;
    _triggerSwipeAnimation(const Offset(0, -600), () {
      widget.onSuperLike(widget.profiles.first);
    });
  }

  void _triggerSwipeAnimation(Offset target, VoidCallback onCompleted) {
    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward(from: 0.0).then((_) {
      _dragOffset = Offset.zero;
      _angle = 0.0;
      _activePhotoIndex = 0;
      onCompleted();
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _angle = (_dragOffset.dx / 300) * (math.pi / 16);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.profiles.isEmpty) return;
    final user = widget.profiles.first;

    // Check Swipe Right
    if (_dragOffset.dx > 120) {
      _triggerSwipeAnimation(const Offset(500, 0), () => widget.onSwipeRight(user));
    }
    // Check Swipe Left
    else if (_dragOffset.dx < -120) {
      _triggerSwipeAnimation(const Offset(-500, 0), () => widget.onSwipeLeft(user));
    }
    // Check Super Like (Swipe Up)
    else if (_dragOffset.dy < -120) {
      _triggerSwipeAnimation(const Offset(0, -600), () => widget.onSuperLike(user));
    }
    // Spring back to center
    else {
      _slideAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _animController, curve: Curves.elasticOut));
      _animController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.primary,
                  size: 44,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No More Profiles Nearby',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You’ve seen all available vibes in your area! Expand your discovery preferences or refresh to see them again.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _activePhotoIndex = 0;
                  });
                  widget.onRefresh();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh Deck', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background Card (Next user)
            if (widget.profiles.length > 1)
              Transform.scale(
                scale: 0.94,
                child: Transform.translate(
                  offset: const Offset(0, 16),
                  child: _buildProfileCard(
                    widget.profiles[1],
                    isTopCard: false,
                    isDark: isDark,
                  ),
                ),
              ),

            // Top Card (Interactive Swiping)
            GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Transform.translate(
                offset: _dragOffset,
                child: Transform.rotate(
                  angle: _angle,
                  child: _buildProfileCard(
                    widget.profiles.first,
                    isTopCard: true,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard(UserProfile profile, {required bool isTopCard, required bool isDark}) {
    final photoUrl = isTopCard
        ? profile.photos[_activePhotoIndex.clamp(0, profile.photos.length - 1)]
        : profile.photos.first;

    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: isDark ? AppColors.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo Background
            CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                child: const Icon(Icons.broken_image, size: 48),
              ),
            ),

            // Gradient Overlay for Text Readability
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cardOverlay,
              ),
            ),

            // Tap photo left/right detector (Top card only)
            if (isTopCard && profile.photos.length > 1)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_activePhotoIndex > 0) {
                          setState(() => _activePhotoIndex--);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_activePhotoIndex < profile.photos.length - 1) {
                          setState(() => _activePhotoIndex++);
                        }
                      },
                    ),
                  ),
                ],
              ),

            // Top Photo Indicators
            if (isTopCard && profile.photos.length > 1)
              Positioned(
                top: 14,
                left: 16,
                right: 16,
                child: Row(
                  children: List.generate(
                    profile.photos.length,
                    (idx) => Expanded(
                      child: Container(
                        height: 3.5,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: _activePhotoIndex == idx
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Top Compatibility Pill & Verified Badge
            Positioned(
              top: 28,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.accentAmber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${profile.compatibilityScore}% Vibe Match',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stamp Badges that fade in as user drags
            if (isTopCard) ...[
              // LIKE Stamp
              Positioned(
                top: 50,
                left: 28,
                child: Opacity(
                  opacity: (_dragOffset.dx / 120).clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accentGreen, width: 3.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'LIKE',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // NOPE Stamp
              Positioned(
                top: 50,
                right: 28,
                child: Opacity(
                  opacity: (-_dragOffset.dx / 120).clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.error, width: 3.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'NOPE',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // SUPER LIKE Stamp
              Positioned(
                bottom: 180,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity: (-_dragOffset.dy / 120).clamp(0.0, 1.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.accentCyan, width: 3.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'SUPER LIKE',
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Card Bottom Details (Name, Age, Occupation, Location, Interests, Info)
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name, Age & Info Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '${profile.name}, ${profile.age}',
                              style: AppTypography.displayMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                              ),
                            ),
                            if (profile.isVerified) ...[
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

                      // Info button to view full modal
                      GestureDetector(
                        onTap: () => widget.onOpenDetail(profile),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Occupation & Location
                  Row(
                    children: [
                      const Icon(Icons.work_outline_rounded, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        profile.occupation,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('•', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '${profile.distanceKm.toStringAsFixed(1)} km away',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Bio Snippet
                  Text(
                    profile.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Passions / Interest chips preview
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: profile.interests.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          tag,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
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
