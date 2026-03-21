// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appConfigHash() => r'4e468b75c1ddf3eb447e0135add685e3d508a2be';

/// Provides app-wide Remote Config values as a domain-friendly model.
///
/// Copied from [appConfig].
@ProviderFor(appConfig)
final appConfigProvider = Provider<AppConfig>.internal(
  appConfig,
  name: r'appConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appConfigHash,
  dependencies: <ProviderOrFamily>[remoteConfigProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    remoteConfigProvider,
    ...?remoteConfigProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppConfigRef = ProviderRef<AppConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
