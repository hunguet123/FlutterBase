/// Centralized Firebase Analytics event and screen names.
abstract final class AnalyticsEvents {
  AnalyticsEvents._();

  // Custom events
  static const String login = 'login';
  static const String logout = 'logout';

  // Screen names (for logScreenView)
  static const String screenLogin = 'login';
  static const String screenHome = 'home';
}
