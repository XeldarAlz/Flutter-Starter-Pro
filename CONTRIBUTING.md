# Contributing to Flutter Starter Pro

First off, thank you for considering contributing to Flutter Starter Pro! It's people like you that make this project great.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** (code snippets, screenshots)
- **Describe the behavior you observed and what you expected**
- **Include your environment details** (Flutter version, OS, device)

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **A clear and descriptive title**
- **A detailed description of the proposed feature**
- **Explain why this feature would be useful**
- **Include mockups or examples if applicable**

### Pull Requests

1. **Fork the repo** and create your branch from `dev`
2. **Follow the coding standards** (see below)
3. **Add tests** if you've added code that should be tested
4. **Ensure the test suite passes**
5. **Update documentation** if needed
6. **Create a Pull Request**

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/flutter-starter-pro.git
cd flutter-starter-pro

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/flutter-starter-pro.git

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test
```

## Coding Standards

### Dart Style Guide

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` to format your code
- Run `flutter analyze` before committing

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Private members**: `_prefixedWithUnderscore`

### Code Organization

- Keep files under 300 lines when possible
- One class per file (with exceptions for small helper classes)
- Group related functionality in folders
- Use barrel files (`index.dart`) for public exports

### Comments and Documentation

- Document public APIs
- Use `///` for documentation comments
- Explain **why**, not **what** (the code shows what)
- Keep comments up to date with code changes

### Git Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `perf`: Performance improvement
- `test`: Tests
- `chore`: Maintenance

**Examples:**
```
feat(auth): add biometric login support

fix(network): handle timeout exceptions properly

docs: update API documentation

refactor(theme): simplify color scheme implementation
```

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `refactor/description` - Refactoring

## Testing Guidelines

### Unit Tests

- Test business logic and utilities
- Mock external dependencies
- Aim for high coverage on critical paths

```dart
test('should return failure when network error', () async {
  when(() => mockApi.getUser()).thenThrow(NetworkException());
  
  final result = await repository.getUser();
  
  expect(result.isLeft(), true);
});
```

### Widget Tests

- Test UI components in isolation
- Verify widget tree and interactions
- Use `pumpWidget` and `pumpAndSettle`

```dart
testWidgets('should display error message', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: LoginScreen()),
  );
  
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
  
  expect(find.text('Email is required'), findsOneWidget);
});
```

### Integration Tests

- Test complete user flows
- Run on real devices/emulators
- Include happy paths and edge cases

## Review Process

1. All PRs require at least one review
2. Address all review comments
3. Keep PRs focused and small when possible
4. Squash commits before merging

## Questions?

Feel free to open an issue with the "question" label if you have any questions about contributing.

Thank you for contributing! 🎉

