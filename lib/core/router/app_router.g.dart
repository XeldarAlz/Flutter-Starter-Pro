// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appRouterHash() => r'4fb74b9fbfbae302ca1edad7a6969508a665a39b';

/// Provider for the app router
///
/// Copied from [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppRouterRef = AutoDisposeProviderRef<GoRouter>;
String _$secureStorageHash() => r'493c5de81d0d8c369c4450c51217fdecea2f7a69';

/// Provider for SecureStorage
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
String _$localStorageInstanceHash() =>
    r'8c0f23ad1c5bb95fe64e694dd25afac9d50e2d88';

/// Provider for LocalStorage instance
/// This should be overridden with the actual instance in main.dart
///
/// Copied from [localStorageInstance].
@ProviderFor(localStorageInstance)
final localStorageInstanceProvider =
    AutoDisposeProvider<LocalStorage?>.internal(
  localStorageInstance,
  name: r'localStorageInstanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localStorageInstanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalStorageInstanceRef = AutoDisposeProviderRef<LocalStorage?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
