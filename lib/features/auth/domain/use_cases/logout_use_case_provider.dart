import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/features/auth/domain/use_cases/logout_use_case.dart';

part 'logout_use_case_provider.g.dart';

@Riverpod(dependencies: [authRepository])
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}
