import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../data/repositories/vibly_repository.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = true;
  bool _incognitoMode = false;
  bool _readReceipts = true;

  void _onLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out of Vibly?'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(isAuthenticatedProvider.notifier).state = false;
              context.go(AppRoutes.login);
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings & Privacy',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // App Preferences
            _buildSectionHeader('Appearance & Experience', isDark),
            _buildSwitchTile(
              title: 'Dark Theme',
              subtitle: 'Switch between light and dark visual aesthetics',
              value: isDark,
              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              onChanged: (val) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              isDark: isDark,
            ),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Get alerts for new matches, likes, and messages',
              value: _notifications,
              icon: Icons.notifications_outlined,
              onChanged: (val) => setState(() => _notifications = val),
              isDark: isDark,
            ),
            const SizedBox(height: 24),

            // Privacy & Discovery
            _buildSectionHeader('Privacy Controls', isDark),
            _buildSwitchTile(
              title: 'Incognito Vibe Mode',
              subtitle: 'Only profiles you like will be able to see you',
              value: _incognitoMode,
              icon: Icons.visibility_off_outlined,
              onChanged: (val) => setState(() => _incognitoMode = val),
              isDark: isDark,
            ),
            _buildSwitchTile(
              title: 'Read Receipts',
              subtitle: 'Allow conversation partners to see when you read chats',
              value: _readReceipts,
              icon: Icons.done_all_rounded,
              onChanged: (val) => setState(() => _readReceipts = val),
              isDark: isDark,
            ),
            const SizedBox(height: 24),

            // Support & About
            _buildSectionHeader('Support & Legal', isDark),
            _buildNavTile(
              title: 'Safety Center & Guidelines',
              icon: Icons.security_outlined,
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vibly Safety Guidelines: Always meet in public places!')),
                );
              },
            ),
            _buildNavTile(
              title: 'Help & Contact Support',
              icon: Icons.help_outline_rounded,
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact support at support@vibly.app')),
                );
              },
            ),
            _buildNavTile(
              title: 'Terms of Service',
              icon: Icons.description_outlined,
              isDark: isDark,
              onTap: () {},
            ),

            const SizedBox(height: 36),

            // Logout Button
            Center(
              child: TextButton.icon(
                onPressed: _onLogout,
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: Text(
                  'Log Out',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text(
                'Vibly v1.0.0 • Made with ❤️',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(
          title,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        ),
      ),
    );
  }
}
 