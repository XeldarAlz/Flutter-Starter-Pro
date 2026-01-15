# Flutter Starter Pro - Comprehensive Improvement Plan

A detailed roadmap to transform Flutter Starter Pro into an industry-leading production-ready boilerplate.

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Assessment](#current-state-assessment)
3. [Architecture Improvements](#architecture-improvements)
4. [Environment & Configuration](#environment--configuration)
5. [Testing Strategy](#testing-strategy)
6. [Core Infrastructure](#core-infrastructure)
7. [Authentication & Security](#authentication--security)
8. [Networking & Data](#networking--data)
9. [UI/UX Components](#uiux-components)
10. [Developer Experience](#developer-experience)
11. [DevOps & CI/CD](#devops--cicd)
12. [Monitoring & Analytics](#monitoring--analytics)
13. [Platform-Specific Features](#platform-specific-features)
14. [Documentation](#documentation)
15. [Package Recommendations](#package-recommendations)
16. [File Structure](#file-structure)
17. [Implementation Priority](#implementation-priority)
18. [Competitor Analysis](#competitor-analysis)

---

## Executive Summary

### Vision
Transform Flutter Starter Pro into the **most comprehensive, production-ready Flutter boilerplate** that enables developers to start building production apps immediately without reinventing foundational architecture.

### Goals
- **Zero to Production in Hours**: All boilerplate code ready out-of-the-box
- **Industry Best Practices**: Following Flutter team and community standards
- **Enterprise-Grade**: Security, scalability, and maintainability built-in
- **Developer Delight**: Excellent DX with tooling, documentation, and automation
- **Flexibility**: Modular architecture allowing easy customization

### Success Metrics
| Metric | Target |
|--------|--------|
| Test Coverage | 80%+ |
| Documentation Coverage | 100% public APIs |
| Setup Time | < 30 minutes to first build |
| Build Time | < 3 minutes for clean build |
| GitHub Stars | Top 10 Flutter boilerplate repositories |

---

## Current State Assessment

### Strengths
| Area | Status | Details |
|------|--------|---------|
| Architecture | Good | Clean Architecture + Feature-First |
| State Management | Good | Riverpod 2.0 with code generation |
| Routing | Good | GoRouter with guards |
| Network Layer | Good | Dio with interceptors |
| Theming | Good | Material 3, Light/Dark modes |
| CI/CD | Good | GitHub Actions workflows |
| Linting | Good | Very Good Analysis |

### Gaps to Address
| Area | Current State | Target State | Priority |
|------|--------------|--------------|----------|
| Environment Config | Hardcoded | Multi-flavor (dev/staging/prod) | Critical |
| Test Coverage | ~5% | 80%+ | Critical |
| Use Cases | Missing | Complete implementation | High |
| Repository Pattern | Partial | Full interfaces + implementations | High |
| Crash Reporting | None | Sentry/Crashlytics | High |
| Offline Support | None | Full offline-first capability | High |
| Social Auth | None | Google, Apple Sign-In | Medium |
| Push Notifications | None | FCM + Local notifications | Medium |
| Analytics | None | Firebase/Mixpanel abstraction | Medium |
| Mason Bricks | None | Feature/Screen generators | Medium |

---

## Architecture Improvements

### 1. Complete Clean Architecture Implementation

#### Current Issue
The domain layer is incomplete - missing Use Cases and Repository interfaces.

#### Solution

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart       # API calls
│   │   ├── auth_remote_datasource_impl.dart  # Implementation
│   │   ├── auth_local_datasource.dart        # Cache interface
│   │   └── auth_local_datasource_impl.dart   # Cache implementation
│   ├── models/
│   │   ├── user_model.dart                   # API response model
│   │   └── token_model.dart                  # Token model
│   └── repositories/
│       └── auth_repository_impl.dart         # Repository implementation
├── domain/
│   ├── entities/
│   │   └── user.dart                         # Business entity
│   ├── repositories/
│   │   └── auth_repository.dart              # Abstract repository
│   └── usecases/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       ├── sign_out_usecase.dart
│       ├── forgot_password_usecase.dart
│       ├── get_current_user_usecase.dart
│       └── update_user_usecase.dart
└── presentation/
    ├── providers/
    │   └── auth_provider.dart
    ├── screens/
    └── widgets/
```

#### Use Case Pattern

```dart
// lib/core/usecases/usecase.dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

// lib/features/auth/domain/usecases/sign_in_usecase.dart
class SignInUseCase implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
```

#### Repository Pattern

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> forgotPassword({required String email});

  Future<Either<Failure, User>> updateUser({required User user});

  Stream<User?> get authStateChanges;
}

// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signIn(email, password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  // ... other implementations
}
```

### 2. Dependency Injection Layer

Add explicit DI configuration using Riverpod.

```dart
// lib/core/di/injection_container.dart

// Data Sources
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
}

@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
    localStorage: ref.watch(localStorageProvider),
  );
}

// Repositories
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

// Use Cases
@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}
```

---

## Environment & Configuration

### 1. Multi-Environment Setup (Critical)

#### Directory Structure

```
lib/
├── config/
│   ├── env/
│   │   ├── app_environment.dart    # Base environment class
│   │   ├── dev_environment.dart    # Development config
│   │   ├── staging_environment.dart # Staging config
│   │   └── prod_environment.dart   # Production config
│   └── app_config.dart             # Global configuration
├── main_dev.dart                   # Dev entry point
├── main_staging.dart               # Staging entry point
├── main_prod.dart                  # Production entry point
└── main.dart                       # Default (dev)
```

#### Environment Configuration

```dart
// lib/config/env/app_environment.dart
abstract class AppEnvironment {
  String get name;
  String get baseUrl;
  String get sentryDsn;
  String get firebaseProjectId;
  bool get enableLogging;
  bool get enableCrashReporting;
  bool get enableAnalytics;
  Duration get connectionTimeout;
  Duration get receiveTimeout;

  // Feature flags
  bool get enableBiometricAuth;
  bool get enableSocialAuth;
  bool get enableOfflineMode;
}

// lib/config/env/dev_environment.dart
class DevEnvironment implements AppEnvironment {
  @override
  String get name => 'development';

  @override
  String get baseUrl => 'https://dev-api.example.com/v1';

  @override
  String get sentryDsn => 'https://dev-key@sentry.io/123';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashReporting => false;

  @override
  bool get enableAnalytics => false;

  @override
  Duration get connectionTimeout => const Duration(seconds: 60);

  @override
  Duration get receiveTimeout => const Duration(seconds: 60);

  @override
  bool get enableBiometricAuth => true;

  @override
  bool get enableSocialAuth => true;

  @override
  bool get enableOfflineMode => true;
}

// lib/config/env/prod_environment.dart
class ProdEnvironment implements AppEnvironment {
  @override
  String get name => 'production';

  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  @override
  bool get enableLogging => false;

  @override
  bool get enableCrashReporting => true;

  @override
  bool get enableAnalytics => true;

  @override
  Duration get connectionTimeout => const Duration(seconds: 30);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  @override
  bool get enableBiometricAuth => true;

  @override
  bool get enableSocialAuth => true;

  @override
  bool get enableOfflineMode => true;
}
```

#### Entry Points

```dart
// lib/main_dev.dart
void main() {
  bootstrap(DevEnvironment());
}

// lib/main_staging.dart
void main() {
  bootstrap(StagingEnvironment());
}

// lib/main_prod.dart
void main() {
  bootstrap(ProdEnvironment());
}

// lib/bootstrap.dart
Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting
  if (environment.enableCrashReporting) {
    await SentryFlutter.init(
      (options) {
        options.dsn = environment.sentryDsn;
        options.environment = environment.name;
      },
    );
  }

  // Initialize analytics
  if (environment.enableAnalytics) {
    await Analytics.initialize();
  }

  // Store environment for access throughout app
  runApp(
    ProviderScope(
      overrides: [
        environmentProvider.overrideWithValue(environment),
      ],
      child: const App(),
    ),
  );
}
```

#### Platform-Specific Configurations

**Android - build.gradle**
```groovy
android {
    flavorDimensions "environment"

    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "Starter Pro Dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "Starter Pro Staging"
        }
        prod {
            dimension "environment"
            resValue "string", "app_name", "Starter Pro"
        }
    }
}
```

**iOS - Schemes**
Create separate schemes for Dev, Staging, and Prod with different bundle identifiers and configurations.

#### Launch Configurations

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_staging.dart",
      "args": ["--flavor", "staging"]
    },
    {
      "name": "Prod",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": ["--flavor", "prod"]
    }
  ]
}
```

### 2. Secrets Management

```dart
// lib/config/secrets.dart
// DO NOT commit actual values - use CI/CD secrets

class Secrets {
  // Loaded from environment variables or secure storage
  static String get apiKey => const String.fromEnvironment('API_KEY');
  static String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
  static String get googleMapsKey => const String.fromEnvironment('GOOGLE_MAPS_KEY');

  // Social auth
  static String get googleClientId => const String.fromEnvironment('GOOGLE_CLIENT_ID');
  static String get appleClientId => const String.fromEnvironment('APPLE_CLIENT_ID');
}
```

---

## Testing Strategy

### 1. Test Structure

```
test/
├── unit/
│   ├── core/
│   │   ├── extensions/
│   │   │   ├── string_extensions_test.dart
│   │   │   └── date_extensions_test.dart
│   │   ├── utils/
│   │   │   ├── validators_test.dart
│   │   │   └── formatters_test.dart
│   │   └── network/
│   │       └── api_client_test.dart
│   └── features/
│       └── auth/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── auth_remote_datasource_test.dart
│           │   └── repositories/
│           │       └── auth_repository_impl_test.dart
│           └── domain/
│               └── usecases/
│                   ├── sign_in_usecase_test.dart
│                   └── sign_up_usecase_test.dart
├── widget/
│   ├── shared/
│   │   └── widgets/
│   │       ├── primary_button_test.dart
│   │       └── text_input_test.dart
│   └── features/
│       └── auth/
│           └── presentation/
│               ├── screens/
│               │   └── login_screen_test.dart
│               └── widgets/
├── integration/
│   ├── auth_flow_test.dart
│   ├── onboarding_flow_test.dart
│   └── settings_flow_test.dart
├── golden/
│   ├── login_screen_golden_test.dart
│   └── home_screen_golden_test.dart
├── fixtures/
│   ├── user_fixture.json
│   ├── token_fixture.json
│   └── error_fixture.json
├── mocks/
│   ├── mock_auth_repository.dart
│   ├── mock_api_client.dart
│   └── mock_secure_storage.dart
└── helpers/
    ├── test_helpers.dart
    ├── pump_app.dart
    └── golden_test_helpers.dart
```

### 2. Test Examples

#### Unit Test - Use Case

```dart
// test/unit/features/auth/domain/usecases/sign_in_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';
  const tUser = User(id: '1', email: tEmail, name: 'Test User');

  group('SignInUseCase', () {
    test('should return User when sign in is successful', () async {
      // Arrange
      when(() => mockRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase(
        const SignInParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.signIn(
        email: tEmail,
        password: tPassword,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when sign in fails', () async {
      // Arrange
      when(() => mockRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => Left(ServerFailure('Invalid credentials')));

      // Act
      final result = await useCase(
        const SignInParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Invalid credentials'),
        (_) => fail('Should return failure'),
      );
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(() => mockRepository.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => Left(NetworkFailure('No internet')));

      // Act
      final result = await useCase(
        const SignInParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
```

#### Unit Test - Repository

```dart
// test/unit/features/auth/data/repositories/auth_repository_impl_test.dart
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('signIn', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password';
    final tUserModel = UserModel(id: '1', email: tEmail);

    test('should check if device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signIn(any(), any()))
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheUser(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.signIn(email: tEmail, password: tPassword);

      // Assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return User when call is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.signIn(any(), any()))
            .thenAnswer((_) async => tUserModel);
        when(() => mockLocalDataSource.cacheUser(any()))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, Right(tUserModel));
      });

      test('should cache user when call is successful', () async {
        // Arrange
        when(() => mockRemoteDataSource.signIn(any(), any()))
            .thenAnswer((_) async => tUserModel);
        when(() => mockLocalDataSource.cacheUser(any()))
            .thenAnswer((_) async {});

        // Act
        await repository.signIn(email: tEmail, password: tPassword);

        // Assert
        verify(() => mockLocalDataSource.cacheUser(tUserModel)).called(1);
      });

      test('should return ServerFailure when call fails', () async {
        // Arrange
        when(() => mockRemoteDataSource.signIn(any(), any()))
            .thenThrow(ServerException(message: 'Server error'));

        // Act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<Left>());
      });
    });

    group('device is offline', () {
      test('should return NetworkFailure when offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Should return failure'),
        );
      });
    });
  });
}
```

#### Widget Test

```dart
// test/widget/shared/widgets/primary_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('should display text', (tester) async {
      await tester.pumpApp(
        PrimaryButton(
          text: 'Click Me',
          onPressed: () {},
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpApp(
        PrimaryButton(
          text: 'Click Me',
          onPressed: () => pressed = true,
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      await tester.pumpApp(
        PrimaryButton(
          text: 'Click Me',
          onPressed: () {},
          isLoading: true,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Click Me'), findsNothing);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpApp(
        const PrimaryButton(
          text: 'Click Me',
          onPressed: null,
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should display icon when provided', (tester) async {
      await tester.pumpApp(
        PrimaryButton(
          text: 'Click Me',
          onPressed: () {},
          icon: Icons.check,
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
```

#### Integration Test

```dart
// integration_test/auth_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('should complete full login flow', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Should start on onboarding or login screen
      expect(
        find.byType(LoginScreen).evaluate().isNotEmpty ||
        find.byType(OnboardingScreen).evaluate().isNotEmpty,
        true,
      );

      // If on onboarding, complete it
      if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Now on login screen
      expect(find.byType(LoginScreen), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_input')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_input')),
        'Password123!',
      );

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Should navigate to home screen on success
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should show error on invalid credentials', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Navigate to login if needed
      // ...

      // Enter invalid credentials
      await tester.enterText(
        find.byKey(const Key('email_input')),
        'invalid@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_input')),
        'wrongpassword',
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Should show error snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
```

#### Golden Test

```dart
// test/golden/login_screen_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('LoginScreen Golden Tests', () {
    testGoldens('should match light mode', (tester) async {
      await tester.pumpWidgetBuilder(
        const LoginScreen(),
        wrapper: materialAppWrapper(
          theme: AppTheme.lightTheme,
        ),
        surfaceSize: const Size(375, 812), // iPhone X
      );

      await screenMatchesGolden(tester, 'login_screen_light');
    });

    testGoldens('should match dark mode', (tester) async {
      await tester.pumpWidgetBuilder(
        const LoginScreen(),
        wrapper: materialAppWrapper(
          theme: AppTheme.darkTheme,
        ),
        surfaceSize: const Size(375, 812),
      );

      await screenMatchesGolden(tester, 'login_screen_dark');
    });

    testGoldens('should match loading state', (tester) async {
      await tester.pumpWidgetBuilder(
        const LoginScreen(initialLoading: true),
        wrapper: materialAppWrapper(theme: AppTheme.lightTheme),
        surfaceSize: const Size(375, 812),
      );

      await screenMatchesGolden(tester, 'login_screen_loading');
    });

    testGoldens('should match error state', (tester) async {
      await tester.pumpWidgetBuilder(
        const LoginScreen(initialError: 'Invalid credentials'),
        wrapper: materialAppWrapper(theme: AppTheme.lightTheme),
        surfaceSize: const Size(375, 812),
      );

      await screenMatchesGolden(tester, 'login_screen_error');
    });
  });
}
```

### 3. Test Helpers

```dart
// test/helpers/pump_app.dart
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      ProviderScope(
        overrides: [],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  Future<void> pumpAppWithRouter(Widget widget) async {
    await pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: testRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
        ),
      ),
    );
  }
}

// test/helpers/test_helpers.dart
class TestHelpers {
  static User createTestUser({
    String id = '1',
    String email = 'test@example.com',
    String? name,
  }) {
    return User(id: id, email: email, name: name);
  }

  static TokenModel createTestToken({
    String accessToken = 'test_access_token',
    String refreshToken = 'test_refresh_token',
    int expiresIn = 3600,
  }) {
    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}
```

### 4. Coverage Configuration

```yaml
# .github/workflows/ci.yml (test job)
test:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
    - name: Run tests with coverage
      run: flutter test --coverage
    - name: Check coverage threshold
      run: |
        COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | cut -d ' ' -f 4 | cut -d '%' -f 1)
        if (( $(echo "$COVERAGE < 80" | bc -l) )); then
          echo "Coverage is below 80%: $COVERAGE%"
          exit 1
        fi
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v4
      with:
        files: coverage/lcov.info
        fail_ci_if_error: true
```

---

## Core Infrastructure

### 1. Offline-First Architecture

```dart
// lib/core/sync/sync_manager.dart
abstract class SyncManager {
  Future<void> sync();
  Future<void> syncEntity<T>(String entityType);
  Stream<SyncStatus> get syncStatusStream;
  bool get isSyncing;
  DateTime? get lastSyncTime;
}

class SyncManagerImpl implements SyncManager {
  final LocalDatabase localDatabase;
  final ApiClient apiClient;
  final NetworkInfo networkInfo;
  final Queue<SyncOperation> _pendingOperations = Queue();

  @override
  Future<void> sync() async {
    if (!await networkInfo.isConnected) return;

    // Process pending operations
    while (_pendingOperations.isNotEmpty) {
      final operation = _pendingOperations.first;
      try {
        await _processOperation(operation);
        _pendingOperations.removeFirst();
      } catch (e) {
        // Retry later
        break;
      }
    }

    // Fetch updates from server
    await _fetchUpdates();
  }

  Future<void> queueOperation(SyncOperation operation) async {
    _pendingOperations.add(operation);
    await _persistQueue();

    // Try to sync immediately if online
    if (await networkInfo.isConnected) {
      sync();
    }
  }
}

// lib/core/sync/sync_operation.dart
class SyncOperation {
  final String id;
  final String entityType;
  final String entityId;
  final SyncOperationType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;

  const SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.type,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
  });
}

enum SyncOperationType { create, update, delete }
```

### 2. Connectivity Handling

```dart
// lib/core/network/connectivity_service.dart
@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  StreamSubscription? _subscription;

  @override
  ConnectivityStatus build() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      state = _mapResult(result);
    });

    ref.onDispose(() => _subscription?.cancel());

    return ConnectivityStatus.unknown;
  }

  ConnectivityStatus _mapResult(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.mobile;
    }
    return ConnectivityStatus.online;
  }
}

enum ConnectivityStatus { online, offline, wifi, mobile, unknown }

// lib/shared/widgets/connectivity_banner.dart
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityNotifierProvider);

    if (status == ConnectivityStatus.offline) {
      return MaterialBanner(
        content: const Text('No internet connection'),
        backgroundColor: context.colorScheme.error,
        leading: const Icon(Icons.wifi_off),
        actions: [
          TextButton(
            onPressed: () => ref.read(syncManagerProvider).sync(),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
```

### 3. Pagination Helper

```dart
// lib/core/pagination/paginated_list.dart
class PaginatedList<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedList({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedList.fromResponse(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = json['data'] as List;
    final meta = json['meta'] as Map<String, dynamic>;

    return PaginatedList(
      items: data.map((e) => fromJson(e)).toList(),
      currentPage: meta['current_page'],
      totalPages: meta['last_page'],
      totalItems: meta['total'],
      hasNextPage: meta['current_page'] < meta['last_page'],
      hasPreviousPage: meta['current_page'] > 1,
    );
  }
}

// lib/core/pagination/pagination_params.dart
class PaginationParams {
  final int page;
  final int limit;
  final String? sortBy;
  final String? sortOrder;
  final Map<String, dynamic>? filters;

  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.sortOrder,
    this.filters,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page,
      'limit': limit,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (filters != null) ...filters!,
    };
  }

  PaginationParams copyWith({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      filters: filters ?? this.filters,
    );
  }
}

// lib/shared/widgets/paginated_list_view.dart
class PaginatedListView<T> extends StatelessWidget {
  final PaginatedList<T>? data;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final Widget Function(T item) itemBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRefresh;

  const PaginatedListView({
    super.key,
    required this.data,
    required this.isLoading,
    required this.isLoadingMore,
    required this.itemBuilder,
    this.error,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.onLoadMore,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && data == null) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    if (error != null && data == null) {
      return errorWidget ?? Center(child: Text(error!));
    }

    if (data?.items.isEmpty ?? true) {
      return emptyWidget ?? const Center(child: Text('No items'));
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        itemCount: data!.items.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == data!.items.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Load more when reaching near the end
          if (index == data!.items.length - 3 && data!.hasNextPage) {
            onLoadMore?.call();
          }

          return itemBuilder(data!.items[index]);
        },
      ),
    );
  }
}
```

### 4. Form State Management

```dart
// lib/core/form/form_state_notifier.dart
@riverpod
class FormStateNotifier<T> extends _$FormStateNotifier<T> {
  @override
  FormState<T> build() => FormState<T>.initial();

  void updateField(String field, dynamic value) {
    state = state.copyWith(
      values: {...state.values, field: value},
      touched: {...state.touched, field: true},
    );
    _validateField(field, value);
  }

  void _validateField(String field, dynamic value) {
    final validator = state.validators[field];
    if (validator != null) {
      final error = validator(value);
      state = state.copyWith(
        errors: {...state.errors, field: error},
      );
    }
  }

  bool validate() {
    final errors = <String, String?>{};
    for (final entry in state.validators.entries) {
      final error = entry.value(state.values[entry.key]);
      errors[entry.key] = error;
    }
    state = state.copyWith(errors: errors);
    return !errors.values.any((e) => e != null);
  }

  void reset() {
    state = FormState<T>.initial();
  }

  void setSubmitting(bool submitting) {
    state = state.copyWith(isSubmitting: submitting);
  }
}

class FormState<T> {
  final Map<String, dynamic> values;
  final Map<String, String?> errors;
  final Map<String, bool> touched;
  final Map<String, String? Function(dynamic)> validators;
  final bool isSubmitting;
  final bool isValid;

  const FormState({
    required this.values,
    required this.errors,
    required this.touched,
    required this.validators,
    required this.isSubmitting,
    required this.isValid,
  });

  factory FormState.initial() => const FormState(
    values: {},
    errors: {},
    touched: {},
    validators: {},
    isSubmitting: false,
    isValid: false,
  );

  FormState<T> copyWith({
    Map<String, dynamic>? values,
    Map<String, String?>? errors,
    Map<String, bool>? touched,
    Map<String, String? Function(dynamic)>? validators,
    bool? isSubmitting,
  }) {
    final newErrors = errors ?? this.errors;
    return FormState(
      values: values ?? this.values,
      errors: newErrors,
      touched: touched ?? this.touched,
      validators: validators ?? this.validators,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValid: !newErrors.values.any((e) => e != null),
    );
  }
}
```

---

## Authentication & Security

### 1. Biometric Authentication

```dart
// lib/features/auth/data/datasources/biometric_auth_datasource.dart
abstract class BiometricAuthDataSource {
  Future<bool> isAvailable();
  Future<BiometricType?> getAvailableType();
  Future<bool> authenticate({required String reason});
}

class BiometricAuthDataSourceImpl implements BiometricAuthDataSource {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return canCheck && isDeviceSupported;
  }

  @override
  Future<BiometricType?> getAvailableType() async {
    final types = await _localAuth.getAvailableBiometrics();
    if (types.contains(BiometricType.face)) return BiometricType.face;
    if (types.contains(BiometricType.fingerprint)) {
      return BiometricType.fingerprint;
    }
    return null;
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
```

### 2. Social Authentication

```dart
// lib/features/auth/data/datasources/social_auth_datasource.dart
abstract class SocialAuthDataSource {
  Future<SocialAuthResult> signInWithGoogle();
  Future<SocialAuthResult> signInWithApple();
  Future<void> signOut();
}

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  Future<SocialAuthResult> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return SocialAuthResult.cancelled();
      }

      final auth = await account.authentication;
      return SocialAuthResult.success(
        provider: 'google',
        idToken: auth.idToken,
        accessToken: auth.accessToken,
        email: account.email,
        name: account.displayName,
        photoUrl: account.photoUrl,
      );
    } catch (e) {
      return SocialAuthResult.error(e.toString());
    }
  }

  @override
  Future<SocialAuthResult> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return SocialAuthResult.success(
        provider: 'apple',
        idToken: credential.identityToken,
        authorizationCode: credential.authorizationCode,
        email: credential.email,
        name: [
          credential.givenName,
          credential.familyName,
        ].whereType<String>().join(' '),
      );
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException &&
          e.code == AuthorizationErrorCode.canceled) {
        return SocialAuthResult.cancelled();
      }
      return SocialAuthResult.error(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

class SocialAuthResult {
  final SocialAuthStatus status;
  final String? provider;
  final String? idToken;
  final String? accessToken;
  final String? authorizationCode;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? error;

  const SocialAuthResult._({
    required this.status,
    this.provider,
    this.idToken,
    this.accessToken,
    this.authorizationCode,
    this.email,
    this.name,
    this.photoUrl,
    this.error,
  });

  factory SocialAuthResult.success({
    required String provider,
    String? idToken,
    String? accessToken,
    String? authorizationCode,
    String? email,
    String? name,
    String? photoUrl,
  }) =>
      SocialAuthResult._(
        status: SocialAuthStatus.success,
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
        authorizationCode: authorizationCode,
        email: email,
        name: name,
        photoUrl: photoUrl,
      );

  factory SocialAuthResult.cancelled() =>
      const SocialAuthResult._(status: SocialAuthStatus.cancelled);

  factory SocialAuthResult.error(String message) =>
      SocialAuthResult._(status: SocialAuthStatus.error, error: message);
}

enum SocialAuthStatus { success, cancelled, error }
```

### 3. Token Management Enhancement

```dart
// lib/core/auth/token_manager.dart
abstract class TokenManager {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens(TokenModel tokens);
  Future<void> clearTokens();
  Future<bool> isTokenValid();
  Future<bool> refreshTokens();
}

class TokenManagerImpl implements TokenManager {
  final SecureStorage secureStorage;
  final ApiClient apiClient;

  static const _tokenExpiryBuffer = Duration(minutes: 5);

  TokenManagerImpl({
    required this.secureStorage,
    required this.apiClient,
  });

  @override
  Future<bool> isTokenValid() async {
    final expiryString = await secureStorage.read(StorageKeys.tokenExpiry);
    if (expiryString == null) return false;

    final expiry = DateTime.parse(expiryString);
    return expiry.isAfter(DateTime.now().add(_tokenExpiryBuffer));
  }

  @override
  Future<bool> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final tokens = TokenModel.fromJson(response.data);
      await saveTokens(tokens);
      return true;
    } catch (e) {
      await clearTokens();
      return false;
    }
  }

  @override
  Future<void> saveTokens(TokenModel tokens) async {
    await Future.wait([
      secureStorage.write(StorageKeys.accessToken, tokens.accessToken),
      secureStorage.write(StorageKeys.refreshToken, tokens.refreshToken),
      secureStorage.write(
        StorageKeys.tokenExpiry,
        DateTime.now()
            .add(Duration(seconds: tokens.expiresIn))
            .toIso8601String(),
      ),
    ]);
  }

  // ... other implementations
}
```

---

## UI/UX Components

### 1. Enhanced Button Components

```dart
// lib/shared/widgets/buttons/loading_button.dart
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final double? width;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isLoading && !isDisabled && onPressed != null;

    return SizedBox(
      width: width ?? double.infinity,
      height: size.height,
      child: _buildButton(context, isEnabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isEnabled) {
    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                variant.loadingColor(context),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size.iconSize),
                const SizedBox(width: 8),
              ],
              Text(text, style: size.textStyle),
            ],
          );

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: variant.style(context, size),
          child: child,
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: variant.style(context, size),
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: variant.style(context, size),
          child: child,
        );
    }
  }
}

enum ButtonVariant { primary, secondary, text }

enum ButtonSize {
  small(height: 36, iconSize: 16),
  medium(height: 48, iconSize: 20),
  large(height: 56, iconSize: 24);

  final double height;
  final double iconSize;

  const ButtonSize({required this.height, required this.iconSize});

  TextStyle get textStyle => switch (this) {
    ButtonSize.small => const TextStyle(fontSize: 14),
    ButtonSize.medium => const TextStyle(fontSize: 16),
    ButtonSize.large => const TextStyle(fontSize: 18),
  };
}
```

### 2. Skeleton Loading Components

```dart
// lib/shared/widgets/skeleton/skeleton_loader.dart
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceVariant,
      highlightColor: context.colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// lib/shared/widgets/skeleton/skeleton_list_tile.dart
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SkeletonLoader(width: 48, height: 48, borderRadius: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 120, height: 16),
                SizedBox(height: 8),
                SkeletonLoader(width: 200, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// lib/shared/widgets/skeleton/skeleton_card.dart
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonLoader(height: 120),
            SizedBox(height: 16),
            SkeletonLoader(width: 150, height: 20),
            SizedBox(height: 8),
            SkeletonLoader(height: 14),
            SizedBox(height: 4),
            SkeletonLoader(width: 200, height: 14),
          ],
        ),
      ),
    );
  }
}
```

### 3. Empty State Component

```dart
// lib/shared/widgets/states/empty_state.dart
class EmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? customImage;

  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
    this.customImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customImage ??
                Icon(
                  icon,
                  size: 80,
                  color: context.colorScheme.outline,
                ),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### 4. Error State Component

```dart
// lib/shared/widgets/states/error_state.dart
class ErrorState extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRetry;
  final String retryText;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.description,
    this.onRetry,
    this.retryText = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### 5. Responsive Layout Components

```dart
// lib/shared/widgets/responsive/responsive_builder.dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= Breakpoints.tablet) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

class Breakpoints {
  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1024;
  static const double widescreen = 1440;
}

// lib/shared/widgets/responsive/responsive_grid.dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _getColumns(constraints.maxWidth);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }

  int _getColumns(double width) {
    if (width >= Breakpoints.desktop) return desktopColumns;
    if (width >= Breakpoints.tablet) return tabletColumns;
    return mobileColumns;
  }
}
```

---

## Developer Experience

### 1. Mason Bricks (Code Generation Templates)

```yaml
# bricks/feature/__brick__/feature.yaml
name: feature
description: Generate a new feature module with Clean Architecture
vars:
  name:
    type: string
    description: Feature name (e.g., "user_profile")
    prompt: What is the feature name?

# Directory structure generated:
# lib/features/{{name.snakeCase()}}/
# ├── data/
# │   ├── datasources/
# │   │   ├── {{name.snakeCase()}}_remote_datasource.dart
# │   │   └── {{name.snakeCase()}}_local_datasource.dart
# │   ├── models/
# │   │   └── {{name.snakeCase()}}_model.dart
# │   └── repositories/
# │       └── {{name.snakeCase()}}_repository_impl.dart
# ├── domain/
# │   ├── entities/
# │   │   └── {{name.snakeCase()}}.dart
# │   ├── repositories/
# │   │   └── {{name.snakeCase()}}_repository.dart
# │   └── usecases/
# │       ├── get_{{name.snakeCase()}}_usecase.dart
# │       └── create_{{name.snakeCase()}}_usecase.dart
# └── presentation/
#     ├── providers/
#     │   └── {{name.snakeCase()}}_provider.dart
#     ├── screens/
#     │   └── {{name.snakeCase()}}_screen.dart
#     └── widgets/
```

```dart
// bricks/feature/__brick__/lib/features/{{name.snakeCase()}}/domain/entities/{{name.snakeCase()}}.dart
import 'package:equatable/equatable.dart';

/// {{name.pascalCase()}} entity representing the core business object.
class {{name.pascalCase()}} extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const {{name.pascalCase()}}({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, createdAt, updatedAt];

  {{name.pascalCase()}} copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {{name.pascalCase()}}(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

```dart
// bricks/feature/__brick__/lib/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/{{name.snakeCase()}}.dart';

/// Abstract repository interface for {{name.pascalCase()}} operations.
abstract class {{name.pascalCase()}}Repository {
  /// Get a single {{name.camelCase()}} by ID.
  Future<Either<Failure, {{name.pascalCase()}}>> get{{name.pascalCase()}}(String id);

  /// Get all {{name.camelCase()}}s with optional pagination.
  Future<Either<Failure, List<{{name.pascalCase()}}>>> get{{name.pascalCase()}}s({
    int page = 1,
    int limit = 20,
  });

  /// Create a new {{name.camelCase()}}.
  Future<Either<Failure, {{name.pascalCase()}}>> create{{name.pascalCase()}}(
    {{name.pascalCase()}} {{name.camelCase()}},
  );

  /// Update an existing {{name.camelCase()}}.
  Future<Either<Failure, {{name.pascalCase()}}>> update{{name.pascalCase()}}(
    {{name.pascalCase()}} {{name.camelCase()}},
  );

  /// Delete a {{name.camelCase()}} by ID.
  Future<Either<Failure, void>> delete{{name.pascalCase()}}(String id);
}
```

#### Usage

```bash
# Install mason
dart pub global activate mason_cli

# Get bricks
mason get

# Generate a new feature
mason make feature --name user_profile

# Generate a new screen
mason make screen --name profile_settings

# Generate a new widget
mason make widget --name user_avatar
```

### 2. VS Code Snippets

```json
// .vscode/flutter.code-snippets
{
  "Riverpod Provider": {
    "prefix": "riverpod",
    "body": [
      "@riverpod",
      "class ${1:Name}Notifier extends _$${1:Name}Notifier {",
      "  @override",
      "  ${2:State} build() {",
      "    return ${3:initialState};",
      "  }",
      "",
      "  ${0}",
      "}"
    ]
  },
  "Use Case": {
    "prefix": "usecase",
    "body": [
      "class ${1:Name}UseCase implements UseCase<${2:ReturnType}, ${3:Params}> {",
      "  final ${4:Repository} repository;",
      "",
      "  ${1:Name}UseCase(this.repository);",
      "",
      "  @override",
      "  Future<Either<Failure, ${2:ReturnType}>> call(${3:Params} params) {",
      "    return repository.${5:method}(${0});",
      "  }",
      "}"
    ]
  },
  "Flutter StatelessWidget": {
    "prefix": "stless",
    "body": [
      "class ${1:Name} extends StatelessWidget {",
      "  const ${1:Name}({super.key});",
      "",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return ${0:Container()};",
      "  }",
      "}"
    ]
  },
  "Flutter ConsumerWidget": {
    "prefix": "consumer",
    "body": [
      "class ${1:Name} extends ConsumerWidget {",
      "  const ${1:Name}({super.key});",
      "",
      "  @override",
      "  Widget build(BuildContext context, WidgetRef ref) {",
      "    return ${0:Container()};",
      "  }",
      "}"
    ]
  }
}
```

### 3. Git Hooks with Lefthook

```yaml
# lefthook.yml
pre-commit:
  parallel: true
  commands:
    format:
      glob: "*.dart"
      run: dart format --set-exit-if-changed {staged_files}
    analyze:
      glob: "*.dart"
      run: flutter analyze {staged_files}

pre-push:
  commands:
    test:
      run: flutter test
    coverage:
      run: |
        flutter test --coverage
        lcov --summary coverage/lcov.info | grep "lines" | awk '{print $4}' | cut -d'%' -f1 | xargs -I {} sh -c 'if [ {} -lt 80 ]; then exit 1; fi'

commit-msg:
  commands:
    conventional:
      run: |
        # Validate conventional commit format
        grep -qE "^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,72}" {1} || exit 1
```

### 4. Makefile for Common Commands

```makefile
# Makefile

.PHONY: help setup clean build test analyze format gen

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Initial project setup
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	@echo "Setup complete!"

clean: ## Clean build artifacts
	flutter clean
	rm -rf coverage/
	rm -rf build/

gen: ## Run code generation
	dart run build_runner build --delete-conflicting-outputs

gen-watch: ## Run code generation in watch mode
	dart run build_runner watch --delete-conflicting-outputs

format: ## Format code
	dart format lib test

analyze: ## Analyze code
	flutter analyze

test: ## Run tests
	flutter test

test-coverage: ## Run tests with coverage
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	@echo "Coverage report: coverage/html/index.html"

build-android: ## Build Android APK
	flutter build apk --release

build-ios: ## Build iOS
	flutter build ios --release --no-codesign

build-web: ## Build Web
	flutter build web --release

# Development
run-dev: ## Run development build
	flutter run --flavor dev -t lib/main_dev.dart

run-staging: ## Run staging build
	flutter run --flavor staging -t lib/main_staging.dart

run-prod: ## Run production build
	flutter run --flavor prod -t lib/main_prod.dart

# Feature generation
feature: ## Generate new feature (usage: make feature name=user_profile)
	mason make feature --name $(name)

# Localization
l10n: ## Generate localization files
	flutter gen-l10n
```

---

## DevOps & CI/CD

### 1. Enhanced CI Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .

      - name: Run analyzer
        run: flutter analyze --fatal-warnings

      - name: Run custom lints
        run: dart run custom_lint

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: analyze
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Run tests with coverage
        run: flutter test --coverage --test-randomize-ordering-seed random

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | cut -d ' ' -f 4 | cut -d '%' -f 1)
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "::error::Coverage is below 80%"
            exit 1
          fi

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info
          fail_ci_if_error: true
          token: ${{ secrets.CODECOV_TOKEN }}

  build-android:
    name: Build Android
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build APK (Dev)
        run: flutter build apk --flavor dev -t lib/main_dev.dart

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: app-dev
          path: build/app/outputs/flutter-apk/app-dev-release.apk

  build-ios:
    name: Build iOS
    runs-on: macos-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build iOS (no codesign)
        run: flutter build ios --flavor dev -t lib/main_dev.dart --no-codesign

  build-web:
    name: Build Web
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build Web
        run: flutter build web --release

      - name: Upload Web build
        uses: actions/upload-artifact@v4
        with:
          name: web-build
          path: build/web
```

### 2. Release Pipeline

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

permissions:
  contents: write

jobs:
  release:
    name: Create Release
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.version }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get version
        id: version
        run: echo "version=${GITHUB_REF#refs/tags/v}" >> $GITHUB_OUTPUT

      - name: Generate changelog
        id: changelog
        uses: orhun/git-cliff-action@v3
        with:
          config: cliff.toml
          args: --latest --strip header
        env:
          OUTPUT: CHANGELOG.md

      - name: Create Release
        uses: softprops/action-gh-release@v2
        with:
          body: ${{ steps.changelog.outputs.content }}
          draft: false
          prerelease: ${{ contains(github.ref, 'beta') || contains(github.ref, 'alpha') }}

  build-android-release:
    name: Build Android Release
    runs-on: ubuntu-latest
    needs: release
    strategy:
      matrix:
        flavor: [dev, staging, prod]
    steps:
      - uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Decode keystore
        if: matrix.flavor == 'prod'
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/upload-keystore.jks
          echo "storeFile=upload-keystore.jks" >> android/key.properties
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build APK
        run: flutter build apk --flavor ${{ matrix.flavor }} -t lib/main_${{ matrix.flavor }}.dart --release

      - name: Build App Bundle
        if: matrix.flavor == 'prod'
        run: flutter build appbundle --flavor prod -t lib/main_prod.dart --release

      - name: Upload to Release
        uses: softprops/action-gh-release@v2
        with:
          files: |
            build/app/outputs/flutter-apk/app-${{ matrix.flavor }}-release.apk
            build/app/outputs/bundle/${{ matrix.flavor }}Release/app-${{ matrix.flavor }}-release.aab

  deploy-web:
    name: Deploy Web
    runs-on: ubuntu-latest
    needs: release
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build Web
        run: flutter build web --release --base-href /flutter-starter-pro/

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: build/web
```

### 3. Dependabot Configuration

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pub"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 10
    groups:
      flutter-deps:
        patterns:
          - "flutter*"
          - "riverpod*"
      firebase:
        patterns:
          - "firebase*"
          - "cloud_*"
    ignore:
      - dependency-name: "*"
        update-types: ["version-update:semver-patch"]

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
```

---

## Monitoring & Analytics

### 1. Crash Reporting (Sentry)

```dart
// lib/core/monitoring/crash_reporter.dart
abstract class CrashReporter {
  Future<void> initialize();
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  });
  Future<void> captureMessage(String message, {SeverityLevel? level});
  Future<void> setUser(User? user);
  Future<void> addBreadcrumb(String message, {String? category});
}

class SentryCrashReporter implements CrashReporter {
  final AppEnvironment environment;

  SentryCrashReporter(this.environment);

  @override
  Future<void> initialize() async {
    if (!environment.enableCrashReporting) return;

    await SentryFlutter.init(
      (options) {
        options.dsn = environment.sentryDsn;
        options.environment = environment.name;
        options.tracesSampleRate = environment.name == 'production' ? 0.2 : 1.0;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;
        options.reportPackages = false;
        options.enableAutoPerformanceTracing = true;
      },
    );
  }

  @override
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  }) async {
    if (!environment.enableCrashReporting) return;

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (extras != null) {
          extras.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  @override
  Future<void> setUser(User? user) async {
    if (!environment.enableCrashReporting) return;

    if (user != null) {
      Sentry.configureScope((scope) {
        scope.setUser(SentryUser(
          id: user.id,
          email: user.email,
          username: user.name,
        ));
      });
    } else {
      Sentry.configureScope((scope) => scope.setUser(null));
    }
  }

  @override
  Future<void> addBreadcrumb(String message, {String? category}) async {
    if (!environment.enableCrashReporting) return;

    await Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      category: category,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<void> captureMessage(String message, {SeverityLevel? level}) async {
    if (!environment.enableCrashReporting) return;

    await Sentry.captureMessage(
      message,
      level: level ?? SentryLevel.info,
    );
  }
}
```

### 2. Analytics Abstraction

```dart
// lib/core/analytics/analytics_service.dart
abstract class AnalyticsService {
  Future<void> initialize();
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> logScreenView(String screenName, {String? screenClass});
  Future<void> logLogin({String? loginMethod});
  Future<void> logSignUp({String? signUpMethod});
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
  });
}

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final AppEnvironment environment;

  FirebaseAnalyticsService(this.environment);

  @override
  Future<void> initialize() async {
    if (!environment.enableAnalytics) return;
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    if (!environment.enableAnalytics) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!environment.enableAnalytics) return;
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    if (!environment.enableAnalytics) return;
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> logLogin({String? loginMethod}) async {
    if (!environment.enableAnalytics) return;
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logSignUp({String? signUpMethod}) async {
    if (!environment.enableAnalytics) return;
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    if (!environment.enableAnalytics) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
  }) async {
    if (!environment.enableAnalytics) return;
    await _analytics.logPurchase(
      currency: currency,
      value: value,
      transactionId: transactionId,
    );
  }
}
```

### 3. Performance Monitoring

```dart
// lib/core/monitoring/performance_monitor.dart
abstract class PerformanceMonitor {
  Future<void> initialize();
  Trace startTrace(String name);
  HttpMetric startHttpMetric(String url, String method);
  Future<void> setPerformanceCollectionEnabled(bool enabled);
}

class FirebasePerformanceMonitor implements PerformanceMonitor {
  final FirebasePerformance _performance = FirebasePerformance.instance;
  final AppEnvironment environment;

  FirebasePerformanceMonitor(this.environment);

  @override
  Future<void> initialize() async {
    await setPerformanceCollectionEnabled(environment.enableAnalytics);
  }

  @override
  Trace startTrace(String name) {
    return _performance.newTrace(name);
  }

  @override
  HttpMetric startHttpMetric(String url, String method) {
    return _performance.newHttpMetric(
      url,
      HttpMethod.values.firstWhere(
        (m) => m.name.toUpperCase() == method.toUpperCase(),
        orElse: () => HttpMethod.Get,
      ),
    );
  }

  @override
  Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    await _performance.setPerformanceCollectionEnabled(enabled);
  }
}

// Usage in Dio interceptor
class PerformanceInterceptor extends Interceptor {
  final PerformanceMonitor performanceMonitor;
  final Map<RequestOptions, HttpMetric> _metrics = {};

  PerformanceInterceptor(this.performanceMonitor);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final metric = performanceMonitor.startHttpMetric(
      options.uri.toString(),
      options.method,
    );
    metric.start();
    _metrics[options] = metric;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final metric = _metrics.remove(response.requestOptions);
    if (metric != null) {
      metric.httpResponseCode = response.statusCode;
      metric.responseContentType = response.headers.value('content-type');
      metric.responsePayloadSize = response.data?.toString().length;
      metric.stop();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final metric = _metrics.remove(err.requestOptions);
    if (metric != null) {
      metric.httpResponseCode = err.response?.statusCode;
      metric.stop();
    }
    handler.next(err);
  }
}
```

---

## Platform-Specific Features

### 1. Push Notifications

```dart
// lib/core/notifications/notification_service.dart
abstract class NotificationService {
  Future<void> initialize();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Stream<RemoteMessage> get onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  });
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotifications();
}

class NotificationServiceImpl implements NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels (Android)
    await _createNotificationChannels();

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> _createNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'high_importance',
        'High Importance Notifications',
        description: 'Important notifications that require attention',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'default',
        'Default Notifications',
        description: 'General notifications',
        importance: Importance.defaultImportance,
      ),
    ];

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    for (final channel in channels) {
      await androidPlugin?.createNotificationChannel(channel);
    }
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: payload,
    );
  }

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  // ... other implementations
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Handle background message
  print('Background message: ${message.messageId}');
}
```

### 2. Deep Linking

```dart
// lib/core/deep_link/deep_link_service.dart
abstract class DeepLinkService {
  Future<void> initialize();
  Stream<Uri> get linkStream;
  Future<Uri?> getInitialLink();
}

class DeepLinkServiceImpl implements DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final StreamController<Uri> _linkController = StreamController.broadcast();

  @override
  Future<void> initialize() async {
    // Listen for incoming links
    _appLinks.uriLinkStream.listen((uri) {
      _linkController.add(uri);
    });
  }

  @override
  Stream<Uri> get linkStream => _linkController.stream;

  @override
  Future<Uri?> getInitialLink() async {
    return _appLinks.getInitialLink();
  }
}

// Integration with GoRouter
GoRouter createRouter(DeepLinkService deepLinkService) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [...],
    redirect: (context, state) {
      // Handle deep link navigation
      return null;
    },
  );
}
```

### 3. Force Update

```dart
// lib/core/app_update/app_update_service.dart
abstract class AppUpdateService {
  Future<AppUpdateInfo> checkForUpdate();
  Future<void> openStore();
}

class AppUpdateServiceImpl implements AppUpdateService {
  final ApiClient apiClient;
  final PackageInfo packageInfo;

  AppUpdateServiceImpl({
    required this.apiClient,
    required this.packageInfo,
  });

  @override
  Future<AppUpdateInfo> checkForUpdate() async {
    try {
      final response = await apiClient.get('/app/version');
      final minVersion = Version.parse(response.data['min_version']);
      final latestVersion = Version.parse(response.data['latest_version']);
      final currentVersion = Version.parse(packageInfo.version);

      return AppUpdateInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        minVersion: minVersion,
        isUpdateRequired: currentVersion < minVersion,
        isUpdateAvailable: currentVersion < latestVersion,
        updateUrl: response.data['update_url'],
        releaseNotes: response.data['release_notes'],
      );
    } catch (e) {
      return AppUpdateInfo.noUpdate(
        currentVersion: Version.parse(packageInfo.version),
      );
    }
  }

  @override
  Future<void> openStore() async {
    final url = Platform.isIOS
        ? 'https://apps.apple.com/app/id${AppConstants.appStoreId}'
        : 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class AppUpdateInfo {
  final Version currentVersion;
  final Version latestVersion;
  final Version minVersion;
  final bool isUpdateRequired;
  final bool isUpdateAvailable;
  final String? updateUrl;
  final String? releaseNotes;

  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.minVersion,
    required this.isUpdateRequired,
    required this.isUpdateAvailable,
    this.updateUrl,
    this.releaseNotes,
  });

  factory AppUpdateInfo.noUpdate({required Version currentVersion}) {
    return AppUpdateInfo(
      currentVersion: currentVersion,
      latestVersion: currentVersion,
      minVersion: Version(0, 0, 0),
      isUpdateRequired: false,
      isUpdateAvailable: false,
    );
  }
}

// lib/shared/widgets/dialogs/force_update_dialog.dart
class ForceUpdateDialog extends StatelessWidget {
  final AppUpdateInfo updateInfo;
  final VoidCallback onUpdate;

  const ForceUpdateDialog({
    super.key,
    required this.updateInfo,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A new version (${updateInfo.latestVersion}) is available. '
            'Please update to continue using the app.',
          ),
          if (updateInfo.releaseNotes != null) ...[
            const SizedBox(height: 16),
            const Text('What\'s new:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(updateInfo.releaseNotes!),
          ],
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: onUpdate,
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}
```

---

## Documentation

### 1. API Documentation with Dartdoc

```dart
/// A service for managing user authentication.
///
/// This service handles all authentication-related operations including
/// sign in, sign up, password reset, and session management.
///
/// ## Usage
///
/// ```dart
/// final authService = ref.read(authServiceProvider);
/// final result = await authService.signIn(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (user) => print('Welcome, ${user.name}!'),
/// );
/// ```
///
/// ## Error Handling
///
/// All methods return an [Either] type with [Failure] on the left
/// and the success value on the right. Common failures include:
///
/// - [AuthFailure]: Invalid credentials or unauthorized access
/// - [NetworkFailure]: No internet connection
/// - [ServerFailure]: Server-side errors
///
/// See also:
/// - [AuthRepository] for the underlying repository interface
/// - [User] for the user entity structure
abstract class AuthService {
  /// Signs in a user with email and password.
  ///
  /// Returns the authenticated [User] on success.
  ///
  /// Throws [AuthFailure] if credentials are invalid.
  /// Throws [NetworkFailure] if there's no internet connection.
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });
}
```

### 2. README Structure

```markdown
# Flutter Starter Pro

A production-ready Flutter starter template with Clean Architecture.

## Quick Start

\`\`\`bash
# Clone the repository
git clone https://github.com/user/flutter-starter-pro.git

# Navigate to directory
cd flutter-starter-pro

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
\`\`\`

## Features

- Clean Architecture
- Riverpod State Management
- GoRouter Navigation
- Multi-environment Support
- Authentication (Email, Social, Biometric)
- Offline-first with Sync
- Push Notifications
- Analytics & Crash Reporting
- Localization (i18n)
- Theming (Light/Dark)
- Comprehensive Testing

## Documentation

- [Architecture Guide](docs/ARCHITECTURE.md)
- [Getting Started](docs/GETTING_STARTED.md)
- [Customization](docs/CUSTOMIZATION.md)
- [Testing Guide](docs/TESTING.md)
- [Deployment](docs/DEPLOYMENT.md)
- [API Reference](docs/API.md)

## Commands

| Command | Description |
|---------|-------------|
| `make setup` | Initial project setup |
| `make gen` | Run code generation |
| `make test` | Run tests |
| `make build-android` | Build Android APK |
| `make feature name=xxx` | Generate new feature |

## Environment Setup

1. Copy `.env.example` to `.env`
2. Fill in required values
3. Run with appropriate flavor:

\`\`\`bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor prod -t lib/main_prod.dart
\`\`\`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

This project is licensed under the MIT License.
```

---

## Package Recommendations

### Complete pubspec.yaml Dependencies

```yaml
name: flutter_starter_pro
description: Production-ready Flutter starter template
version: 2.0.0
publish_to: 'none'

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: '>=3.24.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.2.0

  # Network
  dio: ^5.4.3+1
  connectivity_plus: ^6.0.3

  # Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.2.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Firebase (Optional - comment out if not using)
  firebase_core: ^3.1.0
  firebase_crashlytics: ^4.0.1
  firebase_analytics: ^11.0.1
  firebase_messaging: ^15.0.1
  firebase_performance: ^0.10.0+1
  firebase_remote_config: ^5.0.1

  # Authentication
  local_auth: ^2.2.0
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.0

  # Notifications
  flutter_local_notifications: ^17.1.2

  # UI
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  lottie: ^3.1.2
  google_fonts: ^6.2.1
  iconsax: ^0.0.8

  # Utilities
  intl: ^0.20.2
  equatable: ^2.0.5
  dartz: ^0.10.1
  uuid: ^4.4.0
  logger: ^2.3.0
  url_launcher: ^6.2.6
  package_info_plus: ^8.0.0
  permission_handler: ^11.3.1
  app_links: ^6.1.1
  image_picker: ^1.1.0
  image_cropper: ^7.0.5
  in_app_review: ^2.0.9

  # Crash Reporting (Alternative to Firebase)
  sentry_flutter: ^8.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.9
  riverpod_generator: ^2.4.0
  hive_generator: ^2.0.1
  json_serializable: ^6.8.0
  go_router_builder: ^2.4.1

  # Testing
  mocktail: ^1.0.3
  golden_toolkit: ^0.15.0
  patrol: ^3.6.1

  # Linting
  flutter_lints: ^4.0.0
  very_good_analysis: ^6.0.0
  custom_lint: ^0.6.4

  # Development Tools
  flutter_gen_runner: ^5.4.0

flutter:
  generate: true
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

---

## File Structure

### Complete Project Structure

```
flutter_starter_pro/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   └── release.yml
│   ├── dependabot.yml
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── .vscode/
│   ├── launch.json
│   ├── settings.json
│   └── flutter.code-snippets
├── android/
│   ├── app/
│   │   └── build.gradle          # Flavors configuration
│   └── ...
├── ios/
│   ├── Runner/
│   └── ...                       # Schemes for flavors
├── web/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── fonts/
├── bricks/                       # Mason bricks
│   ├── feature/
│   ├── screen/
│   └── widget/
├── lib/
│   ├── config/
│   │   ├── env/
│   │   │   ├── app_environment.dart
│   │   │   ├── dev_environment.dart
│   │   │   ├── staging_environment.dart
│   │   │   └── prod_environment.dart
│   │   └── app_config.dart
│   ├── core/
│   │   ├── analytics/
│   │   │   └── analytics_service.dart
│   │   ├── auth/
│   │   │   └── token_manager.dart
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── storage_keys.dart
│   │   ├── deep_link/
│   │   │   └── deep_link_service.dart
│   │   ├── di/
│   │   │   └── injection_container.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   ├── date_extensions.dart
│   │   │   └── string_extensions.dart
│   │   ├── form/
│   │   │   └── form_state_notifier.dart
│   │   ├── monitoring/
│   │   │   ├── crash_reporter.dart
│   │   │   └── performance_monitor.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── api_interceptors.dart
│   │   │   ├── connectivity_service.dart
│   │   │   └── network_info.dart
│   │   ├── notifications/
│   │   │   └── notification_service.dart
│   │   ├── pagination/
│   │   │   ├── paginated_list.dart
│   │   │   └── pagination_params.dart
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   ├── guards/
│   │   │   └── routes.dart
│   │   ├── storage/
│   │   │   ├── local_storage.dart
│   │   │   └── secure_storage.dart
│   │   ├── sync/
│   │   │   ├── sync_manager.dart
│   │   │   └── sync_operation.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_theme.dart
│   │   │   ├── app_typography.dart
│   │   │   └── theme_provider.dart
│   │   ├── usecases/
│   │   │   └── usecase.dart
│   │   ├── app_update/
│   │   │   └── app_update_service.dart
│   │   └── utils/
│   │       ├── formatters.dart
│   │       ├── logger.dart
│   │       └── validators.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   ├── biometric_auth_datasource.dart
│   │   │   │   │   └── social_auth_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── token_model.dart
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── sign_in_usecase.dart
│   │   │   │       ├── sign_up_usecase.dart
│   │   │   │       ├── sign_out_usecase.dart
│   │   │   │       ├── forgot_password_usecase.dart
│   │   │   │       └── get_current_user_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   ├── register_screen.dart
│   │   │       │   └── forgot_password_screen.dart
│   │   │       └── widgets/
│   │   │           ├── social_login_buttons.dart
│   │   │           └── biometric_login_button.dart
│   │   ├── home/
│   │   ├── onboarding/
│   │   └── settings/
│   ├── shared/
│   │   ├── providers/
│   │   │   └── global_providers.dart
│   │   └── widgets/
│   │       ├── buttons/
│   │       │   ├── loading_button.dart
│   │       │   └── icon_button.dart
│   │       ├── cards/
│   │       │   └── info_card.dart
│   │       ├── dialogs/
│   │       │   ├── confirmation_dialog.dart
│   │       │   └── force_update_dialog.dart
│   │       ├── inputs/
│   │       │   └── text_input.dart
│   │       ├── responsive/
│   │       │   ├── responsive_builder.dart
│   │       │   └── responsive_grid.dart
│   │       ├── skeleton/
│   │       │   ├── skeleton_loader.dart
│   │       │   ├── skeleton_list_tile.dart
│   │       │   └── skeleton_card.dart
│   │       └── states/
│   │           ├── empty_state.dart
│   │           ├── error_state.dart
│   │           └── loading_state.dart
│   ├── l10n/
│   │   ├── app_en.arb
│   │   ├── app_es.arb
│   │   └── app_tr.arb
│   ├── app.dart
│   ├── bootstrap.dart
│   ├── main.dart
│   ├── main_dev.dart
│   ├── main_staging.dart
│   └── main_prod.dart
├── test/
│   ├── unit/
│   ├── widget/
│   ├── integration/
│   ├── golden/
│   ├── fixtures/
│   ├── mocks/
│   └── helpers/
├── integration_test/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── CUSTOMIZATION.md
│   ├── GETTING_STARTED.md
│   ├── TESTING.md
│   ├── DEPLOYMENT.md
│   ├── IMPROVEMENTS.md
│   └── ROADMAP.md
├── scripts/
│   ├── setup.sh
│   └── release.sh
├── .env.example
├── .gitignore
├── analysis_options.yaml
├── cliff.toml                    # Changelog generation
├── l10n.yaml
├── lefthook.yml                  # Git hooks
├── Makefile
├── mason.yaml                    # Mason bricks config
├── pubspec.yaml
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
└── LICENSE
```

---

## Implementation Priority

### Phase 1: Foundation (Week 1-2)
1. Environment flavors (dev/staging/prod)
2. Use cases layer completion
3. Repository pattern completion
4. Dependency injection setup
5. Basic test infrastructure

### Phase 2: Core Features (Week 3-4)
6. Crash reporting (Sentry)
7. Analytics abstraction
8. Offline-first architecture
9. Pagination helpers
10. Form state management

### Phase 3: Authentication (Week 5-6)
11. Biometric authentication
12. Social login (Google, Apple)
13. Token management enhancement
14. Session handling

### Phase 4: Platform Features (Week 7-8)
15. Push notifications
16. Deep linking
17. Force update mechanism
18. Permission handling

### Phase 5: Developer Experience (Week 9-10)
19. Mason bricks
20. VS Code snippets
21. Git hooks (Lefthook)
22. Makefile commands

### Phase 6: Polish (Week 11-12)
23. Comprehensive test suite (80%+ coverage)
24. Documentation
25. CI/CD pipeline enhancement
26. Performance optimization

---

## Competitor Analysis

| Feature | Flutter Starter Pro | VeryGoodCore | flutter_bloc_template | Starter Kit |
|---------|---------------------|--------------|----------------------|-------------|
| Architecture | Clean + Feature-First | Clean + Feature-First | Clean + BLoC | MVC |
| State Management | Riverpod 2.0 | BLoC | BLoC | Provider |
| Flavors | Planned | Yes | Yes | No |
| Test Coverage | Planned 80% | 100% | ~70% | ~30% |
| Mason Bricks | Planned | Yes | No | No |
| Crash Reporting | Planned | Firebase | Optional | No |
| Offline Support | Planned | Partial | No | No |
| Social Auth | Planned | Yes | No | No |
| Push Notifications | Planned | Yes | No | No |
| CI/CD | GitHub Actions | GitHub Actions | GitHub Actions | No |
| Documentation | Good | Excellent | Good | Basic |

### Unique Selling Points to Develop

1. **Riverpod 2.0 Focus**: Most comprehensive Riverpod-based template
2. **Offline-First**: Complete offline synchronization system
3. **Modular Firebase**: Optional Firebase integration, not required
4. **Multiple Auth Options**: Email + Social + Biometric
5. **Complete Testing Strategy**: Unit, Widget, Integration, Golden tests
6. **Developer Tooling**: Mason bricks, snippets, git hooks, Makefile

---

## Conclusion

This improvement plan transforms Flutter Starter Pro from a good starter template into an **industry-leading production-ready boilerplate**. By implementing these changes, developers will be able to:

1. Start production apps in hours, not days
2. Follow proven architectural patterns
3. Have all essential features pre-configured
4. Maintain code quality with comprehensive testing
5. Deploy with confidence using CI/CD pipelines

The phased implementation approach allows for incremental improvements while maintaining stability. Focus on the foundation first (environments, architecture completion, testing), then build features on top.

---

*Document Version: 1.0*
*Last Updated: January 2026*
*Author: Flutter Starter Pro Team*
