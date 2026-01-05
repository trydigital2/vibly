import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/interest_chip.dart';
import '../../core/widgets/vibly_avatar.dart';
import '../../core/widgets/vibly_button.dart';
import '../../core/widgets/vibly_text_field.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/vibly_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _occupationController;
  late TextEditingController _companyController;
  late TextEditingController _educationController;
  late TextEditingController _locationController;
  late Set<String> _interests;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user.name);
    _bioController = TextEditingController(text: user.bio);
    _occupationController = TextEditingController(text: user.occupation);
    _companyController = TextEditingController(text: user.company ?? '');
    _educationController = TextEditingController(text: user.education ?? '');
    _locationController = TextEditingController(text: user.location);
    _interests = Set.from(user.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _occupationController.dispose();
    _companyController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final current = ref.read(currentUserProvider);
    final updated = current.copyWith(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      occupation: _occupationController.text.trim(),
      company: _companyController.text.trim(),
      education: _educationController.text.trim(),
      location: _locationController.text.trim(),
      interests: _interests.toList(),
    );

    ref.read(currentUserProvider.notifier).state = updated;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully! ✨'),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Header
              Center(
                child: Stack(
                  children: [
                    ViblyAvatar(imageUrl: user.photos.first, radius: 50, hasStoryRing: true),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              ViblyTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              ViblyTextField(
                controller: _bioController,
                labelText: 'About Me',
                hintText: 'Write your bio',
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              ViblyTextField(
                controller: _occupationController,
                labelText: 'Profession',
                hintText: 'e.g. Architect',
                prefixIcon: Icons.work_outline,
              ),
              const SizedBox(height: 16),

              ViblyTextField(
                controller: _educationController,
                labelText: 'Education',
                hintText: 'e.g. University',
                prefixIcon: Icons.school_outlined,
              ),
              const SizedBox(height: 16),

              ViblyTextField(
                controller: _locationController,
                labelText: 'Location',
                hintText: 'City, State',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 24),

              // Interests
              Text(
                'My Passions & Interests',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MockData.interestCategories.map((cat) {
                  final isSelected = _interests.contains(cat);
                  return InterestChip(
                    label: cat,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _interests.remove(cat);
                        } else {
                          _interests.add(cat);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
              ViblyPrimaryButton(
                text: 'Save Changes',
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
