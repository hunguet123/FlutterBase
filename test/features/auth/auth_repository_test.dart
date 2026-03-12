import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fake_secure_storage.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late FakeSecureStorage fakeStorage;

  setUp(() {
    mockDio = MockDio();
    fakeStorage = FakeSecureStorage();
    AuthSessionStore.initWith(fakeStorage);
  });

  tearDown(() {
    AuthSessionStore.resetForTesting();
  });

  group('AuthRepositoryImpl', () {
    test('login should POST to /auth/login with username and password',
        () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {'access_token': 'test_token'},
              ));

      final repo = AuthRepositoryImpl(mockDio);
      await repo.login('Hunghq', '123456');

      verify(
        () => mockDio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'username': 'Hunghq', 'password': '123456'},
        ),
      ).called(1);
    });

    test('login should store access_token when response contains access_token',
        () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {'access_token': 'my_token_123'},
              ));

      final repo = AuthRepositoryImpl(mockDio);
      await repo.login('user', 'pass');

      expect(AuthSessionStore.instance.accessToken, 'my_token_123');
    });

    test('login should store token when response contains legacy token key',
        () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {'token': 'legacy_token'},
              ));

      final repo = AuthRepositoryImpl(mockDio);
      await repo.login('user', 'pass');

      expect(AuthSessionStore.instance.accessToken, 'legacy_token');
    });

    test('login should store refresh_token when present in response',
        () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {
                  'access_token': 'access_123',
                  'refresh_token': 'refresh_456',
                },
              ));

      final repo = AuthRepositoryImpl(mockDio);
      await repo.login('user', 'pass');

      expect(AuthSessionStore.instance.accessToken, 'access_123');
      expect(await AuthSessionStore.instance.getRefreshToken(), 'refresh_456');
    });

    test('login should throw DioException when response is 401', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
      ));

      final repo = AuthRepositoryImpl(mockDio);

      await expectLater(
        () => repo.login('wrong', 'wrong'),
        throwsA(isA<DioException>()),
      );
    });

    test('logout should clear tokens', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {'access_token': 'some_token'},
              ));

      final repo = AuthRepositoryImpl(mockDio);
      await repo.login('user', 'pass');
      expect(AuthSessionStore.instance.accessToken, 'some_token');

      await repo.logout();

      expect(AuthSessionStore.instance.accessToken, isNull);
    });

    test('hasSession returns true when access token exists', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {'access_token': 'valid_token'},
              ));

      final repo = AuthRepositoryImpl(mockDio);
      await repo.login('user', 'pass');

      expect(await repo.hasSession(), true);
    });

    test('hasSession returns false when no token', () async {
      final repo = AuthRepositoryImpl(mockDio);

      expect(await repo.hasSession(), false);
    });
  });
}
