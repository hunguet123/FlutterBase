// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appIsLoggedInHash() => r'8eb9a32a52ee87635f564e14ecc10b46934ae0bd';

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
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppIsLoggedInRef = ProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
