import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:flutter_starter_pro/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_starter_pro/features/profile/presentation/screens/profile_screen.dart';
import 'package:iconsax/iconsax.dart';

/// Provider to track the current navigation index
final mainNavIndexProvider = StateProvider<int>((ref) => 0);

/// Main shell widget with bottom navigation
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          AnalyticsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(mainNavIndexProvider.notifier).state = index;
        },
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
}
