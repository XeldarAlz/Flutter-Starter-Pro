import 'package:dartz/dartz.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';
import 'package:flutter_starter_pro/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/auth_fixtures.dart';
import '../../mocks/auth_mocks.dart';

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  group('SignInUseCase', () {
    test('should return User when repository sign in succeeds', () async {
      // Arrange
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(AuthFixtures.testUser));

      // Act
      final result = await useCase(
        const SignInParams(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
        ),
      );

      // Assert
      expect(result, const Right(AuthFixtures.testUser));
      verify(
        () => mockRepository.signIn(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when repository sign in fails', () async {
      // Arrange
      const failure = AuthFailure(message: 'Invalid credentials');
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(
        const SignInParams(
          email: AuthFixtures.testEmail,
          password: 'wrong-password',
        ),
      );

      // Assert
      expect(result, const Left(failure));
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(
        const SignInParams(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
    });
  });

  group('SignInParams', () {
    test('should support value equality', () {
      const params1 = SignInParams(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );
      const params2 = SignInParams(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      expect(params1, equals(params2));
    });

    test('should have correct props', () {
      const params = SignInParams(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
      );

      expect(params.props, [AuthFixtures.testEmail, AuthFixtures.testPassword]);
    });
  });
}
