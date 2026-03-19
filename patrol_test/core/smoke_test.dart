import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';

import 'package:flutter_base/app.dart';

void main() {
  patrolTest(
    'app launches and shows login screen',
    ($) async {
      await $.pumpWidgetAndSettle(const ProviderScope(child: App()));

      // Login title (vi: Đăng nhập, en: Login)
      expect(
        $('Đăng nhập').exists || $('Login').exists,
        isTrue,
      );
    },
  );
}
