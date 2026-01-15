import 'package:flutter_starter_pro/core/constants/api_constants.dart';
import 'package:flutter_starter_pro/core/network/api_client.dart';
import 'package:flutter_starter_pro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_starter_pro/features/auth/data/models/token_model.dart';
import 'package:flutter_starter_pro/features/auth/data/models/user_model.dart';

/// Implementation of [AuthRemoteDataSource] using the API client.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponse.fromJson(response.data!);
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    return AuthResponse.fromJson(response.data!);
  }

  @override
  Future<void> signOut() async {
    await apiClient.post<void>(ApiConstants.logout);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiConstants.userProfile,
    );

    return UserModel.fromJson(response.data!);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await apiClient.post<void>(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<UserModel> updateUser({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    final response = await apiClient.patch<Map<String, dynamic>>(
      ApiConstants.updateProfile,
      data: data,
    );

    return UserModel.fromJson(response.data!);
  }

  @override
  Future<TokenModel> refreshToken({required String refreshToken}) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiConstants.refreshToken,
      data: {'refresh_token': refreshToken},
    );

    return TokenModel.fromJson(response.data!);
  }
}
