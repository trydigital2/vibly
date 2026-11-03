import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/interest_chip.dart';
import '../../../core/widgets/vibly_avatar.dart';
import '../../../core/widgets/vibly_text_field.dart';
import '../../../data/repositories/vibly_repository.dart';

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({super.key});

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  static const int _maxChars = 280;
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(text: 'Brooklyn, NY');
  String? _selectedImageUrl;
  final Set<String> _selectedTags = {'WeekendVibes'};

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() => setState(() {}));
  }

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1000&q=80',
  ];

  @override
  void dispose() {
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onPublish() {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something to share!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ref.read(socialPostsProvider.notifier).addPost(
          text,
          imageUrl: _selectedImageUrl,
          tags: _selectedTags.toList(),
          location: _locationController.text.trim(),
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post published to Vibly Explore! ✨'),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                Text(
                  'Share a Vibe',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                ),
                TextButton(
                  onPressed: _contentController.text.trim().isEmpty ? null : _onPublish,
                  child: Text(
                    'Post',
                    style: AppTypography.labelLarge.copyWith(
                      color: _contentController.text.trim().isEmpty
                          ? (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)
                          : AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      ViblyAvatar(imageUrl: currentUser.photos.first, radius: 22),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser.name,
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            'Sharing with Vibly Community',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Content input
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    maxLength: _maxChars,
                    buildCounter: (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) {
                      final isNearLimit = currentLength > 240;
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '$currentLength / $maxLength',
                          style: AppTypography.labelSmall.copyWith(
                            color: isNearLimit
                                ? AppColors.error
                                : (isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight),
                            fontWeight: isNearLimit ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      );
                    },
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'What are you experiencing, listening to, or up to today?',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  ViblyTextField(
                    controller: _locationController,
                    hintText: 'Add location',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),

                  // Sample photo selector
                  Text(
                    'Add Photo (Optional)',
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sampleImages.length,
                      itemBuilder: (context, index) {
                        final img = _sampleImages[index];
                        final isSelected = _selectedImageUrl == img;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImageUrl = isSelected ? null : img;
                            });
                          },
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                width: 2.5,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(img),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.check_circle, color: AppColors.primary),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hashtags
                  Text(
                    'Add Vibe Tags',
                    style: AppTypography.labelLarge.copyWith(
                      color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'WeekendVibes',
                      'CoffeeMoments',
                      'MusicLovers',
                      'Outdoors',
                      'ArtVibe',
                      'Nightlife',
                    ].map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return InterestChip(
                        label: '#$tag',
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTags.remove(tag);
                            } else {
                              _selectedTags.add(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
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
