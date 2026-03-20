// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiClientHash() => r'eb87b33acecbb33fcd9cf999aae354484227a03a';

/// Provides configured Dio instance for API calls.
///
/// Copied from [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = Provider<Dio>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiClientHash,
  dependencies: <ProviderOrFamily>[
    authSessionStoreProvider,
    secureStorageProvider,
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    authSessionStoreProvider,
    ...?authSessionStoreProvider.allTransitiveDependencies,
    secureStorageProvider,
    ...?secureStorageProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = ProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
