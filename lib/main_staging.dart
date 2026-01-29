import 'package:flutter_starter_pro/app.dart';
import 'package:flutter_starter_pro/bootstrap.dart';
import 'package:flutter_starter_pro/config/env/staging_environment.dart';

/// Staging entry point.
///
/// Run with: flutter run -t lib/main_staging.dart
/// Or: flutter run --flavor staging -t lib/main_staging.dart
void main() async {
  await bootstrap(
    builder: (localStorage) => App(localStorage: localStorage),
    environment: const StagingEnvironment(),
  );
}
