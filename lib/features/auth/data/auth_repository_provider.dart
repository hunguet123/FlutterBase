import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/core/network/network_providers.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';

/// Provides [AuthRepository] implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(dio);
});
