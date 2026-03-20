// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'068e53d20c8f5da5dae2a57faf1cfdebadfd804b';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, bool>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: <ProviderOrFamily>{
    authRepositoryProvider,
    apiClientProvider,
    authSessionStoreProvider,
    secureStorageProvider,
    appConfigProvider,
    analyticsProvider,
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    authRepositoryProvider,
    ...?authRepositoryProvider.allTransitiveDependencies,
    apiClientProvider,
    ...?apiClientProvider.allTransitiveDependencies,
    authSessionStoreProvider,
    ...?authSessionStoreProvider.allTransitiveDependencies,
    secureStorageProvider,
    ...?secureStorageProvider.allTransitiveDependencies,
    appConfigProvider,
    ...?appConfigProvider.allTransitiveDependencies,
    analyticsProvider,
    ...?analyticsProvider.allTransitiveDependencies,
  },
);

typedef _$AuthNotifier = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
