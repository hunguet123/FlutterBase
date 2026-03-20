import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/config/remote_config_keys.dart';

/// Provider for Firebase Remote Config instance.
final remoteConfigProvider = Provider<FirebaseRemoteConfig>((ref) {
  return FirebaseRemoteConfig.instance;
});

/// Initializes Remote Config with defaults and fetches/activates values.
Future<void> initRemoteConfig(FirebaseRemoteConfig remoteConfig) async {
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: kDebugMode
          ? const Duration(minutes: 5)
          : const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults({
    RemoteConfigKeys.featureFlagLoginEnabled: true,
    RemoteConfigKeys.apiTimeoutSeconds: 30,
    RemoteConfigKeys.maintenanceMode: false,
  });
  await remoteConfig.fetchAndActivate();
}
