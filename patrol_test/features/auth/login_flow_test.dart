import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'package:flutter_base/app.dart';

void main() {
  patrolTest(
    'full login flow: invalid credentials, valid credentials, and logout',
    ($) async {
      await $.pumpWidgetAndSettle(const ProviderScope(child: App()));

      final usernameField = $(TextField).at(0);
      final passwordField = $(TextField).at(1);
      final loginButton = $(FilledButton);

      // 1. Nhập thông tin đăng nhập SAI
      await usernameField.enterText('wrong_user');
      await passwordField.enterText('wrong_password');
      await loginButton.tap();

      // Kiểm tra có hiển thị thông báo lỗi bằng SnackBar
      await $.waitUntilVisible($(SnackBar));
      expect($(SnackBar).exists, isTrue);

      // Đợi SnackBar ẩn đi trước khi thao tác tiếp theo
      await $.pumpAndSettle();

      // 2. Chuẩn bị thông tin đăng nhập ĐÚNG
      const username = 'hunghq';
      const password = '12345';

      // 3. Nhập thông tin đăng nhập ĐÚNG
      await usernameField.enterText(username);
      await passwordField.enterText(password);
      await loginButton.tap();

      // 4. Xác nhận đăng nhập thành công (thấy icon Đăng xuất ở HomeScreen)
      await $.waitUntilVisible($(#logoutIcon));
      expect($(#logoutIcon).exists, isTrue);

      // 5. Đăng xuất để reset trạng thái (sẵn sàng cho các test case khác nếu có)
      await $(#logoutIcon).tap();
      await $.pumpAndSettle();
      
      // Xác nhận đã quay lại màn hình đăng nhập (thấy nút Đăng nhập)
      await $.waitUntilVisible($(FilledButton));
      expect($(FilledButton).exists, isTrue);
    },
  );
}
