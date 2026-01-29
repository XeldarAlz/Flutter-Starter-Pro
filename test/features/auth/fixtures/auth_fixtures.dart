import 'package:flutter_starter_pro/features/auth/data/models/token_model.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';
import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';

/// Test fixtures for auth feature tests
class AuthFixtures {
  AuthFixtures._();

  static const testEmail = 'test@example.com';
  static const testPassword = 'password123';
  static const testName = 'Test User';
  static const testUserId = 'user-123';

  static const testUser = User(
    id: testUserId,
    email: testEmail,
    name: testName,
    isEmailVerified: true,
    avatarUrl: 'https://example.com/avatar.png',
    phoneNumber: '+1234567890',
  );

  static const testUserModel = UserModel(
    id: testUserId,
    email: testEmail,
    name: testName,
    isEmailVerified: true,
    avatarUrl: 'https://example.com/avatar.png',
    phoneNumber: '+1234567890',
  );

  static const testTokenModel = TokenModel(
    accessToken: 'test-access-token',
    refreshToken: 'test-refresh-token',
    expiresIn: 3600,
  );

  static AuthResponse get testAuthResponse => AuthResponse(
        tokens: testTokenModel,
        user: testUserModel.toJson(),
      );

  static Map<String, dynamic> get testUserJson => {
        'id': testUserId,
        'email': testEmail,
        'name': testName,
        'avatar_url': 'https://example.com/avatar.png',
        'phone_number': '+1234567890',
        'is_email_verified': true,
        'created_at': null,
        'updated_at': null,
      };
}
