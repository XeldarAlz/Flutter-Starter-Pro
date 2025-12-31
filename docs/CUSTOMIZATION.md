# Customization Guide

This guide explains how to customize Flutter Starter Pro for your project.

## Table of Contents

- [Branding](#branding)
- [Theme Customization](#theme-customization)
- [API Configuration](#api-configuration)
- [Adding Features](#adding-features)
- [Localization](#localization)
- [Environment Configuration](#environment-configuration)

## Branding

### App Name

1. Update `pubspec.yaml`:
```yaml
name: your_app_name
description: Your app description
```

2. Update `lib/core/constants/app_constants.dart`:
```dart
static const String appName = 'Your App Name';
static const String appDescription = 'Your app description';
```

3. Update platform-specific names:
   - **Android**: `android/app/src/main/AndroidManifest.xml`
   - **iOS**: `ios/Runner/Info.plist`
   - **Web**: `web/index.html`

### App Icon

1. Replace logo files in `assets/images/`
2. Use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons):
```bash
flutter pub add flutter_launcher_icons --dev
# Configure in pubspec.yaml
flutter pub run flutter_launcher_icons
```

### Splash Screen

Use [flutter_native_splash](https://pub.dev/packages/flutter_native_splash):
```bash
flutter pub add flutter_native_splash --dev
# Configure in pubspec.yaml
flutter pub run flutter_native_splash:create
```

## Theme Customization

### Colors

Edit `lib/core/theme/app_colors.dart`:

```dart
abstract class AppColors {
  // Primary Colors - Change to your brand color
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981);
  
  // ... customize other colors
}
```

### Typography

Edit `lib/core/theme/app_typography.dart`:

```dart
// Change font family
static const String _fontFamily = 'YourFont';

// Or use Google Fonts
return GoogleFonts.yourFont(
  fontSize: fontSize,
  fontWeight: fontWeight,
);
```

### Component Themes

Edit `lib/core/theme/app_theme.dart` to customize:
- Button styles
- Input decoration
- Card themes
- Dialog styles
- Navigation themes

## API Configuration

### Base URL

Edit `lib/core/constants/api_constants.dart`:

```dart
abstract class ApiConstants {
  static const String baseUrl = 'https://your-api.com/v1';
  
  // Update endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  // ...
}
```

### Timeouts

```dart
static const Duration connectionTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
```

### Headers

Modify `lib/core/network/api_client.dart` or add custom interceptors.

## Adding Features

### 1. Create Feature Folder

```
lib/features/your_feature/
├── data/
│   ├── datasources/
│   │   ├── your_feature_remote_datasource.dart
│   │   └── your_feature_local_datasource.dart
│   ├── models/
│   │   └── your_model.dart
│   └── repositories/
│       └── your_feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── your_entity.dart
│   ├── repositories/
│   │   └── your_feature_repository.dart
│   └── usecases/
│       └── your_usecase.dart
└── presentation/
    ├── providers/
    │   └── your_feature_provider.dart
    ├── screens/
    │   └── your_feature_screen.dart
    └── widgets/
        └── your_widget.dart
```

### 2. Create Entity

```dart
// lib/features/your_feature/domain/entities/your_entity.dart
class YourEntity extends Equatable {
  final String id;
  final String name;
  
  const YourEntity({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
}
```

### 3. Create Model

```dart
// lib/features/your_feature/data/models/your_model.dart
class YourModel extends YourEntity {
  const YourModel({required super.id, required super.name});
  
  factory YourModel.fromJson(Map<String, dynamic> json) {
    return YourModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### 4. Create Provider

```dart
// lib/features/your_feature/presentation/providers/your_feature_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'your_feature_provider.g.dart';

@riverpod
class YourFeatureNotifier extends _$YourFeatureNotifier {
  @override
  YourState build() => const YourState();
  
  Future<void> loadData() async {
    // Implementation
  }
}
```

### 5. Add Route

Edit `lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: '/your-feature',
  name: 'yourFeature',
  builder: (context, state) => const YourFeatureScreen(),
),
```

### 6. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Localization

### Add New Language

1. Create `lib/l10n/app_fr.arb` (for French):
```json
{
  "@@locale": "fr",
  "appName": "Mon Application",
  "welcome": "Bienvenue"
}
```

2. Run Flutter to generate:
```bash
flutter pub get
```

### Add New Strings

1. Add to `lib/l10n/app_en.arb`:
```json
{
  "newString": "New String",
  "@newString": {
    "description": "Description for translators"
  }
}
```

2. Add translations to other `.arb` files
3. Use in code:
```dart
import 'package:flutter_starter_pro/l10n/generated/app_localizations.dart';

Text(AppLocalizations.of(context).newString)
```

## Environment Configuration

### Using Dart Defines

```bash
# Development
flutter run --dart-define=ENV=development

# Production
flutter run --dart-define=ENV=production
```

### Access in Code

```dart
const String environment = String.fromEnvironment('ENV', defaultValue: 'development');

abstract class Config {
  static String get apiUrl {
    switch (environment) {
      case 'production':
        return 'https://api.production.com';
      case 'staging':
        return 'https://api.staging.com';
      default:
        return 'https://api.development.com';
    }
  }
}
```

### Multiple Entry Points

Create separate main files:

```dart
// lib/main_dev.dart
void main() {
  bootstrap((localStorage) => App(
    localStorage: localStorage,
    environment: Environment.development,
  ));
}

// lib/main_prod.dart
void main() {
  bootstrap((localStorage) => App(
    localStorage: localStorage,
    environment: Environment.production,
  ));
}
```

---

For more customization options, check the source code comments or open an issue on GitHub.

