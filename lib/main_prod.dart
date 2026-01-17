import 'package:flutter_starter_pro/app.dart';
import 'package:flutter_starter_pro/bootstrap.dart';
import 'package:flutter_starter_pro/config/env/prod_environment.dart';

/// Production entry point.
///
/// Run with: flutter run -t lib/main_prod.dart --release
/// Or: flutter run --flavor prod -t lib/main_prod.dart --release
void main() {
  bootstrap(
    builder: (localStorage) => App(localStorage: localStorage),
    environment: const ProdEnvironment(),
  );
}
