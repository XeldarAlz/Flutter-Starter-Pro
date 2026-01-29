import 'package:flutter_starter_pro/app.dart';
import 'package:flutter_starter_pro/bootstrap.dart';

/// Default entry point (uses development environment).
///
/// For specific environments, use:
/// - `lib/main_dev.dart` for development
/// - `lib/main_staging.dart` for staging
/// - `lib/main_prod.dart` for production
void main() async {
  await bootstrap(
    builder: (localStorage) => App(localStorage: localStorage),
  );
}
