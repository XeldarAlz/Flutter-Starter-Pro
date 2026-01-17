import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/config/env/environment_provider.dart';
import 'package:flutter_starter_pro/core/analytics/analytics_service.dart';
import 'package:flutter_starter_pro/core/analytics/analytics_service_impl.dart';
import 'package:flutter_starter_pro/core/monitoring/crash_reporter.dart';
import 'package:flutter_starter_pro/core/monitoring/crash_reporter_impl.dart';
import 'package:flutter_starter_pro/core/network/api_client.dart';
import 'package:flutter_starter_pro/core/network/network_info.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/storage/secure_storage.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:flutter_starter_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_pro/features/auth/domain/usecases/usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.g.dart';

// =============================================================================
// Core Services
// =============================================================================

/// Provider for [Connectivity].
@riverpod
Connectivity connectivity(Ref ref) {
  return Connectivity();
}

/// Provider for [NetworkInfo].
@riverpod
NetworkInfo networkInfo(Ref ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
}

/// Provider for [SecureStorage].
@riverpod
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}

/// Provider for [SharedPreferences].
/// This must be overridden in the main app with the actual instance.
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with the actual '
    'SharedPreferences instance',
  );
}

/// Provider for [LocalStorage].
@riverpod
LocalStorage localStorage(Ref ref) {
  return LocalStorage(ref.watch(sharedPreferencesProvider));
}

// =============================================================================
// Monitoring & Analytics
// =============================================================================

/// Provider for [CrashReporter].
///
/// Returns [SentryCrashReporter] in production/staging when crash reporting
/// is enabled, otherwise returns [NoOpCrashReporter].
@riverpod
CrashReporter crashReporter(Ref ref) {
  final env = ref.watch(environmentProvider);
  if (env.enableCrashReporting && env.sentryDsn.isNotEmpty) {
    return SentryCrashReporter(env);
  }
  return const NoOpCrashReporter();
}

/// Provider for [AnalyticsService].
///
/// Returns [FirebaseAnalyticsService] when analytics is enabled,
/// otherwise returns [NoOpAnalyticsService].
@riverpod
AnalyticsService analyticsService(Ref ref) {
  final env = ref.watch(environmentProvider);
  if (env.enableAnalytics) {
    return FirebaseAnalyticsService(env);
  }
  return const NoOpAnalyticsService();
}

// =============================================================================
// Network
// =============================================================================

// =============================================================================
// Network
// =============================================================================

/// Provider for [ApiClient].
/// Uses environment configuration for base URL and timeouts.
@riverpod
ApiClient apiClient(Ref ref) {
  final env = ref.watch(environmentProvider);
  return ApiClient(
    secureStorage: ref.watch(secureStorageProvider),
    baseUrl: env.baseUrl,
    connectionTimeout: env.connectionTimeout,
    receiveTimeout: env.receiveTimeout,
    enableLogging: env.enableLogging,
  );
}

// =============================================================================
// Auth Feature
// =============================================================================

/// Provider for [AuthRemoteDataSource].
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
}

/// Provider for [AuthLocalDataSource].
@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
    localStorage: ref.watch(localStorageProvider),
  );
}

/// Provider for [AuthRepository].
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

/// Provider for [SignInUseCase].
@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

/// Provider for [SignUpUseCase].
@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}

/// Provider for [SignOutUseCase].
@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}

/// Provider for [ForgotPasswordUseCase].
@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
}

/// Provider for [GetCurrentUserUseCase].
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

/// Provider for [UpdateUserUseCase].
@riverpod
UpdateUserUseCase updateUserUseCase(Ref ref) {
  return UpdateUserUseCase(ref.watch(authRepositoryProvider));
}
