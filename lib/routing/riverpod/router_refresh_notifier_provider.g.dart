// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_refresh_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerRefreshNotifierHash() =>
    r'4b5f0a16b6319ad5f99d6f4f0a671d915346d05f';

/// See also [routerRefreshNotifier].
@ProviderFor(routerRefreshNotifier)
final routerRefreshNotifierProvider =
    Provider<Raw<RouterRefreshNotifier>>.internal(
      routerRefreshNotifier,
      name: r'routerRefreshNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$routerRefreshNotifierHash,
      dependencies: <ProviderOrFamily>[
        appIsLoggedInProvider,
        appIsMaintenanceProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        appIsLoggedInProvider,
        ...?appIsLoggedInProvider.allTransitiveDependencies,
        appIsMaintenanceProvider,
        ...?appIsMaintenanceProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRefreshNotifierRef = ProviderRef<Raw<RouterRefreshNotifier>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
