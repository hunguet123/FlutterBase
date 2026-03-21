import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/app/events/app_event.dart';

part 'app_event_notifier.g.dart';

/// Broadcast channel for app-level intents.
///
/// Any screen emits an [AppEvent] here. The app layer ([App] widget) listens
/// and delegates to the appropriate handler — keeping feature screens
/// decoupled from app-level state managers like [AuthSessionNotifier].
@Riverpod(keepAlive: true)
class AppEventNotifier extends _$AppEventNotifier {
  @override
  AppEvent? build() => null;

  void emit(AppEvent event) => state = event;
}
