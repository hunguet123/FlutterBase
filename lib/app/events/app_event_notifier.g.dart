// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_event_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appEventNotifierHash() => r'494ec5a4dc10d4041772957975d7f5bb43596382';

/// Broadcast channel for app-level intents.
///
/// Any screen emits an [AppEvent] here. The app layer ([App] widget) listens
/// and delegates to the appropriate handler — keeping feature screens
/// decoupled from app-level state managers like [AuthSessionNotifier].
///
/// Copied from [AppEventNotifier].
@ProviderFor(AppEventNotifier)
final appEventNotifierProvider =
    NotifierProvider<AppEventNotifier, AppEvent?>.internal(
      AppEventNotifier.new,
      name: r'appEventNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$appEventNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppEventNotifier = Notifier<AppEvent?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
