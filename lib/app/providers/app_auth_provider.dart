import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/app/providers/auth_session_notifier.dart';

part 'app_auth_provider.g.dart';

/// App-level auth status for routing/composition root.
/// Keeps `GoRouter` independent from auth feature state shape.
@Riverpod(keepAlive: true, dependencies: [AuthSessionNotifier])
bool appIsLoggedIn(Ref ref) {
  final authAsync = ref.watch(authSessionNotifierProvider);
  return authAsync.asData?.value.isLoggedIn ?? false;
}
