// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRefreshNotifierHash() =>
    r'df767a96cdeb006cafc9b995ac2e71b6acf70352';

/// Provider for GoRouterRefreshNotifier.
///
/// Copied from [authRefreshNotifier].
@ProviderFor(authRefreshNotifier)
final authRefreshNotifierProvider =
    AutoDisposeProvider<Raw<GoRouterRefreshNotifier>>.internal(
      authRefreshNotifier,
      name: r'authRefreshNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authRefreshNotifierHash,
      dependencies: <ProviderOrFamily>{
        authNotifierProvider,
        authRepositoryProvider,
        apiClientProvider,
        authSessionStoreProvider,
        remoteConfigProvider,
        analyticsProvider,
      },
      allTransitiveDependencies: <ProviderOrFamily>{
        authNotifierProvider,
        ...?authNotifierProvider.allTransitiveDependencies,
        authRepositoryProvider,
        ...?authRepositoryProvider.allTransitiveDependencies,
        apiClientProvider,
        ...?apiClientProvider.allTransitiveDependencies,
        authSessionStoreProvider,
        ...?authSessionStoreProvider.allTransitiveDependencies,
        remoteConfigProvider,
        ...?remoteConfigProvider.allTransitiveDependencies,
        analyticsProvider,
        ...?analyticsProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRefreshNotifierRef =
    AutoDisposeProviderRef<Raw<GoRouterRefreshNotifier>>;
String _$routerHash() => r'b9159add089233ef94aca747fdb3b1656632a7da';

/// Provider for application router.
///
/// Copied from [router].
@ProviderFor(router)
final routerProvider = AutoDisposeProvider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routerHash,
  dependencies: <ProviderOrFamily>{
    authRefreshNotifierProvider,
    authNotifierProvider,
    authRepositoryProvider,
    apiClientProvider,
    authSessionStoreProvider,
    remoteConfigProvider,
    analyticsProvider,
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    authRefreshNotifierProvider,
    ...?authRefreshNotifierProvider.allTransitiveDependencies,
    authNotifierProvider,
    ...?authNotifierProvider.allTransitiveDependencies,
    authRepositoryProvider,
    ...?authRepositoryProvider.allTransitiveDependencies,
    apiClientProvider,
    ...?apiClientProvider.allTransitiveDependencies,
    authSessionStoreProvider,
    ...?authSessionStoreProvider.allTransitiveDependencies,
    remoteConfigProvider,
    ...?remoteConfigProvider.allTransitiveDependencies,
    analyticsProvider,
    ...?analyticsProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = AutoDisposeProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
