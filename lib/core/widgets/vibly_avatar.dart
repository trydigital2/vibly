import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';

class ViblyAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool hasStoryRing;
  final bool isOnline;
  final VoidCallback? onTap;

  const ViblyAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 28,
    this.hasStoryRing = false,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.primary.withValues(alpha: 0.1),
          child: const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.primary.withValues(alpha: 0.15),
          child: Icon(
            Icons.person,
            size: radius * 0.9,
            color: AppColors.primary,
          ),
        ),
      ),
    );

    if (hasStoryRing) {
      avatarWidget = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.primary,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: avatarWidget,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          if (isOnline)
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: radius * 0.45,
                height: radius * 0.45,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

 