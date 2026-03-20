// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseMessagingHash() => r'be66e6974401fb285741260c9c8b6a7ee0144368';

/// Provider for Firebase Messaging instance.
///
/// Copied from [firebaseMessaging].
@ProviderFor(firebaseMessaging)
final firebaseMessagingProvider = Provider<FirebaseMessaging>.internal(
  firebaseMessaging,
  name: r'firebaseMessagingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseMessagingHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseMessagingRef = ProviderRef<FirebaseMessaging>;
String _$fcmServiceHash() => r'4c449e65e6c07564fbdec24479a2a2ee98e0ab65';

/// See also [fcmService].
@ProviderFor(fcmService)
final fcmServiceProvider = Provider<FcmService>.internal(
  fcmService,
  name: r'fcmServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fcmServiceHash,
  dependencies: <ProviderOrFamily>[firebaseMessagingProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    firebaseMessagingProvider,
    ...?firebaseMessagingProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FcmServiceRef = ProviderRef<FcmService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
