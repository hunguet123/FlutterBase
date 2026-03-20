# 🔥 Hướng dẫn Firebase: Dự án Flutter Base

Tài liệu này hướng dẫn cách sử dụng và cấu hình các dịch vụ Firebase tích hợp trong dự án (Analytics, Crashlytics, Messaging, Remote Config).

---

## 1. Firebase Remote Config (Cấu hình từ xa)

Dùng để thay đổi hành vi/giao diện ứng dụng mà không cần cập nhật phiên bản mới.

### 🔹 Cách tạo tham số trên Firebase Console
Toàn bộ tham số được quản lý tại mục **Remote Config** trên Firebase Console:
1.  **Parameter key**: Viết snake_case (ví dụ: `maintenance_mode`).
2.  **Data type**: Chọn Boolean, String, Number... tùy nhu cầu.
3.  **Default value**: Giá trị mặc định khi chưa fetch được.
4.  **Publish changes**: Luôn bấm nút này để cấu hình có hiệu lực.

### 🔹 Danh sách Key hiện có trong Code
Quản lý tập trung tại `lib/core/config/remote_config_keys.dart`:
-   `maintenance_mode` (bool): Khi bật `true`, toàn bộ app chuyển sang màn hình bảo trì.
-   `feature_flag_login_enabled` (bool): Bật/tắt tính năng đăng nhập.
-   `api_timeout_seconds` (number): Cấu hình timeout cho Dio.

---

## 2. Firebase Analytics (Phân tích hành vi)

Dùng để theo dõi người dùng đang làm gì trên ứng dụng.

### 🔹 Log sự kiện (Events)
Sử dụng hằng số tại `lib/core/analytics/analytics_events.dart` để đảm bảo đồng nhất:

```dart
final analytics = ref.read(analyticsProvider);
await analytics.logEvent(
  name: AnalyticsEvents.login,
  parameters: {'method': 'password'},
);
```

### 🔹 Theo dõi màn hình (Screen View)
Hệ thống router (`app_router.dart`) đã được cấu hình tự động log `screen_view` mỗi khi chuyển trang thông qua `observers`. Bạn không cần log thủ công trong đa số trường hợp.

---

## 3. Firebase Messaging - FCM (Thông báo đẩy)

### 🔹 Luồng hoạt động
Được khởi tạo tại `main.dart` thông qua `fcmServiceProvider`:
-   **Foreground**: Khi đang mở app, thông báo sẽ in log và xử lý tùy biến.
-   **Background/Terminated**: Khi app đang đóng, hệ thống native sẽ hiển thị thông báo.

### 🔹 Lấy Token
Để test gửi thông báo thủ công từ Firebase Console, bạn cần FCM Token. Token này được in ra log khi app vừa khởi động (tìm từ khóa `FCM Token` trong console log).

---

## 4. Firebase Crashlytics (Báo cáo lỗi)

### 🔹 Tự động báo cáo
Dự án đã cấu hình tự động gửi báo cáo lỗi Crashlytics trong 2 trường hợp:
1.  **Lỗi Flutter Fatal**: Các lỗi làm sập app (Crash).
2.  **Lỗi API**: Mọi lỗi từ server (4xx, 5xx) đều được log lại thông qua `ErrorInterceptor`.

### 🔹 Xem log lỗi
Truy cập **Crashlytics** trên Firebase Console để xem chi tiết StackTrace giúp fix bug nhanh chóng.

---

## 5. Quy trình cấu hình Native (Lưu ý quan trọng)

Để Firebase hoạt động, bạn **phải** đặt file cấu hình vào đúng chỗ:

**Android:**
-   Dev: `android/app/src/development/google-services.json`
-   Prod: `android/app/src/production/google-services.json`

**iOS:**
-   Dev: `ios/Runner/GoogleService-Info-Development.plist`
-   Prod: `ios/Runner/GoogleService-Info-Production.plist`

---
*Dự án hiện tại đang sử dụng Firebase theo chuẩn an toàn và tách biệt flavor.*
