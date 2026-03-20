import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/config/data/app_config_provider.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/features/auth/domain/use_cases/login_use_case.dart';

part 'login_use_case_provider.g.dart';

@Riverpod(dependencies: [authRepository, appConfig])
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(
    ref.watch(authRepositoryProvider),
    ref.watch(appConfigProvider),
  );
}
