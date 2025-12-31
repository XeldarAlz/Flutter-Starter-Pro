import 'package:flutter/material.dart';
import 'package:flutter_starter_pro/core/router/routes.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/storage/secure_storage.dart';

/// Authentication guard for route protection
class AuthGuard {
  AuthGuard({
    required this.secureStorage,
    required this.localStorage,
  });

  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return secureStorage.hasValidToken();
  }

  /// Check if onboarding is completed
  bool isOnboardingCompleted() {
    return localStorage.isOnboardingCompleted;
  }

  /// Check if this is the first launch
  bool isFirstLaunch() {
    return localStorage.isFirstLaunch;
  }

  /// Get the redirect path based on auth state
  Future<String?> getRedirectPath(BuildContext context, String location) async {
    final isLoggedIn = await isAuthenticated();
    final onboardingDone = isOnboardingCompleted();

    // If not onboarded and trying to access protected route
    if (!onboardingDone && location != Routes.onboarding) {
      return Routes.onboarding;
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
      Routes.dashboard,
      Routes.profile,
      Routes.editProfile,
      Routes.settings,
    ];

    if (!isLoggedIn && protectedRoutes.contains(location)) {
      return Routes.login;
    }

    return null; // No redirect needed
  }
}

