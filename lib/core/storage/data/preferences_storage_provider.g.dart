// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$preferencesStorageHash() =>
    r'a6363cd25e26eb920973ab5e99a217676efb4566';

/// Provider for [PreferencesStorage].
/// Async because SharedPreferences requires initialization.
///
/// Copied from [preferencesStorage].
@ProviderFor(preferencesStorage)
final preferencesStorageProvider = FutureProvider<PreferencesStorage>.internal(
  preferencesStorage,
  name: r'preferencesStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preferencesStorageHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreferencesStorageRef = FutureProviderRef<PreferencesStorage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
