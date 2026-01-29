part of 'injection_container.dart';

String _$connectivityHash() => r'6d67af0ea4110f6ee0246dd332f90f8901380eda';

/// Provider for [Connectivity].
///
/// Copied from [connectivity].
@ProviderFor(connectivity)
final connectivityProvider = AutoDisposeProvider<Connectivity>.internal(
  connectivity,
  name: r'connectivityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$connectivityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectivityRef = AutoDisposeProviderRef<Connectivity>;
String _$networkInfoHash() => r'f494322cb6af32956aaa1f4641d36f04f7a4584a';

/// Provider for [NetworkInfo].
///
/// Copied from [networkInfo].
@ProviderFor(networkInfo)
final networkInfoProvider = AutoDisposeProvider<NetworkInfo>.internal(
  networkInfo,
  name: r'networkInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$networkInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NetworkInfoRef = AutoDisposeProviderRef<NetworkInfo>;
String _$secureStorageHash() => r'493c5de81d0d8c369c4450c51217fdecea2f7a69';

/// Provider for [SecureStorage].
///
/// Copied from [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider = AutoDisposeProvider<SecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecureStorageRef = AutoDisposeProviderRef<SecureStorage>;
String _$sharedPreferencesHash() => r'9c63db33ca35f4c5bcb1c05e8565b55f1b59e5f8';

/// Provider for [SharedPreferences].
/// This must be overridden in the main app with the actual instance.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = AutoDisposeProviderRef<SharedPreferences>;
String _$localStorageHash() => r'a4ba7a901c654bb01bed05a2c43eacfd9b7688c8';

/// Provider for [LocalStorage].
///
/// Copied from [localStorage].
@ProviderFor(localStorage)
final localStorageProvider = AutoDisposeProvider<LocalStorage>.internal(
  localStorage,
  name: r'localStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalStorageRef = AutoDisposeProviderRef<LocalStorage>;
String _$crashReporterHash() => r'87b4e98f1982ffe4fe905417c967e0cbb3c7a4ba';

/// Provider for [CrashReporter].
///
/// Returns [SentryCrashReporter] in production/staging when crash reporting
/// is enabled, otherwise returns [NoOpCrashReporter].
///
/// Copied from [crashReporter].
@ProviderFor(crashReporter)
final crashReporterProvider = AutoDisposeProvider<CrashReporter>.internal(
  crashReporter,
  name: r'crashReporterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crashReporterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrashReporterRef = AutoDisposeProviderRef<CrashReporter>;
String _$analyticsServiceHash() => r'b072b24667e4947d1dbd33b9a4b1001141b2790a';

/// Provider for [AnalyticsService].
///
/// Returns [FirebaseAnalyticsService] when analytics is enabled,
/// otherwise returns [NoOpAnalyticsService].
///
/// Copied from [analyticsService].
@ProviderFor(analyticsService)
final analyticsServiceProvider = AutoDisposeProvider<AnalyticsService>.internal(
  analyticsService,
  name: r'analyticsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AnalyticsServiceRef = AutoDisposeProviderRef<AnalyticsService>;
String _$syncManagerHash() => r'5d6dacc8cd204ad94fe4c79505506ff2dbe7b980';

/// Provider for [SyncManager].
///
/// Manages offline operations and syncs them when connectivity is restored.
///
/// Copied from [syncManager].
@ProviderFor(syncManager)
final syncManagerProvider = AutoDisposeProvider<SyncManager>.internal(
  syncManager,
  name: r'syncManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SyncManagerRef = AutoDisposeProviderRef<SyncManager>;
String _$apiClientHash() => r'002124d80c2fc54c69b803852ad2319132fa3cce';

/// Provider for [ApiClient].
/// Uses environment configuration for base URL and timeouts.
///
/// Copied from [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = AutoDisposeProvider<ApiClient>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiClientRef = AutoDisposeProviderRef<ApiClient>;
String _$authRemoteDataSourceHash() =>
    r'ee57c18d741addd27f49e2884c972d342774ad74';

/// Provider for [AuthRemoteDataSource].
///
/// Copied from [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider =
    AutoDisposeProvider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRemoteDataSourceRef = AutoDisposeProviderRef<AuthRemoteDataSource>;
String _$authLocalDataSourceHash() =>
    r'5900618b40b49ca0a6e497f88db80964e2964f82';

/// Provider for [AuthLocalDataSource].
///
/// Copied from [authLocalDataSource].
@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider =
    AutoDisposeProvider<AuthLocalDataSource>.internal(
  authLocalDataSource,
  name: r'authLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthLocalDataSourceRef = AutoDisposeProviderRef<AuthLocalDataSource>;
String _$authRepositoryHash() => r'035b079c06c4c0f98f1e45d75766cbd46a4ea376';

/// Provider for [AuthRepository].
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$signInUseCaseHash() => r'c6ac204cf3d8d14a9b5a14afd07c9c51c304a5c8';

/// Provider for [SignInUseCase].
///
/// Copied from [signInUseCase].
@ProviderFor(signInUseCase)
final signInUseCaseProvider = AutoDisposeProvider<SignInUseCase>.internal(
  signInUseCase,
  name: r'signInUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignInUseCaseRef = AutoDisposeProviderRef<SignInUseCase>;
String _$signUpUseCaseHash() => r'd1bc720af6903bba68758c86d57e65fcc067602e';

/// Provider for [SignUpUseCase].
///
/// Copied from [signUpUseCase].
@ProviderFor(signUpUseCase)
final signUpUseCaseProvider = AutoDisposeProvider<SignUpUseCase>.internal(
  signUpUseCase,
  name: r'signUpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignUpUseCaseRef = AutoDisposeProviderRef<SignUpUseCase>;
String _$signOutUseCaseHash() => r'952ce342ca22dc7bb696cc8e5787d2889240ef98';

/// Provider for [SignOutUseCase].
///
/// Copied from [signOutUseCase].
@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = AutoDisposeProvider<SignOutUseCase>.internal(
  signOutUseCase,
  name: r'signOutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignOutUseCaseRef = AutoDisposeProviderRef<SignOutUseCase>;
String _$forgotPasswordUseCaseHash() =>
    r'308418b3aa16b40eecd5c120bcfc7bdd01f86b1d';

/// Provider for [ForgotPasswordUseCase].
///
/// Copied from [forgotPasswordUseCase].
@ProviderFor(forgotPasswordUseCase)
final forgotPasswordUseCaseProvider =
    AutoDisposeProvider<ForgotPasswordUseCase>.internal(
  forgotPasswordUseCase,
  name: r'forgotPasswordUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forgotPasswordUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ForgotPasswordUseCaseRef
    = AutoDisposeProviderRef<ForgotPasswordUseCase>;
String _$getCurrentUserUseCaseHash() =>
    r'4a27d130940e444424e46ed4afad7c5a5c8cf5b2';

/// Provider for [GetCurrentUserUseCase].
///
/// Copied from [getCurrentUserUseCase].
@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider =
    AutoDisposeProvider<GetCurrentUserUseCase>.internal(
  getCurrentUserUseCase,
  name: r'getCurrentUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCurrentUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetCurrentUserUseCaseRef
    = AutoDisposeProviderRef<GetCurrentUserUseCase>;
String _$updateUserUseCaseHash() => r'25e94e1e53f092b8ef4710d18a0ef069a764ac89';

/// Provider for [UpdateUserUseCase].
///
/// Copied from [updateUserUseCase].
@ProviderFor(updateUserUseCase)
final updateUserUseCaseProvider =
    AutoDisposeProvider<UpdateUserUseCase>.internal(
  updateUserUseCase,
  name: r'updateUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateUserUseCaseRef = AutoDisposeProviderRef<UpdateUserUseCase>;
