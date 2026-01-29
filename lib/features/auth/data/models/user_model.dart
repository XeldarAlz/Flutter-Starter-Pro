import 'package:flutter_starter_pro/features/auth/domain/entities/user.dart';

/// User data model with JSON serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.phoneNumber,
    super.isEmailVerified,
    super.createdAt,
    super.updatedAt,
  });

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatarUrl,
      phoneNumber: user.phoneNumber,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'is_email_verified': isEmailVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Convert to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
