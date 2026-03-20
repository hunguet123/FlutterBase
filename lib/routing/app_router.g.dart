// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRefreshNotifierHash() =>
    r'9b0d84f0bf19b2f90215316833b7df08f0096acf';

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
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRefreshNotifierRef = ProviderRef<Raw<GoRouterRefreshNotifier>>;
String _$routerHash() => r'fe8152ef56eaa2156c2087dfe96882e758abd9d7';

/// Provider for application router.
///
/// Copied from [router].
@ProviderFor(router)
final routerProvider = Provider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
