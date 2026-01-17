import 'package:equatable/equatable.dart';

/// Represents a form field with its value and validation state.
class FormFieldState<T> extends Equatable {
  const FormFieldState({
    required this.value,
    this.error,
    this.isTouched = false,
    this.isValidating = false,
  });

  /// Current value of the field
  final T value;

  /// Validation error message (null if valid)
  final String? error;

  /// Whether the field has been interacted with
  final bool isTouched;

  /// Whether async validation is in progress
  final bool isValidating;

  /// Whether the field is valid (no error)
  bool get isValid => error == null && !isValidating;

  /// Whether the field is invalid (has error)
  bool get isInvalid => error != null;

  /// Whether to show error (touched and has error)
  bool get showError => isTouched && error != null;

  FormFieldState<T> copyWith({
    T? value,
    String? error,
    bool? isTouched,
    bool? isValidating,
    bool clearError = false,
  }) {
    return FormFieldState<T>(
      value: value ?? this.value,
      error: clearError ? null : (error ?? this.error),
      isTouched: isTouched ?? this.isTouched,
      isValidating: isValidating ?? this.isValidating,
    );
  }

  @override
  List<Object?> get props => [value, error, isTouched, isValidating];
}

/// Type alias for a string form field (most common case)
typedef StringFieldState = FormFieldState<String>;

/// Type alias for a boolean form field (checkboxes, switches)
typedef BoolFieldState = FormFieldState<bool>;

/// Type alias for a nullable form field
typedef NullableFieldState<T> = FormFieldState<T?>;
