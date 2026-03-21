import 'package:flutter/foundation.dart';

import 'package:flutter_base/routing/router_refresh_state.dart';

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
