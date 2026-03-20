import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';

import 'package:flutter_base/app.dart';
import 'package:flutter_base/main.dart';

void main() {
  patrolTest(
    'app launches and shows login screen',
    ($) async {
      // 1. Khởi tạo toàn bộ services (Firebase, Env, etc.) dành cho môi trường test
      final container = await initServices();

      await $.pumpWidgetAndSettle(
        UncontrolledProviderScope(
          container: container,
          child: const App(),
        ),
      );

      // Login title (vi: Đăng nhập, en: Login)
      expect(
        $('Đăng nhập').exists || $('Login').exists,
        isTrue,
      );
    },
  );
}
