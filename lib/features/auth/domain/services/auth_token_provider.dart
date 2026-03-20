/// Domain abstraction that provides the current access token (if any).
///
/// Kept in domain so infrastructure layers (e.g. networking) don't depend on
/// data-layer implementations.
abstract interface class AuthTokenProvider {
  String? get accessToken;
}
