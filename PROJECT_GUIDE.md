# Project Overview (Dành cho Fresher)

Chào mừng bạn đến với dự án **Flutter Base**! Đây là tài liệu hướng dẫn giúp bạn làm quen với cấu trúc code, các thư viện sử dụng và luồng hoạt động chính của ứng dụng.

## 1. Công nghệ sử dụng (Tech Stack)

Dự án được xây dựng dựa trên các thư viện phổ biến và mạnh mẽ nhất trong hệ sinh thái Flutter:

*   **State Management:** [Riverpod](https://riverpod.dev/). Dự án sử dụng Code Generation và tuân thủ chuẩn Riverpod 3.0 (sử dụng kiểu `Ref` và `dependencies` rõ ràng).
*   **Routing:** [GoRouter](https://pub.dev/packages/go_router). Quản lý chuyển trang và xử lý điều hướng thông minh.
*   **Networking:** [Dio](https://pub.dev/packages/dio). Thư viện HTTP client mạnh mẽ để gọi API.
*   **Localization (Đa ngôn ngữ):** [Slang](https://pub.dev/packages/slang). Giúp quản lý chuỗi ký tự theo kiểu type-safe, giảm thiểu sai sót.
*   **Firebase:** Tích hợp đầy đủ các dịch vụ:
    *   **Cloud Messaging (FCM):** Đẩy thông báo (Push alerts).
    *   **Analytics:** Theo dõi hành vi người dùng.
    *   **Crashlytics:** Báo cáo lỗi khi ứng dụng bị crash.
    *   **Remote Config:** Cấu hình ứng dụng từ xa mà không cần update bản mới.
*   **Local Storage:**
    *   `flutter_secure_storage`: Lưu trữ dữ liệu nhạy cảm (như Access Token).
    *   `shared_preferences`: Lưu trữ các cài đặt đơn giản (như theme, ngôn ngữ).

---

## 2. Cấu trúc thư mục (Project Structure)

Code được tổ chức theo Clean Architecture trong thư mục `lib/`:

```
lib/
├── app/
│   └── session/                # App-level session state dùng chung toàn app
│       ├── auth_session_state.dart
│       ├── auth_session_notifier.dart   # Quản lý trạng thái đăng nhập/đăng xuất
│       ├── app_auth_provider.dart       # isLoggedIn cho router
│       └── app_maintenance_provider.dart # isMaintenance cho router
├── core/                       # Hạ tầng dùng chung, không phụ thuộc features/
│   ├── analytics/data/         # Firebase Analytics provider + event constants
│   ├── config/                 # Remote Config, AppConfig model, env vars
│   │   ├── domain/models/      # AppConfig (domain model)
│   │   └── data/               # remoteConfigProvider, appConfigProvider
│   ├── constants/              # AppColors, AppDimens
│   ├── exceptions/             # AppException, MaintenanceException, AuthException
│   ├── messaging/              # FCM service
│   │   ├── domain/models/      # FcmMessage, FcmToken
│   │   └── data/               # FcmService + provider
│   ├── network/                # Dio setup, interceptors
│   │   ├── auth_token_provider.dart  # Slot provider (DI boundary)
│   │   └── data/               # apiClientProvider
│   ├── storage/                # SecureStorage, PreferencesStorage
│   │   ├── domain/             # Interfaces
│   │   └── data/               # Implementations + providers
│   └── theme/                  # AppTheme (light/dark)
├── features/                   # Code theo từng tính năng
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── interfaces/     # AuthTokenProvider (contract cho network layer)
│   │   │   ├── models/         # AuthTokens
│   │   │   └── repositories/   # AuthRepository (interface)
│   │   ├── data/
│   │   │   ├── auth_session_store.dart      # Token storage + provider
│   │   │   ├── auth_repository_provider.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/      # LoginState, LoginNotifier (UI state của login screen)
│   │       └── screens/        # LoginScreen
│   └── home/
│       └── presentation/screens/  # HomeScreen, MaintenanceScreen
├── routing/
│   ├── app_routes.dart              # Path constants
│   ├── analytics_route_observer.dart # NavigatorObserver cho Analytics
│   ├── router_refresh_state.dart     # Immutable state cho RouterRefreshNotifier
│   ├── router_refresh_notifier.dart  # ChangeNotifier bridge (GoRouter refreshListenable)
│   ├── go_router_factory.dart        # createAppRouter(...)
│   └── riverpod/                     # @Riverpod: routerRefreshNotifier, router
├── shared/
│   └── widgets/                # AppButton, AppTextField, AppAppBar
└── l10n/                       # File ngôn ngữ (.i18n.json)
```

---

## 3. Các luồng xử lý quan trọng

### 3.1. Quản lý môi trường (Environment)
App sử dụng flavor để tách biệt môi trường **Development** và **Production**.
*   Các biến như `API_BASE_URL` được định nghĩa trong `.env.dev` hoặc `.env.prod`.
*   Truy cập an toàn thông qua class `Env` tại `lib/core/config/env.dart`.

### 3.2. Luồng Authentication (Đăng nhập)
1.  Khi app khởi động (`main.dart`), token được load từ `SecureStorage` vào `AuthSessionStore`.
2.  `AuthSessionNotifier` (tại `app/session/`) kiểm tra session qua `AuthRepository`.
3.  `App` widget (`app.dart`) watch `authSessionNotifierProvider`:
    *   Nếu đang load: Hiển thị `CircularProgressIndicator`.
    *   Nếu đã load: GoRouter tự redirect dựa trên `appIsLoggedInProvider`.
4.  `LoginScreen` dùng `LoginNotifier` để quản lý UI state (isLoading) và gọi login.
5.  Sau khi login thành công, `LoginNotifier` invalidate `authSessionNotifierProvider` → router tự redirect sang `HomeScreen`.
6.  Khi gọi API, `AuthInterceptor` tự động thêm `Authorization: Bearer <token>` vào header.

### 3.3. Luồng Maintenance Mode
`RouterRefreshNotifier` watch cả `appIsLoggedInProvider` lẫn `appIsMaintenanceProvider`. Khi Remote Config push `maintenance_mode = true`, router tự redirect toàn bộ user sang `/maintenance` mà không cần restart app.

### 3.4. Xử lý API & Lỗi
*   Tất cả lỗi API đều được `ErrorInterceptor` ghi vào **Firebase Crashlytics**.
*   Log API được in ra console trong quá trình debug nhờ `ApiLogInterceptor`.

---

## 4. Lưu ý dành cho bạn

1.  **Code Generation:** Sau khi thêm Provider mới hoặc file ngôn ngữ, chạy:
    ```bash
    fvm dart run build_runner build --delete-conflicting-outputs
    ```
2.  **Đa ngôn ngữ:** Khi thêm chuỗi ký tự mới, hãy thêm vào file trong `lib/l10n/` và sử dụng thông qua object `t` (ví dụ: `t.login.title`).
3.  **UI Components:** Trước khi tạo Widget mới, kiểm tra `lib/shared/widgets/` xem đã có component tương tự chưa.
4.  **Tuyệt đối tuân thủ:**
    *   Không hardcode chuỗi ký tự hoặc địa chỉ API.
    *   `core/` không được import `features/` — đây là quy tắc kiến trúc quan trọng nhất.
    *   Dùng Riverpod để quản lý logic, tránh viết business logic trong hàm `build`.

---
Chúc bạn có trải nghiệm làm việc tuyệt vời với dự án Flutter Base!
