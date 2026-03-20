// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRefreshNotifierHash() =>
    r'64189022cb9baaedd0e7551878a8d831a5dc27d6';

/// Provider for GoRouterRefreshNotifier.
///
/// Copied from [authRefreshNotifier].
@ProviderFor(authRefreshNotifier)
final authRefreshNotifierProvider =
    Provider<Raw<GoRouterRefreshNotifier>>.internal(
      authRefreshNotifier,
      name: r'authRefreshNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authRefreshNotifierHash,
      dependencies: <ProviderOrFamily>{
        authNotifierProvider,
        authRepositoryProvider,
        apiClientProvider,
        authSessionStoreProvider,
        secureStorageProvider,
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
        secureStorageProvider,
        ...?secureStorageProvider.allTransitiveDependencies,
        remoteConfigProvider,
        ...?remoteConfigProvider.allTransitiveDependencies,
        analyticsProvider,
        ...?analyticsProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRefreshNotifierRef = ProviderRef<Raw<GoRouterRefreshNotifier>>;
String _$routerHash() => r'0a813d14ccde7395393b20dc733a98a96a5e89c2';

/// Provider for application router.
///
/// Copied from [router].
@ProviderFor(router)
final routerProvider = Provider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: <ProviderOrFamily>{
    authRefreshNotifierProvider,
    authNotifierProvider,
    authRepositoryProvider,
    apiClientProvider,
    authSessionStoreProvider,
    secureStorageProvider,
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
    secureStorageProvider,
    ...?secureStorageProvider.allTransitiveDependencies,
    remoteConfigProvider,
    ...?remoteConfigProvider.allTransitiveDependencies,
    analyticsProvider,
    ...?analyticsProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
