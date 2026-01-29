import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/extensions/context_extensions.dart';
import 'package:flutter_starter_pro/core/router/routes.dart';
import 'package:flutter_starter_pro/core/theme/theme_provider.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context, user),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Appearance'),
            const SizedBox(height: 12),
            _buildSettingTile(
              context,
              icon: Iconsax.moon,
              title: 'Dark Mode',
              subtitle: _getThemeModeLabel(themeMode),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) {
                  ref.read(themeModeNotifierProvider.notifier).toggleTheme();
                },
              ),
            ),
            _buildSettingTile(
              context,
              icon: Iconsax.brush_1,
              title: 'Theme',
              subtitle: 'Customize app theme',
              onTap: () => _showThemeDialog(context, ref, themeMode),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Preferences'),
            const SizedBox(height: 12),
            _buildSettingTile(
              context,
              icon: Iconsax.global,
              title: 'Language',
              subtitle: 'English',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Iconsax.notification,
              title: 'Notifications',
              subtitle: 'Manage notifications',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Security'),
            const SizedBox(height: 12),
            _buildSettingTile(
              context,
              icon: Iconsax.lock,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Iconsax.finger_scan,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID',
              trailing: Switch(
                value: false,
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'About'),
            const SizedBox(height: 12),
            _buildSettingTile(
              context,
              icon: Iconsax.info_circle,
              title: 'About',
              subtitle: 'Version 1.0.0',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Iconsax.document_text,
              title: 'Terms of Service',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Iconsax.shield_tick,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _buildLogoutButton(context, ref),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, User? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: context.colorScheme.primaryContainer,
            child: Text(
              user?.initials ?? 'U',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'User',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.titleSmall?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outline.withAlpha(51),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: trailing ??
            (onTap != null
                ? Icon(
                    Iconsax.arrow_right_3,
                    color: context.colorScheme.onSurfaceVariant,
                    size: 18,
                  )
                : null),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context, ref),
        icon: const Icon(Iconsax.logout, color: Colors.red),
        label: const Text(
          'Log Out',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose Theme',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildThemeOption(context, ref, ThemeMode.system, currentMode),
              _buildThemeOption(context, ref, ThemeMode.light, currentMode),
              _buildThemeOption(context, ref, ThemeMode.dark, currentMode),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    ThemeMode mode,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    final icon = mode == ThemeMode.light
        ? Iconsax.sun_1
        : mode == ThemeMode.dark
            ? Iconsax.moon
            : Iconsax.mobile;

    return ListTile(
      leading: Icon(icon),
      title: Text(_getThemeModeLabel(mode)),
      trailing: isSelected
          ? Icon(
              Iconsax.tick_circle5,
              color: context.colorScheme.primary,
            )
          : null,
      onTap: () {
        ref.read(themeModeNotifierProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  context.go(Routes.login);
                }
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
