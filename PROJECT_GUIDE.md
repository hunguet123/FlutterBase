# Project Overview (Dành cho Fresher)

Chào mừng bạn đến với dự án **Flutter Base**! Đây là tài liệu hướng dẫn giúp bạn làm quen với cấu trúc code, các thư viện sử dụng và luồng hoạt động chính của ứng dụng.

## 1. Công nghệ sử dụng (Tech Stack)

Dự án được xây dựng dựa trên các thư viện phổ biến và mạnh mẽ nhất trong hệ sinh thái Flutter:

*   **State Management:** [Riverpod](https://riverpod.dev/) (phiên bản 2.x với Code Generation). Đây là "bộ não" quản lý dữ liệu và trạng thái của ứng dụng.
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

Code được tổ chức theo cấu trúc phân lớp (Layered Architecture) trong thư mục `lib/`:

*   `core/`: Chứa các thành phần hạ tầng dùng chung cho toàn bộ app:
    *   `config/`: Cấu hình môi trường (.env), Firebase (native configs), Remote Config.
    *   `network/`: Cài đặt Dio, Interceptors (xử lý token, log API, bắt lỗi).
    *   `storage/`: Định nghĩa cách lưu trữ dữ liệu local.
    *   `messaging/`: Xử lý thông báo (FCM).
*   `features/`: Chứa mã nguồn theo từng tính năng (Domain-driven):
    *   `auth/`: Xử lý Đăng nhập, Đăng xuất, quản lý Session.
    *   `home/`: Giao diện chính sau khi đăng nhập.
    *   Mỗi feature thường chia nhỏ thành: `data` (gọi API/DB), `presentation` (UI/Screen), `providers` (Logic nghiệp vụ).
*   `shared/`: Chứa các Component UI dùng chung (Button, TextField, Dialog...).
*   `routing/`: Định nghĩa các route (đường dẫn) và logic điều hướng của app.
*   `l10n/`: Chứa các file ngôn ngữ (.i18n.json).

---

## 3. Các luồng xử lý quan trọng

### 3.1. Quản lý môi trường (Environment)
App sử dụng flavor để tách biệt môi trường **Development** và **Production**.
*   Các biến như `API_BASE_URL` được định nghĩa trong `.env.dev` hoặc `.env.prod`.
*   Truy cập an toàn thông qua class `Env` tại `lib/core/config/env.dart`.

### 3.2. Luồng Authentication (Đăng nhập)
1.  Khi app khởi động (`main.dart`), app sẽ load token từ bộ nhớ an toàn (`AuthSessionStore`).
2.  `AuthNotifier` (Riverpod) sẽ kiểm tra xem đã có session chưa.
3.  `App` widget (`app.dart`) lắng nghe trạng thái của `AuthNotifier`:
    *   Nếu chưa đăng nhập: Hiển thị trang `LoginScreen`.
    *   Nếu đã đăng nhập: Khởi tạo `GoRouter` và đưa người dùng vào `HomeScreen`.
4.  Khi gọi API, `AuthInterceptor` sẽ tự động thêm `Authorization: Bearer <token>` vào header.

### 3.3. Xử lý API & Lỗi
*   Tất cả các lỗi API đều được `ErrorInterceptor` ghi lại vào **Firebase Crashlytics** để giúp team dev dễ dàng fix bug.
*   Log API được in ra console một cách đẹp mắt trong quá trình debug nhờ `ApiLogInterceptor`.

---

## 4. Lưu ý dành cho bạn

1.  **Code Generation:** Dự án sử dụng `build_runner`. Sau khi thêm Provider mới hoặc file ngôn ngữ, bạn cần chạy lệnh:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
2.  **Đa ngôn ngữ:** Khi thêm chuỗi ký tự mới, hãy thêm vào file trong `lib/l10n/` và sử dụng thông qua object `t` (ví dụ: `t.auth.login_button`).
3.  **UI Components:** Trước khi tạo một Widget mới, hãy kiểm tra thư mục `lib/shared/widgets/` xem đã có component tương tự chưa để tái sử dụng.
4.  **Tuyệt đối tuân thủ:**
    *   Không viết cứng (hardcode) các chuỗi ký tự hoặc địa chỉ API.
    *   Sử dụng Riverpod để quản lý logic, tránh viết quá nhiều code nghiệp vụ trong hàm `build` của Widget.

---
Chúc bạn có trải nghiệm làm việc tuyệt vời với dự án Flutter Base!
