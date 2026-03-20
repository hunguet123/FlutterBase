import 'package:flutter_base/core/config/domain/models/app_config.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the login business logic.
///
/// Responsibilities:
/// - Guard against maintenance mode before attempting login.
/// - Delegate credential validation to [AuthRepository].
///
/// Keeping this logic here (not in the notifier) allows it to be reused
/// across multiple entry points (e.g. biometric re-auth, deep-link login)
/// and tested independently of Riverpod.
class LoginUseCase {
  const LoginUseCase(this._authRepository, this._appConfig);

  final AuthRepository _authRepository;
  final AppConfig _appConfig;

  Future<void> call(String username, String password) async {
    if (_appConfig.maintenanceMode) {
      throw MaintenanceException();
    }

    final trimmedUsername = username.trim();
    if (trimmedUsername.isEmpty) {
      throw ValidationException('Username is required');
    }
    if (trimmedUsername.length < 3) {
      throw ValidationException('Username must be at least 3 characters');
    }
    if (password.isEmpty) {
      throw ValidationException('Password is required');
    }
    if (password.length < 6) {
      throw ValidationException('Password must be at least 6 characters');
    }

    await _authRepository.login(trimmedUsername, password);
  }
}
