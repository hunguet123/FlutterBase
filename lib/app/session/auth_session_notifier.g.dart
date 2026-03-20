// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSessionNotifierHash() =>
    r'e9668428b1d776bf6b2a09518e80037de30df75f';

/// App-level auth session: tracks login status and handles logout.
/// Lives in app/session/ because it is consumed by routing and any feature,
/// not just the auth feature itself.
///
/// Copied from [AuthSessionNotifier].
@ProviderFor(AuthSessionNotifier)
final authSessionNotifierProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthSessionState>.internal(
      AuthSessionNotifier.new,
      name: r'authSessionNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authSessionNotifierHash,
      dependencies: <ProviderOrFamily>[
        authRepositoryProvider,
        logoutUseCaseProvider,
        analyticsProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        authRepositoryProvider,
        ...?authRepositoryProvider.allTransitiveDependencies,
        logoutUseCaseProvider,
        ...?logoutUseCaseProvider.allTransitiveDependencies,
        analyticsProvider,
        ...?analyticsProvider.allTransitiveDependencies,
      },
    );

typedef _$AuthSessionNotifier = AsyncNotifier<AuthSessionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
