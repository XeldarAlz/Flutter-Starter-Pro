import 'package:dartz/dartz.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';
import 'package:flutter_starter_pro/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/auth_fixtures.dart';
import '../../mocks/auth_mocks.dart';

void main() {
  late SignUpUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
  });

  group('SignUpUseCase', () {
    test('should return User when repository sign up succeeds', () async {
      // Arrange
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Right(AuthFixtures.testUser));

      // Act
      final result = await useCase(
        const SignUpParams(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
          name: AuthFixtures.testName,
        ),
      );

      // Assert
      expect(result, const Right(AuthFixtures.testUser));
      verify(
        () => mockRepository.signUp(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
          name: AuthFixtures.testName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when email already exists', () async {
      // Arrange
      const failure = ValidationFailure(
        message: 'Email already in use',
        errors: {
          'email': ['This email is already registered'],
        },
      );
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(
        const SignUpParams(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
          name: AuthFixtures.testName,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      result.fold(
        (f) {
          expect(f, isA<ValidationFailure>());
          expect((f as ValidationFailure).errors?['email'], isNotNull);
        },
        (_) => fail('Expected Left'),
      );
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(
        const SignUpParams(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
          name: AuthFixtures.testName,
        ),
      );

      // Assert
      expect(result, const Left(failure));
    });

    test('should return ServerFailure on server error', () async {
      // Arrange
      const failure =
          ServerFailure(message: 'Internal server error', statusCode: 500);
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(
        const SignUpParams(
          email: AuthFixtures.testEmail,
          password: AuthFixtures.testPassword,
          name: AuthFixtures.testName,
        ),
      );

      // Assert
      expect(result, const Left(failure));
    });
  });

  group('SignUpParams', () {
    test('should support value equality', () {
      const params1 = SignUpParams(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
        name: AuthFixtures.testName,
      );
      const params2 = SignUpParams(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
        name: AuthFixtures.testName,
      );

      expect(params1, equals(params2));
    });

    test('should have correct props', () {
      const params = SignUpParams(
        email: AuthFixtures.testEmail,
        password: AuthFixtures.testPassword,
        name: AuthFixtures.testName,
      );

      expect(
        params.props,
        [
          AuthFixtures.testEmail,
          AuthFixtures.testPassword,
          AuthFixtures.testName
        ],
      );
    });
  });
}
