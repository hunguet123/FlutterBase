// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerHash() => r'b4fc69a7a1869d81968e9f91ba5ea415cdf49459';

/// Provider for application router.
///
/// Copied from [router].
@ProviderFor(router)
final routerProvider = Provider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: <ProviderOrFamily>[
    routerRefreshNotifierProvider,
    analyticsProvider,
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    routerRefreshNotifierProvider,
    ...?routerRefreshNotifierProvider.allTransitiveDependencies,
    analyticsProvider,
    ...?analyticsProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
