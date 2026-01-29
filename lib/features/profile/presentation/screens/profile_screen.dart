import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/extensions/context_extensions.dart';
import 'package:flutter_starter_pro/core/router/routes.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

/// Profile screen displaying user information
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(context, user),
            const SizedBox(height: 24),
            _buildStatsSection(context),
            const SizedBox(height: 24),
            _buildMenuItem(
              context,
              icon: Iconsax.user_edit,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Iconsax.security_safe,
              title: 'Security',
              subtitle: 'Password and authentication',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Iconsax.notification,
              title: 'Notifications',
              subtitle: 'Configure your notifications',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Iconsax.document_text,
              title: 'Activity Log',
              subtitle: 'View your recent activity',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Iconsax.star,
              title: 'Favorites',
              subtitle: 'Your saved items',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _buildAccountStatus(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User? user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.primaryContainer,
                border: Border.all(
                  color: context.colorScheme.primary,
                  width: 3,
                ),
              ),
              child: user?.avatarUrl != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user!.avatarUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => _buildInitials(
                          context,
                          user.initials,
                        ),
                      ),
                    )
                  : _buildInitials(context, user?.initials ?? 'U'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Iconsax.camera,
                    size: 16,
                    color: context.colorScheme.onPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? 'User',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        if (user?.createdAt != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Member since ${_formatDate(user!.createdAt!)}',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials(BuildContext context, String initials) {
    return Center(
      child: Text(
        initials,
        style: context.textTheme.headlineMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, '12', 'Projects'),
          _buildDivider(context),
          _buildStatItem(context, '48', 'Tasks'),
          _buildDivider(context),
          _buildStatItem(context, '7', 'Teams'),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: context.colorScheme.outline.withAlpha(51),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: context.colorScheme.onSurfaceVariant,
          size: 18,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildAccountStatus(BuildContext context, User? user) {
    final isVerified = user?.isEmailVerified ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withAlpha(26)
            : Colors.orange.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVerified
              ? Colors.green.withAlpha(77)
              : Colors.orange.withAlpha(77),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isVerified
                  ? Colors.green.withAlpha(51)
                  : Colors.orange.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isVerified ? Iconsax.shield_tick : Iconsax.shield_cross,
              color: isVerified ? Colors.green : Colors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerified ? 'Account Verified' : 'Verify Your Email',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isVerified ? Colors.green : Colors.orange,
                  ),
                ),
                Text(
                  isVerified
                      ? 'Your account is fully verified'
                      : 'Please verify your email to access all features',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isVerified
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          if (!isVerified)
            TextButton(
              onPressed: () {},
              child: const Text('Verify'),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
