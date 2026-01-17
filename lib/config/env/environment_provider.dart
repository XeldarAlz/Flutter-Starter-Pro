import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/config/env/app_environment.dart';
import 'package:flutter_starter_pro/config/env/dev_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'environment_provider.g.dart';

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
@riverpod
AppEnvironment environment(Ref ref) {
  // Default to development environment
  // This should be overridden in main_*.dart files
  return const DevEnvironment();
}
