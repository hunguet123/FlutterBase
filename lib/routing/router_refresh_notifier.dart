import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_base/app/session/app_auth_provider.dart';
import 'package:flutter_base/app/providers/app_maintenance_provider.dart';
import 'package:flutter_base/routing/router_refresh_state.dart';

part 'router_refresh_notifier.g.dart';

/// Bridge between Riverpod state and GoRouter's [refreshListenable].
/// Notifies GoRouter to re-evaluate redirects when auth or maintenance changes.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._state);

  RouterRefreshState _state;

  RouterRefreshState get state => _state;

  bool get isLoggedIn => _state.isLoggedIn;
  bool get isMaintenance => _state.isMaintenance;

  void updateAuth(bool value) {
    if (_state.isLoggedIn == value) return;
    _state = _state.copyWith(isLoggedIn: value);
    notifyListeners();
  }

  void updateMaintenance(bool value) {
    if (_state.isMaintenance == value) return;
    _state = _state.copyWith(isMaintenance: value);
    notifyListeners();
  }
}

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
