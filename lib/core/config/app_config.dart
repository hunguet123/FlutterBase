/// Subset of Remote Config (and related) values exposed to the app as a single model.
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
