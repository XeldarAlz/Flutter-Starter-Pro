import 'package:flutter_starter_pro/core/errors/exceptions.dart'
    show CacheException;
import 'package:flutter_starter_pro/features/auth/data/models/token_model.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';

/// Abstract interface for local authentication data operations.
///
/// This interface defines the contract for local storage operations
/// related to authentication (caching user data, tokens, etc.).
abstract class AuthLocalDataSource {
  /// Caches the user data locally.
  ///
  /// Throws [CacheException] if caching fails.
  Future<void> cacheUser(UserModel user);

  /// Gets the cached user data.
  ///
  /// Returns [UserModel] if available.
  /// Throws [CacheException] if no cached data or reading fails.
  Future<UserModel?> getCachedUser();

  /// Clears the cached user data.
  ///
  /// Throws [CacheException] if clearing fails.
  Future<void> clearCachedUser();

  /// Saves authentication tokens.
  ///
  /// Throws [CacheException] if saving fails.
  Future<void> saveTokens(TokenModel tokens);

  /// Gets the access token.
  ///
  /// Returns the access token string or null if not available.
  Future<String?> getAccessToken();

  /// Gets the refresh token.
  ///
  /// Returns the refresh token string or null if not available.
  Future<String?> getRefreshToken();

  /// Clears all stored tokens.
  ///
  /// Throws [CacheException] if clearing fails.
  Future<void> clearTokens();

  /// Checks if a valid token exists.
  Future<bool> hasValidToken();

  /// Gets the user ID from storage.
  Future<String?> getUserId();
}
