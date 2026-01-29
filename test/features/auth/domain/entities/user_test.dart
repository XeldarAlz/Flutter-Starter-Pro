import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/auth_fixtures.dart';

void main() {
  group('User', () {
    test('should support value equality', () {
      const user1 = AuthFixtures.testUser;
      const user2 = User(
        id: AuthFixtures.testUserId,
        email: AuthFixtures.testEmail,
        name: AuthFixtures.testName,
        isEmailVerified: true,
        avatarUrl: 'https://example.com/avatar.png',
        phoneNumber: '+1234567890',
      );

      expect(user1, equals(user2));
    });

    group('displayName', () {
      test('should return name when name is present', () {
        const user = AuthFixtures.testUser;
        expect(user.displayName, AuthFixtures.testName);
      });

      test('should return email when name is null', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: null,
        );
        expect(user.displayName, 'test@example.com');
      });
    });

    group('initials', () {
      test('should return two letter initials for full name', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: 'John Doe',
        );
        expect(user.initials, 'JD');
      });

      test('should return single letter for single name', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: 'John',
        );
        expect(user.initials, 'J');
      });

      test('should return email initial when name is null', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: null,
        );
        expect(user.initials, 'T');
      });

      test('should return email initial when name is empty', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: '',
        );
        expect(user.initials, 'T');
      });

      test('should handle multiple word names', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: 'John Middle Doe',
        );
        expect(user.initials, 'JM');
      });
    });

    group('hasCompleteProfile', () {
      test('should return true when name is set and email is verified', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
        );
        expect(user.hasCompleteProfile, true);
      });

      test('should return false when name is null', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: null,
          isEmailVerified: true,
        );
        expect(user.hasCompleteProfile, false);
      });

      test('should return false when name is empty', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: '',
          isEmailVerified: true,
        );
        expect(user.hasCompleteProfile, false);
      });

      test('should return false when email is not verified', () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: false,
        );
        expect(user.hasCompleteProfile, false);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated name', () {
        const user = AuthFixtures.testUser;
        final updated = user.copyWith(name: 'New Name');

        expect(updated.name, 'New Name');
        expect(updated.email, user.email);
        expect(updated.id, user.id);
      });

      test('should create a copy with updated email', () {
        const user = AuthFixtures.testUser;
        final updated = user.copyWith(email: 'new@example.com');

        expect(updated.email, 'new@example.com');
        expect(updated.name, user.name);
      });

      test('should preserve all fields when none specified', () {
        const user = AuthFixtures.testUser;
        final updated = user.copyWith();

        expect(updated, equals(user));
      });

      test('should update multiple fields at once', () {
        const user = AuthFixtures.testUser;
        final updated = user.copyWith(
          name: 'New Name',
          phoneNumber: '+9876543210',
          isEmailVerified: false,
        );

        expect(updated.name, 'New Name');
        expect(updated.phoneNumber, '+9876543210');
        expect(updated.isEmailVerified, false);
        expect(updated.email, user.email);
      });
    });

    group('props', () {
      test('should include all fields in props', () {
        const user = AuthFixtures.testUser;
        expect(
          user.props,
          [
            user.id,
            user.email,
            user.name,
            user.avatarUrl,
            user.phoneNumber,
            user.isEmailVerified,
            user.createdAt,
            user.updatedAt,
          ],
        );
      });
    });
  });
}
