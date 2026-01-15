import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Provider for [ApiClient].
@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient(secureStorage: ref.watch(secureStorageProvider));
}

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
