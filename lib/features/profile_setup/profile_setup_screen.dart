import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_gradients.dart';
import '../../core/constants/app_typography.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/interest_chip.dart';
import '../../core/widgets/vibly_avatar.dart';
import '../../core/widgets/vibly_button.dart';
import '../../core/widgets/vibly_text_field.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/vibly_repository.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  int _currentStep = 0;

  // Step 1: Basics
  final _nameController = TextEditingController(text: 'Alex Rivera');
  DateTime? _selectedDob = DateTime(2000, 5, 14);
  String _selectedGender = 'Man';
  final String _profilePhoto =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80';

  // Step 2: Intentions & Details
  String _interestedIn = 'Women';
  String _intention = 'Long-term relationship';
  final _locationController = TextEditingController(text: 'Brooklyn, NY');
  final _professionController = TextEditingController(text: 'Architect & Designer');
  final _educationController = TextEditingController(text: 'Columbia University');

  // Step 3: Bio & Interests
  final _bioController = TextEditingController(
    text:
        'Architect by day, vinyl collector & amateur chef by night. Looking for someone to explore hidden coffee shops and art galleries with 🚗✨',
  );
  final Set<String> _selectedInterests = {
    'Coffee ☕',
    'Music 🎵',
    'Architecture',
    'Art & Museums 🎨',
    'Travel ✈️',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _professionController.dispose();
    _educationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  int? get _calculatedAge {
    if (_selectedDob == null) return null;
    final now = DateTime.now();
    int age = now.year - _selectedDob!.year;
    if (now.month < _selectedDob!.month ||
        (now.month == _selectedDob!.month && now.day < _selectedDob!.day)) {
      age--;
    }
    return age;
  }

  void _pickDateOfBirth() async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2001, 1, 1),
      firstDate: DateTime(1940),
      lastDate: eighteenYearsAgo,
      helpText: 'Select Your Date of Birth (Must be 18+)',
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  void _onNextStep() {
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        _showError('Please enter your full name');
        return;
      }
      final age = _calculatedAge;
      if (age == null || age < 18) {
        _showError('You must be at least 18 years old to join Vibly');
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_locationController.text.trim().isEmpty) {
        _showError('Please provide your location');
        return;
      }
      setState(() => _currentStep = 2);
    } else {
      // Complete profile
      final updatedProfile = UserProfile(
        id: 'user_me',
        name: _nameController.text.trim(),
        age: _calculatedAge ?? 25,
        bio: _bioController.text.trim(),
        occupation: _professionController.text.trim(),
        education: _educationController.text.trim(),
        location: _locationController.text.trim(),
        distanceKm: 0.0,
        photos: [_profilePhoto],
        interests: _selectedInterests.toList(),
        intention: _intention,
        isVerified: true,
        compatibilityScore: 98,
      );

      ref.read(currentUserProvider.notifier).state = updatedProfile;
      ref.read(isAuthenticatedProvider.notifier).state = true;
      context.go(AppRoutes.main);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  size: 20,
                ),
                onPressed: () => setState(() => _currentStep--),
              )
            : null,
        title: Text(
          'Step ${_currentStep + 1} of 3',
          style: AppTypography.titleMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 15,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        gradient: index <= _currentStep ? AppGradients.primary : null,
                        color: index <= _currentStep
                            ? null
                            : (isDark ? AppColors.surfaceDark : AppColors.borderLight),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildCurrentStepContent(isDark),
              ),
            ),

            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ViblyPrimaryButton(
                text: _currentStep == 2 ? 'Complete & Find Vibes' : 'Continue',
                icon: _currentStep == 2 ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                onPressed: _onNextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Basics(isDark);
      case 1:
        return _buildStep2Intentions(isDark);
      case 2:
      default:
        return _buildStep3BioAndInterests(isDark);
    }
  }

  // STEP 1: BASICS
  Widget _buildStep1Basics(bool isDark) {
    final age = _calculatedAge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Basics',
          style: AppTypography.displayMedium.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Let others know who you are. Must be 18+ to join.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 28),

        // Photo Upload / Selector
        Center(
          child: Stack(
            children: [
              ViblyAvatar(
                imageUrl: _profilePhoto,
                radius: 56,
                hasStoryRing: true,
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Full Name
        ViblyTextField(
          controller: _nameController,
          labelText: 'First & Last Name',
          hintText: 'e.g. Alex Rivera',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 20),

        // Date of Birth & Age
        Text(
          'Date of Birth',
          style: AppTypography.labelLarge.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDateOfBirth,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDob != null
                          ? DateFormat('MMMM d, yyyy').format(_selectedDob!)
                          : 'Select your birthday',
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                if (age != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$age yrs old',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Gender Selector
        Text(
          'Gender',
          style: AppTypography.labelLarge.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['Woman', 'Man', 'Non-Binary', 'Other'].map((gender) {
            final isSelected = _selectedGender == gender;
            return InterestChip(
              label: gender,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedGender = gender),
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 2: INTENTIONS & DETAILS
  Widget _buildStep2Intentions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Intentions',
          style: AppTypography.displayMedium.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Find people looking for the same kind of energy as you.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 28),

        // Interested In
        Text(
          'Interested in',
          style: AppTypography.labelLarge.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: ['Women', 'Men', 'Everyone'].map((item) {
            final isSelected = _interestedIn == item;
            return InterestChip(
              label: item,
              isSelected: isSelected,
              onTap: () => setState(() => _interestedIn = item),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Relationship Intentions
        Text(
          'What are you looking for?',
          style: AppTypography.labelLarge.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            'Long-term relationship',
            'Casual dating & fun',
            'New friends & vibe',
            'Still figuring it out',
          ].map((intent) {
            final isSelected = _intention == intent;
            return InterestChip(
              label: intent,
              isSelected: isSelected,
              onTap: () => setState(() => _intention = intent),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Location
        ViblyTextField(
          controller: _locationController,
          labelText: 'Your Location',
          hintText: 'e.g. Brooklyn, NY',
          prefixIcon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 18),

        // Profession & Education
        ViblyTextField(
          controller: _professionController,
          labelText: 'Profession',
          hintText: 'e.g. Architect, Photographer',
          prefixIcon: Icons.work_outline_rounded,
        ),
        const SizedBox(height: 18),
        ViblyTextField(
          controller: _educationController,
          labelText: 'Education',
          hintText: 'e.g. Columbia University',
          prefixIcon: Icons.school_outlined,
        ),
      ],
    );
  }

  // STEP 3: BIO & INTERESTS
  Widget _buildStep3BioAndInterests(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vibe & Passions',
          style: AppTypography.displayMedium.copyWith(
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select your top passions and write a bio that captures your aura.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),

        // Bio
        ViblyTextField(
          controller: _bioController,
          labelText: 'About You (Bio)',
          hintText: 'Share a slice of your life, quirks, and music taste...',
          maxLines: 4,
        ),
        const SizedBox(height: 28),

        // Passions / Interests
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Passions',
              style: AppTypography.labelLarge.copyWith(
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${_selectedInterests.length} selected',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: MockData.interestCategories.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return InterestChip(
              label: interest,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedInterests.remove(interest);
                  } else {
                    _selectedInterests.add(interest);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
 