import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/auth_fixtures.dart';

void main() {
  group('UserModel', () {
    group('fromJson', () {
      test('should create UserModel from valid JSON', () {
        final json = {
          'id': 'user-123',
          'email': 'test@example.com',
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.png',
          'phone_number': '+1234567890',
          'is_email_verified': true,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-02T00:00:00.000Z',
        };

        final user = UserModel.fromJson(json);

        expect(user.id, 'user-123');
        expect(user.email, 'test@example.com');
        expect(user.name, 'Test User');
        expect(user.avatarUrl, 'https://example.com/avatar.png');
        expect(user.phoneNumber, '+1234567890');
        expect(user.isEmailVerified, true);
        expect(user.createdAt, DateTime.utc(2024));
        expect(user.updatedAt, DateTime.utc(2024, 1, 2));
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': 'user-123',
          'email': 'test@example.com',
        };

        final user = UserModel.fromJson(json);

        expect(user.id, 'user-123');
        expect(user.email, 'test@example.com');
        expect(user.name, isNull);
        expect(user.avatarUrl, isNull);
        expect(user.phoneNumber, isNull);
        expect(user.isEmailVerified, false);
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
      });

      test('should default isEmailVerified to false when null', () {
        final json = {
          'id': 'user-123',
          'email': 'test@example.com',
          'is_email_verified': null,
        };

        final user = UserModel.fromJson(json);

        expect(user.isEmailVerified, false);
      });
    });

    group('toJson', () {
      test('should convert UserModel to JSON', () {
        const user = AuthFixtures.testUserModel;
        final json = user.toJson();

        expect(json['id'], user.id);
        expect(json['email'], user.email);
        expect(json['name'], user.name);
        expect(json['avatar_url'], user.avatarUrl);
        expect(json['phone_number'], user.phoneNumber);
        expect(json['is_email_verified'], user.isEmailVerified);
      });

      test('should handle null optional fields', () {
        const user = UserModel(
          id: 'user-123',
          email: 'test@example.com',
        );

        final json = user.toJson();

        expect(json['name'], isNull);
        expect(json['avatar_url'], isNull);
        expect(json['phone_number'], isNull);
        expect(json['created_at'], isNull);
        expect(json['updated_at'], isNull);
      });

      test('should serialize dates as ISO8601 strings', () {
        final user = UserModel(
          id: 'user-123',
          email: 'test@example.com',
          createdAt: DateTime.utc(2024),
          updatedAt: DateTime.utc(2024, 1, 2),
        );

        final json = user.toJson();

        expect(json['created_at'], '2024-01-01T00:00:00.000Z');
        expect(json['updated_at'], '2024-01-02T00:00:00.000Z');
      });
    });

    group('fromEntity', () {
      test('should create UserModel from User entity', () {
        const entity = User(
          id: 'user-123',
          email: 'test@example.com',
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '+1234567890',
          isEmailVerified: true,
        );

        final model = UserModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.email, entity.email);
        expect(model.name, entity.name);
        expect(model.avatarUrl, entity.avatarUrl);
        expect(model.phoneNumber, entity.phoneNumber);
        expect(model.isEmailVerified, entity.isEmailVerified);
      });
    });

    group('toEntity', () {
      test('should convert UserModel to User entity', () {
        const model = AuthFixtures.testUserModel;
        final entity = model.toEntity();

        expect(entity.id, model.id);
        expect(entity.email, model.email);
        expect(entity.name, model.name);
        expect(entity.avatarUrl, model.avatarUrl);
        expect(entity.phoneNumber, model.phoneNumber);
        expect(entity.isEmailVerified, model.isEmailVerified);
      });

      test('should return User type (not UserModel)', () {
        const model = AuthFixtures.testUserModel;
        final entity = model.toEntity();

        expect(entity, isA<User>());
        // UserModel extends User, so this checks it's specifically User
        expect(entity.runtimeType, User);
      });
    });

    group('value equality', () {
      test('two UserModels with same values should be equal', () {
        const model1 = AuthFixtures.testUserModel;
        const model2 = UserModel(
          id: AuthFixtures.testUserId,
          email: AuthFixtures.testEmail,
          name: AuthFixtures.testName,
          isEmailVerified: true,
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '+1234567890',
        );

        expect(model1, equals(model2));
      });

      test('UserModel should have same props as equivalent User', () {
        const model = AuthFixtures.testUserModel;
        const user = AuthFixtures.testUser;

        // Props should be equal even if runtime types differ
        expect(model.props, equals(user.props));
      });
    });

    group('round trip', () {
      test('fromJson and toJson should be reversible', () {
        final originalJson = {
          'id': 'user-123',
          'email': 'test@example.com',
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.png',
          'phone_number': '+1234567890',
          'is_email_verified': true,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-02T00:00:00.000Z',
        };

        final user = UserModel.fromJson(originalJson);
        final resultJson = user.toJson();

        expect(resultJson['id'], originalJson['id']);
        expect(resultJson['email'], originalJson['email']);
        expect(resultJson['name'], originalJson['name']);
        expect(resultJson['avatar_url'], originalJson['avatar_url']);
        expect(resultJson['phone_number'], originalJson['phone_number']);
        expect(
            resultJson['is_email_verified'], originalJson['is_email_verified']);
      });

      test('fromEntity and toEntity should be reversible', () {
        const entity = AuthFixtures.testUser;
        final model = UserModel.fromEntity(entity);
        final resultEntity = model.toEntity();

        expect(resultEntity, equals(entity));
      });
    });
  });
}
