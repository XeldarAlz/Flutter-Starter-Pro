import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/config/env/app_environment.dart';
import 'package:flutter_starter_pro/config/env/dev_environment.dart';
import 'package:flutter_starter_pro/config/env/environment_provider.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_starter_pro/core/di/injection_container.dart';

/// Bootstrap configuration
typedef AppBuilder = Widget Function(LocalStorage localStorage);

/// Initialize app and run with error handling.
///
/// [environment] specifies the app configuration (dev/staging/prod).
/// [builder] creates the root widget with access to localStorage.
///
/// Example:
/// ```dart
/// bootstrap(
///   builder: (localStorage) => App(localStorage: localStorage),
///   environment: const DevEnvironment(),
/// );
/// ```
Future<void> bootstrap({
  required AppBuilder builder,
  AppEnvironment environment = const DevEnvironment(),
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();

  final sharedPrefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(sharedPrefs);

  FlutterError.onError = (details) {
    if (environment.enableLogging) {
      AppLogger.error(
        'Flutter Error',
        error: details.exception,
        stackTrace: details.stack,
      );
    }

    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (environment.enableLogging) {
      AppLogger.error(
        'Platform Error',
        error: error,
        stackTrace: stack,
      );
    }
    return true;
  };

  if (environment.enableLogging) {
    AppLogger.info('Starting app in ${environment.name} environment');
    AppLogger.info('API Base URL: ${environment.baseUrl}');
  }

  runZonedGuarded(
    () => runApp(
      ProviderScope(
        overrides: [
          environmentProvider.overrideWithValue(environment),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: builder(localStorage),
      ),
    ),
    (error, stack) {
      if (environment.enableLogging) {
        AppLogger.error(
          'Zone Error',
          error: error,
          stackTrace: stack,
        );
      }

      if (kDebugMode || environment.enableLogging) {
        debugPrint('Caught zone error: $error');
        debugPrint(stack.toString());
      }
    },
  );
}
