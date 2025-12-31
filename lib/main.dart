import 'package:flutter_starter_pro/app.dart';
import 'package:flutter_starter_pro/bootstrap.dart';

void main() {
  bootstrap(
    (localStorage) => App(localStorage: localStorage),
  );
}
