import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Get display name (name or email)
  String get displayName => name ?? email;

  /// Get initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final words = name!.split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  /// Check if user has complete profile
  bool get hasCompleteProfile =>
      name != null && name!.isNotEmpty && isEmailVerified;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        phoneNumber,
        isEmailVerified,
        createdAt,
        updatedAt,
      ];

  /// Copy with new values
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phoneNumber,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
