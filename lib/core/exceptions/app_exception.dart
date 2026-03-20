/// Base class for application-specific exceptions.
sealed class AppException implements Exception {
  AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Thrown when the system is in maintenance mode.
class MaintenanceException extends AppException {
  MaintenanceException([String message = 'System is under maintenance']) : super(message);
}

/// Thrown for authentication-related errors.
class AuthException extends AppException {
  AuthException(super.message);
}
