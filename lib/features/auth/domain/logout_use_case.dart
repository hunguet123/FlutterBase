import 'package:flutter_base/features/auth/domain/auth_repository.dart';

/// Encapsulates the logout business logic.
///
/// Currently delegates directly to [AuthRepository.logout], but having this
/// as a use case makes it straightforward to add pre/post logout steps later
/// (e.g. revoke push token, clear local cache, notify analytics).
class LogoutUseCase {
  const LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.logout();
  }
}
