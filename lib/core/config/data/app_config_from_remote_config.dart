import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:flutter_base/core/config/domain/models/app_config.dart';
import 'package:flutter_base/core/config/remote_config_keys.dart';

AppConfig appConfigFromRemoteConfig(FirebaseRemoteConfig remoteConfig) {
  return AppConfig(
    featureFlagLoginEnabled: remoteConfig.getBool(
      RemoteConfigKeys.featureFlagLoginEnabled,
    ),
    apiTimeoutSeconds: remoteConfig.getInt(RemoteConfigKeys.apiTimeoutSeconds),
    maintenanceMode: remoteConfig.getBool(RemoteConfigKeys.maintenanceMode),
  );
}
