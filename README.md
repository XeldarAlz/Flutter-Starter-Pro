<p align="center">
  <img src="assets/images/logo.png" alt="Flutter Starter Pro" width="120"/>
</p>

<h1 align="center">Flutter Starter Pro</h1>

<p align="center">
  <strong>A production-ready Flutter starter with clean architecture, Riverpod, and everything you need to ship fast.</strong>
</p>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?style=for-the-badge&logo=dart" alt="Dart"/>
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License"/>
  </a>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#project-structure">Structure</a> •
  <a href="#customization">Customization</a> •
  <a href="#testing">Testing</a> •
  <a href="#contributing">Contributing</a>
</p>

---

## ✨ Features

- **🏗️ Clean Architecture** — Scalable, testable, maintainable code structure
- **⚡ Riverpod 2.0** — Modern state management with code generation
- **🧭 GoRouter** — Declarative routing with deep linking support
- **🌐 Dio + Retrofit** — Type-safe API calls with interceptors
- **🔐 Secure Storage** — Token management done right
- **🎨 Theming System** — Light/Dark mode with Material 3
- **🌍 Localization** — i18n ready with ARB files (English, Spanish)
- **🧪 Testing Setup** — Unit, Widget, and Integration tests
- **🚀 CI/CD Ready** — GitHub Actions workflows included
- **📱 Responsive** — Adaptive layouts for all screen sizes

## 🚀 Quick Start

### Prerequisites

- Flutter 3.24+
- Dart 3.2+

### Installation

```bash
# Clone the repository
git clone https://github.com/YOURUSERNAME/flutter-starter-pro.git
cd flutter-starter-pro

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Using as Template

Click **"Use this template"** button on GitHub, or:

```bash
# Create new project from template
gh repo create my-app --template YOURUSERNAME/flutter-starter-pro
```

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities and configuration
│   ├── constants/           # App, API, and storage constants
│   ├── errors/              # Exception and failure handling
│   ├── extensions/          # Dart extensions (context, string, date)
│   ├── network/             # API client and interceptors
│   ├── router/              # GoRouter configuration
│   ├── storage/             # Local and secure storage
│   ├── theme/               # Colors, typography, theme
│   └── utils/               # Validators, formatters, logger
├── features/                # Feature modules
│   ├── auth/                # Authentication feature
│   │   ├── data/            # Models, data sources, repositories
│   │   ├── domain/          # Entities, use cases
│   │   └── presentation/    # Screens, widgets, providers
│   ├── home/                # Home/Dashboard feature
│   ├── settings/            # Settings feature
│   └── onboarding/          # Onboarding feature
├── shared/                  # Shared widgets and providers
│   ├── widgets/             # Reusable UI components
│   └── providers/           # Global providers
├── l10n/                    # Localization files
├── app.dart                 # App widget
├── bootstrap.dart           # App initialization
└── main.dart                # Entry point
```

[See full architecture documentation](docs/ARCHITECTURE.md)

## 🎨 Customization

### Theme

Edit `lib/core/theme/app_colors.dart`:

```dart
static const Color primary = Color(0xFF6366F1); // Your brand color
static const Color secondary = Color(0xFF10B981);
```

### API Configuration

Edit `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'https://your-api.com/v1';
```

### Add New Feature

1. Create feature folder under `lib/features/`
2. Add data, domain, and presentation layers
3. Register routes in `lib/core/router/app_router.dart`

[See full customization guide](docs/CUSTOMIZATION.md)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) before submitting a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/YOURUSERNAME">Your Name</a>
</p>

<p align="center">
  ⭐ Star this repo if you found it helpful!
</p>
