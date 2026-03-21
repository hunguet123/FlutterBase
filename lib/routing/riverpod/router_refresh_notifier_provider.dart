import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/app/providers/app_maintenance_provider.dart';
import 'package:flutter_base/app/session/app_auth_provider.dart';
import 'package:flutter_base/routing/router_refresh_notifier.dart';
import 'package:flutter_base/routing/router_refresh_state.dart';

part 'router_refresh_notifier_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [appIsLoggedIn, appIsMaintenance])
Raw<RouterRefreshNotifier> routerRefreshNotifier(Ref ref) {
  final initialState = RouterRefreshState(
    isLoggedIn: ref.read(appIsLoggedInProvider),
    isMaintenance: ref.read(appIsMaintenanceProvider),
  );
  final notifier = RouterRefreshNotifier(
    initialState,
  );

  ref.listen<bool>(appIsLoggedInProvider, (_, next) => notifier.updateAuth(next));
  ref.listen<bool>(appIsMaintenanceProvider, (_, next) => notifier.updateMaintenance(next));

  ref.onDispose(notifier.dispose);

  return notifier;
}
