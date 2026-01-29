import 'package:flutter_starter_pro/core/errors/exceptions.dart'
    show ServerException;
import 'package:flutter_starter_pro/features/auth/data/models/token_model.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';

/// Abstract interface for remote authentication data operations.
///
/// This interface defines the contract for API calls related to authentication.
abstract class AuthRemoteDataSource {
  /// Signs in a user with email and password.
  ///
  /// Returns [AuthResponse] containing user data and tokens.
  /// Throws [ServerException] on API errors.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  /// Registers a new user.
  ///
  /// Returns [AuthResponse] containing user data and tokens.
  /// Throws [ServerException] on API errors.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Signs out the current user.
  ///
  /// Throws [ServerException] on API errors.
  Future<void> signOut();

  /// Gets the current user's profile.
  ///
  /// Returns [UserModel] with user data.
  /// Throws [ServerException] on API errors.
  Future<UserModel> getCurrentUser();

  /// Sends a password reset email.
  ///
  /// Throws [ServerException] on API errors.
  Future<void> forgotPassword({required String email});

  /// Updates the user's profile.
  ///
  /// Returns the updated [UserModel].
  /// Throws [ServerException] on API errors.
  Future<UserModel> updateUser({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Refreshes the access token using refresh token.
  ///
  /// Returns new [TokenModel].
  /// Throws [ServerException] on API errors.
  Future<TokenModel> refreshToken({required String refreshToken});
}
