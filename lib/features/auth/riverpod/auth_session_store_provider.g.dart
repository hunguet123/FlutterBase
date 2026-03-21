// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSessionStoreHash() => r'2eccda9f055a99336a27eddea404dd59dde64a2b';

/// See also [authSessionStore].
@ProviderFor(authSessionStore)
final authSessionStoreProvider = Provider<AuthSessionStore>.internal(
  authSessionStore,
  name: r'authSessionStoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authSessionStoreHash,
  dependencies: <ProviderOrFamily>[secureStorageProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    secureStorageProvider,
    ...?secureStorageProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthSessionStoreRef = ProviderRef<AuthSessionStore>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
