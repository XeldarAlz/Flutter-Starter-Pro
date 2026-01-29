/// Token response model
class TokenModel {
  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
  });

  /// Create TokenModel from JSON
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int?,
    );
  }

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int? expiresIn;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  /// Check if token will expire soon (within 5 minutes)
  bool get isExpiringSoon {
    if (expiresIn == null) return false;
    return expiresIn! < 300; // 5 minutes
  }
}

/// Authentication response containing tokens and user data
class AuthResponse {
  const AuthResponse({
    required this.tokens,
    required this.user,
  });

  /// Create AuthResponse from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      tokens: TokenModel.fromJson(json),
      user: json['user'] as Map<String, dynamic>,
    );
  }

  final TokenModel tokens;
  final Map<String, dynamic> user;
}
