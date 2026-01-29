part of 'environment_provider.dart';

String _$environmentHash() => r'5ff2bd9e244a4dc2980fbe6577b9b953dcde83be';

/// Provider for the current [AppEnvironment].
///
/// This provider must be overridden in the ProviderScope with the
/// actual environment configuration based on the build flavor.
///
/// Example:
/// ```dart
/// runApp(
///   ProviderScope(
///     overrides: [
///       environmentProvider.overrideWithValue(DevEnvironment()),
///     ],
///     child: const App(),
///   ),
/// );
/// ```
///
/// Copied from [environment].
@ProviderFor(environment)
final environmentProvider = AutoDisposeProvider<AppEnvironment>.internal(
  environment,
  name: r'environmentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$environmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EnvironmentRef = AutoDisposeProviderRef<AppEnvironment>;
