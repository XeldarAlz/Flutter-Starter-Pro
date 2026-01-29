import 'dart:convert';

import 'package:flutter_starter_pro/core/errors/exceptions.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:flutter_starter_pro/core/storage/secure_storage.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/models/token_model.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';

/// Implementation of [AuthLocalDataSource] using secure and local storage.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.localStorage,
  });

  final SecureStorage secureStorage;
  final LocalStorage localStorage;

  static const String _cachedUserKey = 'CACHED_USER';

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await localStorage.setString(_cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = localStorage.getString(_cachedUserKey);
      if (jsonString == null) return null;

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await localStorage.remove(_cachedUserKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> saveTokens(TokenModel tokens) async {
    try {
      await secureStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save tokens: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.getAccessToken();
    } catch (e) {
      throw CacheException(message: 'Failed to get access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.getRefreshToken();
    } catch (e) {
      throw CacheException(message: 'Failed to get refresh token: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await secureStorage.clearTokens();
    } catch (e) {
      throw CacheException(message: 'Failed to clear tokens: $e');
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      return await secureStorage.hasValidToken();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return await secureStorage.getUserId();
    } catch (e) {
      throw CacheException(message: 'Failed to get user ID: $e');
    }
  }
}
