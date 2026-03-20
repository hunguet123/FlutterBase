// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_maintenance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appIsMaintenanceHash() => r'f21f32de5782b75b03ee0c3ad71d81e2a5988fdc';

/// App-level maintenance flag for routing.
/// Reactive: updates whenever Remote Config pushes a new value.
///
/// Copied from [appIsMaintenance].
@ProviderFor(appIsMaintenance)
final appIsMaintenanceProvider = Provider<bool>.internal(
  appIsMaintenance,
  name: r'appIsMaintenanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appIsMaintenanceHash,
  dependencies: <ProviderOrFamily>[appConfigProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    appConfigProvider,
    ...?appConfigProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppIsMaintenanceRef = ProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
