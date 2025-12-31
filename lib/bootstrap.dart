import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/utils/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bootstrap configuration
typedef AppBuilder = Widget Function(LocalStorage localStorage);

/// Initialize app and run with error handling
Future<void> bootstrap(AppBuilder builder) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(sharedPrefs);

  // Set up error handling
  FlutterError.onError = (details) {
    AppLogger.error(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );

    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  // Handle async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'Platform Error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  // Run the app
  runApp(
    ProviderScope(
      child: builder(localStorage),
    ),
  );
}

