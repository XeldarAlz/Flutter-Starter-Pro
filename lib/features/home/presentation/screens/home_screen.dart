import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/extensions/context_extensions.dart';
import 'package:flutter_starter_pro/core/router/routes.dart';
import 'package:flutter_starter_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

/// Home screen with dashboard
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.name?.split(' ').first ?? 'User'} 👋',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Welcome back!',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _buildWelcomeCard(context),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Stats Section
            Text(
              'Overview',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatsGrid(context),
            const SizedBox(height: 24),

            // Recent Activity
            Text(
              'Recent Activity',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentActivity(context),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            selectedIcon: Icon(Iconsax.home_15),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.chart_2),
            selectedIcon: Icon(Iconsax.chart_21),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user),
            selectedIcon: Icon(Iconsax.user5),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withAlpha(204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Starter Pro',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Production-ready Flutter starter with clean architecture',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onPrimary.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Iconsax.code,
                  color: context.colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildCardStat(context, '100+', 'Stars'),
              const SizedBox(width: 32),
              _buildCardStat(context, 'v1.0', 'Version'),
              const SizedBox(width: 32),
              _buildCardStat(context, 'MIT', 'License'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardStat(BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onPrimary.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Iconsax.document,
        label: 'Docs',
        color: context.colorScheme.primary,
      ),
      _QuickAction(
        icon: Iconsax.code_1,
        label: 'API',
        color: context.colorScheme.secondary,
      ),
      _QuickAction(
        icon: Iconsax.setting,
        label: 'Config',
        color: context.colorScheme.tertiary,
      ),
      _QuickAction(
        icon: Iconsax.info_circle,
        label: 'Help',
        color: context.colorScheme.error,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildQuickActionItem(context, action),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionItem(BuildContext context, _QuickAction action) {
    return Material(
      color: action.color.withAlpha(26),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                action.icon,
                color: action.color,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: action.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          context,
          icon: Iconsax.profile_2user,
          title: 'Users',
          value: '1,234',
          trend: '+12%',
          isPositive: true,
        ),
        _buildStatCard(
          context,
          icon: Iconsax.activity,
          title: 'Sessions',
          value: '5,678',
          trend: '+8%',
          isPositive: true,
        ),
        _buildStatCard(
          context,
          icon: Iconsax.chart,
          title: 'Revenue',
          value: '\$9,876',
          trend: '+23%',
          isPositive: true,
        ),
        _buildStatCard(
          context,
          icon: Iconsax.heart,
          title: 'Favorites',
          value: '432',
          trend: '-5%',
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: context.colorScheme.primary,
                size: 24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withAlpha(26)
                      : Colors.red.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final activities = [
      _Activity(
        icon: Iconsax.user_add,
        title: 'New user registered',
        subtitle: '2 minutes ago',
        color: Colors.blue,
      ),
      _Activity(
        icon: Iconsax.document_upload,
        title: 'File uploaded',
        subtitle: '15 minutes ago',
        color: Colors.green,
      ),
      _Activity(
        icon: Iconsax.setting_2,
        title: 'Settings updated',
        subtitle: '1 hour ago',
        color: Colors.orange,
      ),
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(51),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: activity.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  activity.icon,
                  color: activity.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      activity.subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: context.colorScheme.onSurfaceVariant,
                size: 18,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;
}

class _Activity {
  const _Activity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

