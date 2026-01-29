import 'package:dartz/dartz.dart';
import 'package:flutter_starter_pro/core/errors/exceptions.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';
import 'package:flutter_starter_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/auth_fixtures.dart';
import '../../mocks/auth_mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(AuthFixtures.testTokenModel);
    registerFallbackValue(AuthFixtures.testUserModel);
  });

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

  tearDown(() {
    repository.dispose();
  });

  group('signIn', () {
    test('should return User when sign in is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => AuthFixtures.testAuthResponse);
      when(() => mockLocalDataSource.saveTokens(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.signIn(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (user) {
          expect(user.email, AuthFixtures.testEmail);
          expect(user.name, AuthFixtures.testName);
        },
      );

      verify(
        () => mockRemoteDataSource.signIn(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
        ),
      ).called(1);
      verify(() => mockLocalDataSource.saveTokens(any())).called(1);
      verify(() => mockLocalDataSource.cacheUser(any())).called(1);
    });

    test('should return NetworkFailure when device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.signIn(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (user) => fail('Expected Left but got Right'),
      );

      verifyNever(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    test('should return ServerFailure when server exception occurs', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const ServerException(message: 'Server error', statusCode: 500),
      );

      // Act
      final result = await repository.signIn(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        },
        (user) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when auth exception occurs', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const AuthException(message: 'Invalid credentials'),
      );

      // Act
      final result = await repository.signIn(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Invalid credentials');
        },
        (user) => fail('Expected Left but got Right'),
      );
    });

    test('should return ValidationFailure when validation exception occurs',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const ValidationException(
          message: 'Validation failed',
          errors: {
            'email': ['Invalid email format'],
          },
        ),
      );

      // Act
      final result = await repository.signIn(
        email: 'invalid-email',
        password: AuthFixtures.testPassword,
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect((failure as ValidationFailure).errors, isNotNull);
        },
        (user) => fail('Expected Left but got Right'),
      );
    });
  });

  group('signUp', () {
    test('should return User when sign up is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => AuthFixtures.testAuthResponse);
      when(() => mockLocalDataSource.saveTokens(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.signUp(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
        name: AuthFixtures.testName,
      );

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (user) {
          expect(user.email, AuthFixtures.testEmail);
          expect(user.name, AuthFixtures.testName);
        },
      );
    });

    test('should return NetworkFailure when device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.signUp(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
        name: AuthFixtures.testName,
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (user) => fail('Expected Left but got Right'),
      );
    });
  });

  group('signOut', () {
    test('should return unit when sign out is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearTokens()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearCachedUser())
          .thenAnswer((_) async {});

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (value) => expect(value, unit),
      );

      verify(() => mockLocalDataSource.clearTokens()).called(1);
      verify(() => mockLocalDataSource.clearCachedUser()).called(1);
    });

    test('should still clear local data even when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.clearTokens()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearCachedUser())
          .thenAnswer((_) async {});

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, isA<Right>());
      verify(() => mockLocalDataSource.clearTokens()).called(1);
      verify(() => mockLocalDataSource.clearCachedUser()).called(1);
      verifyNever(() => mockRemoteDataSource.signOut());
    });

    test('should return CacheFailure when clearing tokens fails', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.clearTokens())
          .thenThrow(const CacheException(message: 'Failed to clear tokens'));

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (value) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getCurrentUser', () {
    test('should return cached user when available', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => AuthFixtures.testUserModel);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (user) => expect(user.id, AuthFixtures.testUserId),
      );
    });

    test('should fetch from remote when no cached user and online', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser())
          .thenAnswer((_) async => AuthFixtures.testUserModel);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<Right>());
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      verify(() => mockLocalDataSource.cacheUser(any())).called(1);
    });

    test('should return NetworkFailure when no cache and offline', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (user) => fail('Expected Left but got Right'),
      );
    });

    test('should clear tokens and return AuthFailure on UnauthorizedException',
        () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrentUser())
          .thenThrow(const UnauthorizedException());
      when(() => mockLocalDataSource.clearTokens()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearCachedUser())
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Session expired');
        },
        (user) => fail('Expected Left but got Right'),
      );
      verify(() => mockLocalDataSource.clearTokens()).called(1);
      verify(() => mockLocalDataSource.clearCachedUser()).called(1);
    });
  });

  group('forgotPassword', () {
    test('should return unit when forgot password is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() =>
              mockRemoteDataSource.forgotPassword(email: any(named: 'email')))
          .thenAnswer((_) async {});

      // Act
      final result =
          await repository.forgotPassword(email: AuthFixtures.testEmail);

      // Assert
      expect(result, isA<Right>());
      verify(
        () =>
            mockRemoteDataSource.forgotPassword(email: AuthFixtures.testEmail),
      ).called(1);
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result =
          await repository.forgotPassword(email: AuthFixtures.testEmail);

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (value) => fail('Expected Left but got Right'),
      );
    });
  });

  group('updateUser', () {
    test('should return updated user when update is successful', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.updateUser(
          name: any(named: 'name'),
          phoneNumber: any(named: 'phoneNumber'),
          avatarUrl: any(named: 'avatarUrl'),
        ),
      ).thenAnswer((_) async => AuthFixtures.testUserModel);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.updateUser(name: 'New Name');

      // Assert
      expect(result, isA<Right>());
      verify(() => mockLocalDataSource.cacheUser(any())).called(1);
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.updateUser(name: 'New Name');

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (user) => fail('Expected Left but got Right'),
      );
    });
  });

  group('isAuthenticated', () {
    test('should return true when has valid token', () async {
      // Arrange
      when(() => mockLocalDataSource.hasValidToken())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, true);
    });

    test('should return false when no valid token', () async {
      // Arrange
      when(() => mockLocalDataSource.hasValidToken())
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, false);
    });
  });

  group('authStateChanges', () {
    test('should be a broadcast stream', () {
      expect(repository.authStateChanges.isBroadcast, isTrue);
    });

    test('should emit user when sign in succeeds', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => AuthFixtures.testAuthResponse);
      when(() => mockLocalDataSource.saveTokens(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async {});

      // Collect stream emissions
      final emissions = <dynamic>[];
      final subscription = repository.authStateChanges.listen(emissions.add);

      // Act
      await repository.signIn(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      // Wait for stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert
      expect(emissions, isNotEmpty);
      expect(emissions.first?.email, AuthFixtures.testEmail);

      await subscription.cancel();
    });

    test('should emit null when sign out succeeds', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.clearTokens()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.clearCachedUser())
          .thenAnswer((_) async {});

      // Collect stream emissions
      final emissions = <dynamic>[];
      final subscription = repository.authStateChanges.listen(emissions.add);

      // Act
      await repository.signOut();

      // Wait for stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert
      expect(emissions, contains(null));

      await subscription.cancel();
    });
  });
}
