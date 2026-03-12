import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'package:flutter_base/main.dart' as app;

void main() {
  patrolTest(
    'app launches and shows login screen',
    ($) async {
      app.main();
      await $.pumpAndSettle();

      // Login title (vi: Đăng nhập, en: Login)
      expect(
        $('Đăng nhập').exists || $('Login').exists,
        isTrue,
      );
    },
  );
}
