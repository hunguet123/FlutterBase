/// Domain model representing the subset of Remote Config values your app cares about.
class AppConfig {
  const AppConfig({
    required this.featureFlagLoginEnabled,
    required this.apiTimeoutSeconds,
    required this.maintenanceMode,
  });

  final bool featureFlagLoginEnabled;
  final int apiTimeoutSeconds;
  final bool maintenanceMode;
}
