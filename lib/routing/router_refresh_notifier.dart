import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/app/providers/app_auth_provider.dart';
import 'package:flutter_base/app/providers/app_maintenance_provider.dart';

part 'router_refresh_notifier.g.dart';

/// Bridge between Riverpod state and GoRouter's [refreshListenable].
/// Notifies GoRouter to re-evaluate redirects when auth or maintenance changes.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier({required bool isLoggedIn, required bool isMaintenance})
      : _isLoggedIn = isLoggedIn,
        _isMaintenance = isMaintenance;

  bool _isLoggedIn;
  bool _isMaintenance;

  bool get isLoggedIn => _isLoggedIn;
  bool get isMaintenance => _isMaintenance;

  void updateAuth(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }

  void updateMaintenance(bool value) {
    if (_isMaintenance != value) {
      _isMaintenance = value;
      notifyListeners();
    }
  }
}

@Riverpod(keepAlive: true)
Raw<RouterRefreshNotifier> routerRefreshNotifier(Ref ref) {
  final notifier = RouterRefreshNotifier(
    isLoggedIn: ref.read(appIsLoggedInProvider),
    isMaintenance: ref.read(appIsMaintenanceProvider),
  );

  ref.listen<bool>(appIsLoggedInProvider, (_, next) => notifier.updateAuth(next));
  ref.listen<bool>(appIsMaintenanceProvider, (_, next) => notifier.updateMaintenance(next));

  ref.onDispose(notifier.dispose);

  return notifier;
}
