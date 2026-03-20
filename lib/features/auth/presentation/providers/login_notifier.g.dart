// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginNotifierHash() => r'6f93b6072fd03488b190e049cd25b4c23751ae26';

/// See also [LoginNotifier].
@ProviderFor(LoginNotifier)
final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>.internal(
      LoginNotifier.new,
      name: r'loginNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$loginNotifierHash,
      dependencies: <ProviderOrFamily>[
        authRepositoryProvider,
        appConfigProvider,
        analyticsProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        authRepositoryProvider,
        ...?authRepositoryProvider.allTransitiveDependencies,
        appConfigProvider,
        ...?appConfigProvider.allTransitiveDependencies,
        analyticsProvider,
        ...?analyticsProvider.allTransitiveDependencies,
      },
    );

typedef _$LoginNotifier = Notifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
