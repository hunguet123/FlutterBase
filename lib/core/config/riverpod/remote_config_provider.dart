import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/config/remote_config_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_provider.g.dart';

/// Provider for Firebase Remote Config instance.
@Riverpod(keepAlive: true, dependencies: [])
FirebaseRemoteConfig remoteConfig(Ref ref) {
  return FirebaseRemoteConfig.instance;
}

/// Initializes Remote Config with defaults and fetches/activates values.
Future<void> initRemoteConfig(FirebaseRemoteConfig remoteConfig) async {
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval:
          kDebugMode ? const Duration(minutes: 5) : const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults({
    RemoteConfigKeys.featureFlagLoginEnabled: true,
    RemoteConfigKeys.apiTimeoutSeconds: 30,
    RemoteConfigKeys.maintenanceMode: false,
  });
  await remoteConfig.fetchAndActivate();
}
