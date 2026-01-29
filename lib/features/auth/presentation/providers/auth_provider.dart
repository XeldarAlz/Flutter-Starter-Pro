import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/di/injection_container.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_pro/features/auth/domain/usecases/usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Authentication status enum.
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Authentication state class.
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

/// Auth notifier for managing authentication state using Clean Architecture.
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
      final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
      final result = await getCurrentUser();

      result.fold(
        (failure) {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        },
        (user) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign in with email and password.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final signInUseCase = ref.read(signInUseCaseProvider);
      final result = await signInUseCase(
        SignInParams(email: email, password: password),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          );
          return false;
        },
        (user) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Sign up with name, email, and password.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final signUpUseCase = ref.read(signUpUseCaseProvider);
      final result = await signUpUseCase(
        SignUpParams(name: name, email: email, password: password),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          );
          return false;
        },
        (user) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final signOutUseCase = ref.read(signOutUseCaseProvider);
      final result = await signOutUseCase();

      result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          );
        },
        (_) {
          state = const AuthState(status: AuthStatus.unauthenticated);
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Request password reset.
  Future<bool> requestPasswordReset(String email) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
      final result = await forgotPasswordUseCase(
        ForgotPasswordParams(email: email),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: failure.message,
          );
          return false;
        },
        (_) {
          state = state.copyWith(status: AuthStatus.unauthenticated);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Update user profile.
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final updateUserUseCase = ref.read(updateUserUseCaseProvider);
      final result = await updateUserUseCase(
        UpdateUserParams(
          name: name,
          phoneNumber: phoneNumber,
          avatarUrl: avatarUrl,
        ),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            errorMessage: failure.message,
          );
          return false;
        },
        (user) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith();
  }
}

/// Provider to check if user is authenticated.
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated;
}

/// Provider to get current user.
@riverpod
User? currentUser(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
}
