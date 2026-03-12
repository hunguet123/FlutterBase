import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/app.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';

/// Pumps the app with optional [authRepository] override for testing.
Future<void> pumpAppWithAuthOverride(
  WidgetTester tester, {
  AuthRepository? authRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: authRepository != null
          ? [authRepositoryProvider.overrideWithValue(authRepository)]
          : [],
      child: const App(),
    ),
  );
}
