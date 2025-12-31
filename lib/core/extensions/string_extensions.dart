/// Extension methods for String
extension StringExtensions on String {
  /// Capitalize the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize the first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if string contains only digits
  bool get isNumeric {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(this);
  }

  /// Check if string contains only letters
  bool get isAlpha {
    final alphaRegex = RegExp(r'^[a-zA-Z]+$');
    return alphaRegex.hasMatch(this);
  }

  /// Check if string contains only letters and numbers
  bool get isAlphaNumeric {
    final alphaNumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphaNumericRegex.hasMatch(this);
  }

  /// Remove all whitespace from string
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string to specified length with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Convert string to slug format
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Mask sensitive data (e.g., email, phone)
  String get masked {
    if (length <= 4) return '****';
    return '${substring(0, 2)}${'*' * (length - 4)}${substring(length - 2)}';
  }

  /// Parse string to int or return null
  int? get toIntOrNull => int.tryParse(this);

  /// Parse string to double or return null
  double? get toDoubleOrNull => double.tryParse(this);

  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Get initials from name
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ');
    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }
}

/// Extension for nullable String
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Return the string or a default value
  String orDefault([String defaultValue = '']) => this ?? defaultValue;
}
