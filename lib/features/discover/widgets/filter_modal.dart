import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/interest_chip.dart';
import '../../../core/widgets/vibly_button.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  RangeValues _ageRange = const RangeValues(21, 32);
  double _distanceKm = 25;
  String _interestedIn = 'Women';
  bool _verifiedOnly = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discovery Preferences',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _ageRange = const RangeValues(18, 40);
                    _distanceKm = 50;
                    _verifiedOnly = false;
                  });
                },
                child: Text(
                  'Reset',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Interested In
          Text(
            'Interested In',
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
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

          // Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maximum Distance',
                style: AppTypography.labelLarge.copyWith(
                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${_distanceKm.round()} km',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Slider(
            value: _distanceKm,
            min: 2,
            max: 100,
            activeColor: AppColors.primary,
            inactiveColor: isDark ? AppColors.surfaceDark : AppColors.borderLight,
            onChanged: (val) => setState(() => _distanceKm = val),
          ),
          const SizedBox(height: 20),

          // Age Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Age Range',
                style: AppTypography.labelLarge.copyWith(
                  color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${_ageRange.start.round()} - ${_ageRange.end.round()}',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 60,
            activeColor: AppColors.primary,
            inactiveColor: isDark ? AppColors.surfaceDark : AppColors.borderLight,
            onChanged: (vals) => setState(() => _ageRange = vals),
          ),
          const SizedBox(height: 16),

          // Verified Profiles Only
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Verified Profiles Only',
              style: AppTypography.labelLarge.copyWith(
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              'Only show profiles with a blue verified badge',
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            value: _verifiedOnly,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _verifiedOnly = val),
          ),

          const SizedBox(height: 24),

          // Apply Button
          ViblyPrimaryButton(
            text: 'Apply Filters',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
 