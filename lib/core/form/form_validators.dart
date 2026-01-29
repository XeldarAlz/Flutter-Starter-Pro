/// Common form validators.
///
/// All validators return null if valid, or an error message if invalid.
///
/// ## Usage
///
/// ```dart
/// final emailError = FormValidators.email(value);
/// final passwordError = FormValidators.compose([
///   FormValidators.required,
///   FormValidators.minLength(8),
/// ])(value);
/// ```
abstract class FormValidators {
  /// Validates that the field is not empty
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Validates that the field is not empty with custom message
  static Validator requiredWithMessage(String message) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates minimum length
  static Validator minLength(int length) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < length) {
        return 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Validates maximum length
  static Validator maxLength(int length) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length > length) {
        return 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Validates that value matches a pattern
  static Validator pattern(RegExp regex, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Validates password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp('[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp('[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp('[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    return null;
  }

  /// Validates that value matches another value
  static Validator matches(String? Function() getValue, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value != getValue()) {
        return message ?? 'Values do not match';
      }
      return null;
    };
  }

  /// Validates phone number format
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates numeric value
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  /// Validates integer value
  static String? integer(String? value) {
    if (value == null || value.isEmpty) return null;

    if (int.tryParse(value) == null) {
      return 'Please enter a valid integer';
    }
    return null;
  }

  /// Validates minimum numeric value
  static Validator min(num minValue) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) return 'Please enter a valid number';

      if (numValue < minValue) {
        return 'Must be at least $minValue';
      }
      return null;
    };
  }

  /// Validates maximum numeric value
  static Validator max(num maxValue) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) return 'Please enter a valid number';

      if (numValue > maxValue) {
        return 'Must be at most $maxValue';
      }
      return null;
    };
  }

  /// Compose multiple validators
  ///
  /// Runs validators in order and returns the first error found.
  static Validator compose(List<Validator> validators) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Make a validator optional (skip if empty)
  static Validator optional(Validator validator) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      return validator(value);
    };
  }
}

/// Type alias for validator functions
typedef Validator = String? Function(String? value);

/// Type alias for async validator functions
typedef AsyncValidator = Future<String?> Function(String? value);
