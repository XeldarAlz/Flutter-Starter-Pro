import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/form/form_field_state.dart';
import 'package:flutter_starter_pro/core/form/form_validators.dart';

/// Base class for form state management.
///
/// Extend this class to create type-safe form state notifiers.
///
/// ## Usage
///
/// ```dart
/// class LoginFormState {
///   final StringFieldState email;
///   final StringFieldState password;
///   final bool isSubmitting;
///
///   LoginFormState({
///     this.email = const StringFieldState(value: ''),
///     this.password = const StringFieldState(value: ''),
///     this.isSubmitting = false,
///   });
/// }
///
/// class LoginFormNotifier extends FormStateNotifier<LoginFormState> {
///   LoginFormNotifier() : super(LoginFormState());
///
///   void updateEmail(String value) {
///     state = state.copyWith(
///       email: validateField(value, FormValidators.compose([
///         FormValidators.required,
///         FormValidators.email,
///       ])),
///     );
///   }
///
///   void updatePassword(String value) {
///     state = state.copyWith(
///       password: validateField(value, FormValidators.compose([
///         FormValidators.required,
///         FormValidators.minLength(8),
///       ])),
///     );
///   }
///
///   @override
///   bool get isValid =>
///       state.email.isValid &&
///       state.password.isValid;
/// }
/// ```
abstract class FormStateNotifier<T> extends StateNotifier<T> {
  FormStateNotifier(super.state);

  /// Whether the form is currently valid
  bool get isValid;

  /// Whether the form is currently submitting
  bool get isSubmitting => false;

  /// Validate a field value and return the new field state
  StringFieldState validateField(
    String value,
    Validator validator, {
    bool touched = true,
  }) {
    final error = validator(value);
    return StringFieldState(
      value: value,
      error: error,
      isTouched: touched,
    );
  }

  /// Validate a field with async validator
  Future<StringFieldState> validateFieldAsync(
    String value,
    AsyncValidator validator, {
    bool touched = true,
  }) async {
    final error = await validator(value);
    return StringFieldState(
      value: value,
      error: error,
      isTouched: touched,
    );
  }

  /// Mark a field as touched without validation
  StringFieldState touchField(StringFieldState field) {
    return field.copyWith(isTouched: true);
  }

  /// Reset a field to initial state
  StringFieldState resetField({String initialValue = ''}) {
    return StringFieldState(value: initialValue);
  }
}

/// Mixin for forms with submission handling.
mixin FormSubmissionMixin<T> on FormStateNotifier<T> {
  bool _isSubmitting = false;

  @override
  bool get isSubmitting => _isSubmitting;

  /// Execute form submission with loading state management
  Future<R?> submitForm<R>(Future<R> Function() submit) async {
    if (!isValid || _isSubmitting) return null;

    _isSubmitting = true;
    try {
      final result = await submit();
      return result;
    } finally {
      _isSubmitting = false;
    }
  }
}

/// State class for simple forms with common fields.
class SimpleFormState {
  const SimpleFormState({
    this.fields = const {},
    this.isSubmitting = false,
    this.submitError,
  });

  /// Map of field names to their states
  final Map<String, StringFieldState> fields;

  /// Whether the form is submitting
  final bool isSubmitting;

  /// Error from last submission attempt
  final String? submitError;

  /// Get a field state by name
  StringFieldState getField(String name) {
    return fields[name] ?? const StringFieldState(value: '');
  }

  /// Get a field value by name
  String getValue(String name) => getField(name).value;

  /// Check if form is valid
  bool get isValid {
    return fields.values.every((field) => field.isValid);
  }

  /// Check if any field has errors
  bool get hasErrors {
    return fields.values.any((field) => field.isInvalid);
  }

  SimpleFormState copyWith({
    Map<String, StringFieldState>? fields,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return SimpleFormState(
      fields: fields ?? this.fields,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }
}

/// Notifier for simple dynamic forms.
class SimpleFormNotifier extends StateNotifier<SimpleFormState> {
  SimpleFormNotifier([SimpleFormState? initialState])
      : super(initialState ?? const SimpleFormState());

  /// Update a field value and validate
  void updateField(String name, String value, {Validator? validator}) {
    final currentFields = Map<String, StringFieldState>.from(state.fields);

    String? error;
    if (validator != null) {
      error = validator(value);
    }

    currentFields[name] = StringFieldState(
      value: value,
      error: error,
      isTouched: true,
    );

    state = state.copyWith(fields: currentFields, clearSubmitError: true);
  }

  /// Touch a field (mark as interacted)
  void touchField(String name) {
    final currentFields = Map<String, StringFieldState>.from(state.fields);
    final field = currentFields[name];

    if (field != null) {
      currentFields[name] = field.copyWith(isTouched: true);
      state = state.copyWith(fields: currentFields);
    }
  }

  /// Set field error manually
  void setFieldError(String name, String? error) {
    final currentFields = Map<String, StringFieldState>.from(state.fields);
    final field = currentFields[name];

    if (field != null) {
      currentFields[name] = field.copyWith(error: error);
      state = state.copyWith(fields: currentFields);
    }
  }

  /// Set multiple field errors (from server validation)
  void setFieldErrors(Map<String, String> errors) {
    final currentFields = Map<String, StringFieldState>.from(state.fields);

    for (final entry in errors.entries) {
      final field = currentFields[entry.key];
      if (field != null) {
        currentFields[entry.key] = field.copyWith(
          error: entry.value,
          isTouched: true,
        );
      }
    }

    state = state.copyWith(fields: currentFields);
  }

  /// Reset the form to initial state
  void reset([Map<String, String>? initialValues]) {
    if (initialValues == null) {
      state = const SimpleFormState();
    } else {
      state = SimpleFormState(
        fields: initialValues.map(
          (key, value) => MapEntry(key, StringFieldState(value: value)),
        ),
      );
    }
  }

  /// Get all field values as a map
  Map<String, String> get values {
    return state.fields.map((key, field) => MapEntry(key, field.value));
  }

  /// Check if form is valid
  bool get isValid => state.isValid;

  /// Set submitting state
  void setSubmitting({required bool isSubmitting}) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  /// Set submission error
  void setSubmitError(String? error) {
    state = state.copyWith(submitError: error);
  }
}
