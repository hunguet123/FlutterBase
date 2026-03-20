// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginNotifierHash() => r'd447ca16f1f7f8b6b8c86cef53d6b8d542c15a0f';

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
      dependencies: <ProviderOrFamily>[loginUseCaseProvider, analyticsProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        loginUseCaseProvider,
        ...?loginUseCaseProvider.allTransitiveDependencies,
        analyticsProvider,
        ...?analyticsProvider.allTransitiveDependencies,
      },
    );

typedef _$LoginNotifier = AutoDisposeNotifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
