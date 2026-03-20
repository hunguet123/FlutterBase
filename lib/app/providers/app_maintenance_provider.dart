import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/config/data/app_config_provider.dart';

part 'app_maintenance_provider.g.dart';

/// App-level maintenance flag for routing.
/// Reactive: updates whenever Remote Config pushes a new value.
@Riverpod(keepAlive: true, dependencies: [appConfig])
bool appIsMaintenance(Ref ref) {
  return ref.watch(appConfigProvider).maintenanceMode;
}
