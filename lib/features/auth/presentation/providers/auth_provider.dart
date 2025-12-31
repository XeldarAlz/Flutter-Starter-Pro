import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/router/app_router.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Auth state
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Auth state class
class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => status == AuthStatus.error;
}

/// Auth notifier for managing authentication state
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthState();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final secureStorage = ref.read(secureStorageProvider);
      final hasToken = await secureStorage.hasValidToken();

      if (hasToken) {
        // In a real app, you would fetch user data here
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: const User(id: '1', email: 'user@example.com', name: 'Demo User'),
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 1));

      // In a real app, you would call your auth API here
      // For demo purposes, we'll accept any valid email/password
      if (email.isNotEmpty && password.length >= 6) {
        final secureStorage = ref.read(secureStorageProvider);
        await secureStorage.saveTokens(
          accessToken: 'demo_access_token',
          refreshToken: 'demo_refresh_token',
          userId: '1',
        );

        // Save email if remember me is enabled
        final localStorage = ref.read(localStorageInstanceProvider);
        if (localStorage?.rememberMe ?? false) {
          await localStorage?.setUserEmail(email);
        }

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: UserModel(
            id: '1',
            email: email,
            name: 'Demo User',
            isEmailVerified: true,
          ),
        );

        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid email or password',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 1));

      // In a real app, you would call your auth API here
      final secureStorage = ref.read(secureStorageProvider);
      await secureStorage.saveTokens(
        accessToken: 'demo_access_token',
        refreshToken: 'demo_refresh_token',
        userId: '1',
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: UserModel(
          id: '1',
          email: email,
          name: name,
          isEmailVerified: false,
        ),
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final secureStorage = ref.read(secureStorageProvider);
      await secureStorage.clearTokens();

      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Request password reset
  Future<bool> requestPasswordReset(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 1));

      // In a real app, you would call your auth API here
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider to check if user is authenticated
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated;
}

/// Provider to get current user
@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
}

