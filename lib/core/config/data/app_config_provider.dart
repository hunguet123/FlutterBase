import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/config/remote_config_provider.dart';
import 'package:flutter_base/core/config/domain/models/app_config.dart';
import 'package:flutter_base/core/config/data/app_config_from_remote_config.dart';

part 'app_config_provider.g.dart';

/// Provides app-wide Remote Config values as a domain-friendly model.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) {
  final remoteConfig = ref.watch(remoteConfigProvider);
  return appConfigFromRemoteConfig(remoteConfig);
}
