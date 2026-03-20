// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginNotifierHash() => r'114186cdb7b8813f2f586c722fef3770e37017c5';

/// See also [LoginNotifier].
@ProviderFor(LoginNotifier)
final loginNotifierProvider =
    AutoDisposeNotifierProvider<LoginNotifier, LoginState>.internal(
      LoginNotifier.new,
      name: r'loginNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$loginNotifierHash,
      dependencies: <ProviderOrFamily>[
        loginUseCaseProvider,
        analyticsProvider,
        authSessionNotifierProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        loginUseCaseProvider,
        ...?loginUseCaseProvider.allTransitiveDependencies,
        analyticsProvider,
        ...?analyticsProvider.allTransitiveDependencies,
        authSessionNotifierProvider,
        ...?authSessionNotifierProvider.allTransitiveDependencies,
      },
    );

typedef _$LoginNotifier = AutoDisposeNotifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
