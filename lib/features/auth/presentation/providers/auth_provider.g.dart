// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'dd60713fb76986706cc3362684be7cb0781b7eee';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authNotifierHash,
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

typedef _$AuthNotifier = AsyncNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
