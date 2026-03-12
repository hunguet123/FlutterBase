import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/pump_app.dart';

class FakeAuthRepository extends Fake implements AuthRepository {
  @override
  Future<void> login(String username, String password) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<bool> hasSession() async => false;
}

void main() {
  group('LoginScreen', () {
    testWidgets('should show login form with username and password fields',
        (tester) async {
      await pumpAppWithProviders(
        tester,
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
      );
      await tester.pumpAndSettle();

      final t = LocaleSettings.instance.currentTranslations;
      expect(find.text(t.login.title), findsAtLeast(1));
      expect(find.text(t.login.submit), findsAtLeast(1));
      expect(find.text(t.login.username), findsAtLeast(1));
      expect(find.text(t.login.password), findsAtLeast(1));
    });

    testWidgets('should call login with username and password on submit',
        (tester) async {
      late String capturedUsername;
      late String capturedPassword;
      final fakeRepo = _CapturingFakeAuthRepository(
        onLogin: (u, p) {
          capturedUsername = u;
          capturedPassword = p;
        },
      );

      await pumpAppWithProviders(
        tester,
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Hunghq',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '123456',
      );
      final t = LocaleSettings.instance.currentTranslations;
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(capturedUsername, 'Hunghq');
      expect(capturedPassword, '123456');
    });
  });
}

class _CapturingFakeAuthRepository extends Fake implements AuthRepository {
  _CapturingFakeAuthRepository({required this.onLogin});

  final void Function(String username, String password) onLogin;

  @override
  Future<void> login(String username, String password) async {
    onLogin(username, password);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> hasSession() async => false;
}
