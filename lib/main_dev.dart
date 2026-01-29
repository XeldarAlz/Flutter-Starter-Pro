import 'package:flutter_starter_pro/app.dart';
import 'package:flutter_starter_pro/bootstrap.dart';

/// Development entry point.
///
/// Run with: flutter run -t lib/main_dev.dart
/// Or: flutter run --flavor dev -t lib/main_dev.dart
void main() async {
  await bootstrap(
    builder: (localStorage) => App(localStorage: localStorage),
  );
}
