# Hướng dẫn Firebase: Dự án Flutter Base

Tài liệu này hướng dẫn cách sử dụng và cấu hình các dịch vụ Firebase tích hợp trong dự án (Analytics, Crashlytics, Messaging, Remote Config).

---

## 1. Firebase Remote Config (Cấu hình từ xa)

Dùng để thay đổi hành vi/giao diện ứng dụng mà không cần cập nhật phiên bản mới.

### Cách tạo tham số trên Firebase Console
1. **Parameter key**: Viết snake_case (ví dụ: `maintenance_mode`).
2. **Data type**: Chọn Boolean, String, Number... tùy nhu cầu.
3. **Default value**: Giá trị mặc định khi chưa fetch được.
4. **Publish changes**: Luôn bấm nút này để cấu hình có hiệu lực.

### Danh sách Key hiện có
Quản lý tập trung tại `lib/core/config/remote_config_keys.dart`:
- `maintenance_mode` (bool): Khi bật `true`, toàn bộ app chuyển sang màn hình bảo trì **ngay lập tức** (reactive qua `RouterRefreshNotifier`).
- `feature_flag_login_enabled` (bool): Bật/tắt tính năng đăng nhập.
- `api_timeout_seconds` (number): Cấu hình timeout cho Dio.

### Cách đọc giá trị trong code
Không đọc `FirebaseRemoteConfig` trực tiếp. Dùng `appConfigProvider` để nhận `AppConfig` — domain model đã được map sẵn:

```dart
final appConfig = ref.watch(appConfigProvider);
if (appConfig.maintenanceMode) { ... }
```

### Cách thêm key mới
1. Thêm constant vào `lib/core/config/remote_config_keys.dart`.
2. Thêm default value vào `initRemoteConfig()` trong `lib/core/config/data/remote_config_client_provider.dart`.
3. Thêm field vào `AppConfig` tại `lib/core/config/domain/models/app_config.dart`.
4. Map field trong `_appConfigFromRemoteConfig()` tại `lib/core/config/data/app_config_provider.dart`.

---

## 2. Firebase Analytics (Phân tích hành vi)

Dùng để theo dõi người dùng đang làm gì trên ứng dụng.

### Log sự kiện (Events)
Sử dụng hằng số tại `lib/core/analytics/data/analytics_events.dart` để đảm bảo đồng nhất:

```dart
ref.read(analyticsProvider).logEvent(
  name: AnalyticsEvents.login,
  parameters: {'method': 'password'},
);
```

### Theo dõi màn hình (Screen View)
`AnalyticsRouteObserver` (tại `lib/routing/analytics_route_observer.dart`) tự động log `screen_view` mỗi khi chuyển trang. Không cần log thủ công trong đa số trường hợp.

### Thêm event mới
Thêm constant vào `AnalyticsEvents` trước khi dùng — tránh hardcode string rải rác trong code.

---

## 3. Firebase Messaging — FCM (Thông báo đẩy)

### Luồng hoạt động
Được khởi tạo tại `main.dart` thông qua `fcmServiceProvider`:
- **Foreground**: Khi đang mở app, `FcmService` nhận message qua stream và xử lý tùy biến.
- **Background/Terminated**: Hệ thống native hiển thị thông báo qua `firebaseMessagingBackgroundHandler` (top-level function, chạy isolate riêng).

### Lấy FCM Token
Token được in ra log khi app khởi động (tìm từ khóa `FCM Token` trong console). Dùng để test gửi thông báo thủ công từ Firebase Console.

### Xử lý message
Để xử lý logic khi nhận message (ví dụ: navigate đến màn hình cụ thể), lắng nghe stream trong `FcmService`:
```dart
container.read(fcmServiceProvider).onMessageOpenedApp.listen((message) {
  // handle deep link
});
```

---

## 4. Firebase Crashlytics (Báo cáo lỗi)

### Tự động báo cáo
Dự án đã cấu hình tự động gửi báo cáo lỗi trong 2 trường hợp:
1. **Lỗi Flutter Fatal**: Các lỗi làm sập app — qua `FlutterError.onError` trong `main.dart`.
2. **Lỗi API**: Mọi lỗi từ server (4xx, 5xx) — qua `ErrorInterceptor` trong `lib/core/network/api_interceptors.dart`.

### Log lỗi thủ công (Non-fatal)
```dart
FirebaseCrashlytics.instance.recordError(
  exception,
  stackTrace,
  reason: 'Mô tả ngữ cảnh lỗi',
  fatal: false,
);
```

---

## 5. Cấu hình Native (Lưu ý quan trọng)

Để Firebase hoạt động, **phải** đặt file cấu hình vào đúng chỗ:

**Android:**
- Dev: `android/app/src/development/google-services.json`
- Prod: `android/app/src/production/google-services.json`

**iOS:**
- Dev: `ios/Runner/GoogleService-Info-Development.plist`
- Prod: `ios/Runner/GoogleService-Info-Production.plist`

---
*Dự án hiện tại đang sử dụng Firebase theo chuẩn an toàn và tách biệt flavor.*
