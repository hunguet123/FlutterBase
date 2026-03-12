import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/features/auth/providers/auth_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.hasSession()).thenAnswer((_) async => false);
  });

  group('AuthNotifier', () {
    test('build returns hasSession from repository', () async {
      when(() => mockAuthRepository.hasSession()).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);

      final isLoggedIn = await container.read(authNotifierProvider.future);

      expect(isLoggedIn, true);
      verify(() => mockAuthRepository.hasSession()).called(1);
    });

    test('login should call repository and set state to true on success',
        () async {
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      final notifier = container.read(authNotifierProvider.notifier);
      expect(container.read(authNotifierProvider).valueOrNull, false);

      await notifier.login('Hunghq', '123456');

      verify(() => mockAuthRepository.login('Hunghq', '123456')).called(1);
      expect(container.read(authNotifierProvider).valueOrNull, true);
    });

    test('login should set error state and rethrow when repository throws',
        () async {
      when(() => mockAuthRepository.login(any(), any()))
          .thenThrow(Exception('API error'));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      final notifier = container.read(authNotifierProvider.notifier);
      expect(container.read(authNotifierProvider).valueOrNull, false);

      await expectLater(
        notifier.login('user', 'pass'),
        throwsA(isA<Exception>()),
      );

      final state = container.read(authNotifierProvider);
      expect(state.hasError, true);
    });

    test('logout should call repository and set state to false', () async {
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.login('Hunghq', '123456');
      expect(container.read(authNotifierProvider).valueOrNull, true);

      await notifier.logout();

      verify(() => mockAuthRepository.logout()).called(1);
      expect(container.read(authNotifierProvider).valueOrNull, false);
    });
  });
}
