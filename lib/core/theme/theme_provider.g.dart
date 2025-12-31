// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageHash() => r'3cb32ed0f89088385d1ab9f7c9efc243997fc78d';

/// Provider for LocalStorage instance
/// This should be overridden in main.dart with the actual instance
///
/// Copied from [localStorage].
@ProviderFor(localStorage)
final localStorageProvider = AutoDisposeProvider<LocalStorage?>.internal(
  localStorage,
  name: r'localStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalStorageRef = AutoDisposeProviderRef<LocalStorage?>;
String _$themeModeNotifierHash() => r'0400d445189fdb5f8e9af27882764576e33f81d6';

/// Theme mode notifier for managing app theme
///
/// Copied from [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
