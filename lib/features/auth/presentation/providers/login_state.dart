import 'package:flutter_base/core/exceptions/app_exception.dart';

class LoginState {
  const LoginState({required this.isLoading, this.error});

  final bool isLoading;

  /// Non-null when the last login attempt failed.
  /// Reset to null at the start of each new attempt.
  final AppException? error;

  factory LoginState.initial() => const LoginState(isLoading: false);

  LoginState copyWith({
    bool? isLoading,
    AppException? error,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
