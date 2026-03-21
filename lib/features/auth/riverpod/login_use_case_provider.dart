import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/config/riverpod/app_config_provider.dart';
import 'package:flutter_base/features/auth/domain/login_use_case.dart';
import 'package:flutter_base/features/auth/riverpod/auth_repository_provider.dart';

part 'login_use_case_provider.g.dart';

@Riverpod(dependencies: [authRepository, appConfig])
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(
    ref.watch(authRepositoryProvider),
    ref.watch(appConfigProvider),
  );
}
