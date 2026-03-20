/// Domain contract for authentication.
abstract interface class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> hasSession();
}
