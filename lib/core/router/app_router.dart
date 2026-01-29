import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/router/routes.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/storage/secure_storage.dart';
import 'package:flutter_starter_pro/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:flutter_starter_pro/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:flutter_starter_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_starter_pro/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_starter_pro/features/main/presentation/screens/main_shell.dart';
import 'package:flutter_starter_pro/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_starter_pro/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_starter_pro/features/settings/presentation/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Provider for the app router
@riverpod
GoRouter appRouter(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final localStorage = ref.watch(localStorageInstanceProvider);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final location = state.matchedLocation;

      // Check if onboarding is completed
      final onboardingCompleted = localStorage?.isOnboardingCompleted ?? false;

      // Check if user is authenticated
      final isLoggedIn = await secureStorage.hasValidToken();

      // Splash screen logic
      if (location == Routes.splash) {
        if (!onboardingCompleted) {
          return Routes.onboarding;
        }
        if (!isLoggedIn) {
          return Routes.login;
        }
        return Routes.home;
      }

      // Onboarding route protection
      if (location == Routes.onboarding) {
        if (onboardingCompleted) {
          return isLoggedIn ? Routes.home : Routes.login;
        }
        return null;
      }

      // Auth routes - redirect to home if already logged in
      final authRoutes = [
        Routes.login,
        Routes.register,
        Routes.forgotPassword,
      ];

      if (isLoggedIn && authRoutes.contains(location)) {
        return Routes.home;
      }

      // Protected routes - redirect to login if not logged in
      final protectedRoutes = [
        Routes.home,
        Routes.profile,
        Routes.settings,
        '/analytics',
      ];

      if (!isLoggedIn && protectedRoutes.any((r) => location.startsWith(r))) {
        return Routes.login;
      }

      return null;
    },
    routes: [
      // Splash / Initial
      GoRoute(
        path: Routes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const _SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: Routes.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: Routes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main App Routes - with bottom navigation shell
      GoRoute(
        path: Routes.home,
        name: RouteNames.home,
        builder: (context, state) => const MainShell(),
      ),

      // Standalone routes (pushed on top of shell)
      GoRoute(
        path: Routes.profile,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),

      // Settings Routes
      GoRoute(
        path: Routes.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

/// Provider for SecureStorage
@riverpod
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}

/// Provider for LocalStorage instance
/// This should be overridden with the actual instance in main.dart
@riverpod
LocalStorage? localStorageInstance(Ref ref) {
  return null;
}

/// Simple splash screen widget
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Flutter Starter Pro',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Error screen for unknown routes
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              error?.toString() ?? 'The page you are looking for does not exist.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

