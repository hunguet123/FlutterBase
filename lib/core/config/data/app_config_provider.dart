import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/config/remote_config_keys.dart';
import 'package:flutter_base/core/config/remote_config_provider.dart';
import 'package:flutter_base/core/config/domain/models/app_config.dart';

part 'app_config_provider.g.dart';

/// Provides app-wide Remote Config values as a domain-friendly model.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) {
  final remoteConfig = ref.watch(remoteConfigProvider);
  return _appConfigFromRemoteConfig(remoteConfig);
}

AppConfig _appConfigFromRemoteConfig(FirebaseRemoteConfig remoteConfig) {
  return AppConfig(
    featureFlagLoginEnabled: remoteConfig.getBool(
      RemoteConfigKeys.featureFlagLoginEnabled,
    ),
    apiTimeoutSeconds: remoteConfig.getInt(RemoteConfigKeys.apiTimeoutSeconds),
    maintenanceMode: remoteConfig.getBool(RemoteConfigKeys.maintenanceMode),
  );
}
