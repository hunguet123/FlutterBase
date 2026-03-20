// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appIsLoggedInHash() => r'01f12734c6297e034b1d446050c9c98fd3391d61';

/// App-level auth status for routing/composition root.
/// Keeps `GoRouter` independent from auth feature state shape.
///
/// Copied from [appIsLoggedIn].
@ProviderFor(appIsLoggedIn)
final appIsLoggedInProvider = Provider<bool>.internal(
  appIsLoggedIn,
  name: r'appIsLoggedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appIsLoggedInHash,
  dependencies: <ProviderOrFamily>[authSessionNotifierProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    authSessionNotifierProvider,
    ...?authSessionNotifierProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppIsLoggedInRef = ProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
