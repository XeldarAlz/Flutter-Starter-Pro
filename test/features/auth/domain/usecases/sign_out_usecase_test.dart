import 'package:dartz/dartz.dart';
import 'package:flutter_starter_pro/core/errors/failures.dart';
import 'package:flutter_starter_pro/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/auth_mocks.dart';

void main() {
  late SignOutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOutUseCase(mockRepository);
  });

  group('SignOutUseCase', () {
    test('should return unit when repository sign out succeeds', () async {
      // Arrange
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when clearing cache fails', () async {
      // Arrange
      const failure = CacheFailure(message: 'Failed to clear cache');
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
    });

    test('should succeed even when offline (local-first sign out)', () async {
      // Arrange - sign out should work offline by clearing local data
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(unit));
    });
  });
}
