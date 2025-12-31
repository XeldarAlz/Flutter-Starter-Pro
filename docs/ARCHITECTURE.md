# Architecture Documentation

This document describes the architecture and design decisions used in Flutter Starter Pro.

## Overview

The project follows **Clean Architecture** principles combined with **Feature-First** organization. This approach ensures:

- **Separation of Concerns**: Each layer has a specific responsibility
- **Testability**: Business logic is isolated and easy to test
- **Scalability**: Easy to add new features without affecting existing code
- **Maintainability**: Clear structure makes code easy to understand and modify

## Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│              (Screens, Widgets, Providers)               │
├─────────────────────────────────────────────────────────┤
│                      Domain Layer                        │
│              (Entities, Use Cases, Repos)                │
├─────────────────────────────────────────────────────────┤
│                       Data Layer                         │
│           (Models, Data Sources, Repo Impl)              │
├─────────────────────────────────────────────────────────┤
│                     Core / Shared                        │
│         (Utils, Extensions, Network, Storage)            │
└─────────────────────────────────────────────────────────┘
```

### 1. Presentation Layer

Contains UI-related code:

- **Screens**: Full-page widgets
- **Widgets**: Reusable UI components
- **Providers**: Riverpod providers for state management

```dart
// Example: Auth Provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState();
  
  Future<void> signIn(String email, String password) async {
    // Implementation
  }
}
```

### 2. Domain Layer

Contains business logic:

- **Entities**: Core business objects
- **Use Cases**: Business logic operations
- **Repository Interfaces**: Contracts for data access

```dart
// Example: User Entity
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  
  const User({required this.id, required this.email, this.name});
}
```

### 3. Data Layer

Handles data operations:

- **Models**: Data transfer objects with serialization
- **Data Sources**: Remote (API) and Local (Cache) sources
- **Repository Implementations**: Implement domain contracts

```dart
// Example: User Model
class UserModel extends User {
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() => {...};
}
```

## State Management

We use **Riverpod 2.0** with code generation for:

- Type-safe providers
- Automatic disposal
- Easy testing
- DevTools integration

### Provider Types

1. **Simple Providers**: Static values or computed data
2. **FutureProviders**: Async operations
3. **StreamProviders**: Real-time data
4. **NotifierProviders**: Complex state with mutations

```dart
// Simple provider
@riverpod
String appVersion(Ref ref) => '1.0.0';

// Async provider
@riverpod
Future<User> currentUser(Ref ref) async {
  final api = ref.watch(apiClientProvider);
  return api.getUser();
}

// Notifier provider
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}
```

## Routing

**GoRouter** is used for declarative routing:

- Deep linking support
- Nested navigation
- Authentication guards
- Type-safe route parameters

```dart
GoRoute(
  path: '/user/:id',
  builder: (context, state) {
    final userId = state.pathParameters['id']!;
    return UserScreen(userId: userId);
  },
)
```

## Network Layer

**Dio** with custom interceptors:

- Authentication (token injection)
- Logging
- Token refresh
- Retry logic
- Error handling

```dart
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(options, handler) async {
    final token = await secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
```

## Storage

Two storage solutions:

1. **SecureStorage**: For sensitive data (tokens, credentials)
2. **LocalStorage**: For preferences and non-sensitive data

```dart
// Secure storage for tokens
await secureStorage.saveAccessToken(token);

// Local storage for preferences
await localStorage.setThemeMode('dark');
```

## Error Handling

Two-tier error handling:

1. **Exceptions**: Thrown in data layer
2. **Failures**: Returned to presentation layer

```dart
// In data layer
throw ServerException(message: 'Server error');

// In domain/presentation layer
result.fold(
  (failure) => showError(failure.message),
  (data) => showSuccess(data),
);
```

## Theming

Material 3 theming with:

- Light and dark modes
- Custom color schemes
- Typography system
- Component themes

```dart
// Access theme
final colors = context.colorScheme;
final textStyles = context.textTheme;

// Toggle theme
ref.read(themeModeNotifierProvider.notifier).toggleTheme();
```

## Testing Strategy

1. **Unit Tests**: Business logic, utils, extensions
2. **Widget Tests**: UI components
3. **Integration Tests**: Full user flows

```dart
// Unit test
test('should validate email', () {
  expect(Validators.email('test@email.com'), isNull);
  expect(Validators.email('invalid'), isNotNull);
});

// Widget test
testWidgets('should show login form', (tester) async {
  await tester.pumpWidget(LoginScreen());
  expect(find.text('Sign In'), findsOneWidget);
});
```

## Best Practices

1. **Keep layers independent**: Don't import data layer in domain
2. **Use interfaces**: Define contracts in domain layer
3. **Prefer composition**: Over inheritance
4. **Single responsibility**: One class, one purpose
5. **Don't repeat yourself**: Extract common logic
6. **Write tests**: Especially for business logic
7. **Document complex code**: Add comments when needed

## Adding New Features

1. Create feature folder under `lib/features/`
2. Add domain layer (entities, repository interface)
3. Add data layer (models, data sources, repository impl)
4. Add presentation layer (screens, widgets, providers)
5. Register routes in `app_router.dart`
6. Write tests

```
lib/features/new_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

