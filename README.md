# Flutter Base

Template Flutter với kiến trúc sẵn: Auth API, Riverpod, GoRouter, Firebase, lưu token local (SecureStorage + SharedPreferences).

---

## 📚 Tài liệu hướng dẫn chi tiết
Để hiểu rõ hơn về cách vận hành và các tiêu chuẩn của dự án, vui lòng tham khảo các tài liệu sau:
- 📘 **[Hướng dẫn cấu trúc dự án (Project Guide)](PROJECT_GUIDE.md)**: Chi tiết về kiến trúc layered, phân chia thư mục, quản lý môi trường (flavors) và Firebase.
- 🚀 **[Hướng dẫn sử dụng Riverpod (Riverpod Guide)](RIVERPOD_GUIDE.md)**: Cách sử dụng Provider, AsyncNotifier, xử lý Side Effects và tối ưu hóa UI với Riverpod.

---

## Công nghệ sử dụng

- **State management**: Riverpod
- **Định tuyến**: Go Router
- **Mạng**: Dio
- **Biến môi trường**: flutter_dotenv (runtime loaded)
- **Đa ngôn ngữ**: Slang (i18n)
- **Firebase**: Analytics, Crashlytics, Messaging, Remote Config
- **Lưu trữ local**:
  - `flutter_secure_storage` – dữ liệu nhạy cảm (accessToken, refreshToken)
  - `shared_preferences` – dữ liệu thông thường (theme, locale, onboarding, v.v.)

---

## Yêu cầu môi trường

- **Dart SDK** ^3.10.0 (theo `pubspec.yaml` → `environment.sdk`)
- **Flutter** tương thích với Dart 3.10+
- (Tùy chọn) **FVM** – nếu dùng `fvm flutter` thay vì `flutter`

---

## Cài đặt

```bash
flutter pub get
# hoặc
fvm flutter pub get

# Đối với iOS, cần thêm:
cd ios && pod install
```

---

## Cấu hình

### 1. Biến môi trường (Environment Variables)

Dự án dùng `flutter_dotenv` để quản lý biến môi trường nạp lúc runtime. Dự án được chia làm **2 flavor**: `development` và `production`. Mỗi flavor dùng một file env riêng biệt.

| Flavor      | Nơi định nghĩa class      | File chứa biến thực tế |
|-------------|---------------------------|------------------------|
| development | `lib/core/config/env.dart`| `.env.dev`             |
| production  | `lib/core/config/env.dart`| `.env.prod`            |

**Quy trình cấu hình:**

**Bước 1**: Copy file mẫu (nếu có) hoặc tạo file mới và điền giá trị thực tế của bạn. Lưu ý KHÔNG commit các file này lên Git (chúng đã được thêm vào `.gitignore`).

```bash
# Tạo file env cho development
cp .env.dev.example .env.dev 

# Tạo file env cho production
cp .env.prod.example .env.prod
```

**Bước 2**: Điền các giá trị cần thiết vào bên trong file `.env.dev` và `.env.prod`. Đây là cấu trúc cơ bản bạn cần có:

```env
# URL của API server
API_BASE_URL=https://api.development.com
# API Key chung của ứng dụng (nếu cần)
API_KEY=your_secret_api_key

# Cấu hình Firebase chung
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-bucket.appspot.com
FIREBASE_MESSAGING_SENDER_ID=1234567890

# Cấu hình Firebase cho Android
FIREBASE_ANDROID_API_KEY=AIzaSy...
FIREBASE_ANDROID_APP_ID=1:1234567890:android:abcde

# Cấu hình Firebase cho iOS
FIREBASE_IOS_API_KEY=AIzaSy...
FIREBASE_IOS_APP_ID=1:1234567890:ios:abcde
FIREBASE_IOS_BUNDLE_ID=com.example.app.dev
```

> **Giải thích cách dùng trong code:**
> Hàm `main` (trong `main.dart`) sẽ tự động check `Flavor` đang chạy và nạp đúng file `.env.dev` hoặc `.env.prod` lên bộ nhớ.
> Bất cứ lúc nào cần biến môi trường, bạn chỉ cần gọi `Env.apiBaseUrl` (thuộc `lib/core/config/env.dart`).
> Không còn cần chạy lệnh `build_runner` khi bạn cập nhật file `.env` nữa, chỉ cần Hot Restart là xong!

### 2. Code generation

Khi cập nhật file i18n (`lib/l10n/*.i18n.json`), hoặc thêm Provider mới của Riverpod (`@riverpod`), bạn cần chạy lệnh:

```bash
# Sinh code cho i18n (Slang)
dart run slang

# Sinh code cho Riverpod
dart run build_runner build --delete-conflicting-outputs

# Tự động sinh code khi file thay đổi
dart run build_runner watch --delete-conflicting-outputs
```

### 3. Firebase Configuration

Để các Native SDK (FCM, Crashlytics...) hoạt động, bạn cần tải các tệp cấu hình từ Firebase Console và đặt vào đúng các thư mục sau cho từng Flavor:

#### 🤖 Android
Vui lòng copy tệp `google-services.json` vào:
- **Development**: `android/app/src/development/google-services.json`
- **Production**: `android/app/src/production/google-services.json`

#### 🍎 iOS
Vui lòng copy tệp `.plist` vào thư mục `ios/Runner/` với đúng tên file:
- **Development**: `ios/Runner/GoogleService-Info-Development.plist`
- **Production**: `ios/Runner/GoogleService-Info-Production.plist`

*(Lưu ý: Dự án đã được thiết lập sẵn **Build Phase Script** để tự động hoán đổi tệp cấu hình iOS dựa trên môi trường).*

#### 🎯 Dart
Đảm bảo thông số Firebase trong file `.env.dev` và `.env.prod` được điền đầy đủ và khớp với các tệp native trên.

---

## Cách chạy (Run)

### Chạy với flavor development

```bash
# Android
flutter run --flavor development

# iOS (chọn scheme development trong Xcode hoặc)
flutter run --flavor development
```

### Chạy với flavor production

```bash
flutter run --flavor production
```

### Chỉ định thiết bị

```bash
flutter run --flavor development -d <device_id>
```

### Build APK/IPA

```bash
# Android APK (development)
flutter build apk --flavor development

# Android APK (production)
flutter build apk --flavor production

# iOS (cần chọn scheme tương ứng trong Xcode)
flutter build ios --flavor production
```

**Credentials mẫu cho login**: `username: hunghq`, `password: 12345` (cần mock API trả 200 + token).

---

## Cách test

Dự án hiện tại đang tập trung toàn bộ vào **E2E Tests (Integration Tests với Patrol)** để đảm bảo ứng dụng thực tế hoạt động trơn tru trên thiết bị/máy ảo thay vì test Unit/Widget nhỏ lẻ.

### E2E Tests (Integration Tests với Patrol)

Dự án sử dụng Patrol để chạy End-to-End test. Patrol sẽ build app, mở máy ảo lên và tự động thao tác trên giao diện giống hệt người dùng thật.

**1. Cài đặt Patrol CLI (chỉ cần làm 1 lần):**
```bash
dart pub global activate patrol_cli
export PATH="$PATH:$HOME/.pub-cache/bin"   # thêm vào ~/.bashrc hoặc ~/.zshrc
```

**2. Chạy E2E Tests:**
Bật máy ảo (Emulator/Simulator) hoặc cắm thiết bị thật vào trước khi chạy.

```bash
# Chạy toàn bộ các test trong thư mục patrol_test
PATROL_FLUTTER_COMMAND="fvm flutter" patrol test

# Chạy cụ thể 1 luồng test (ví dụ: luồng đăng nhập)
PATROL_FLUTTER_COMMAND="fvm flutter" patrol test --target patrol_test/features/auth/login_flow_test.dart

# Chạy test (Mặc định dùng user 'hunghq' / pass '12345' ghi cứng trong code)
PATROL_FLUTTER_COMMAND="fvm flutter" patrol test --target patrol_test/features/auth/login_flow_test.dart
```

**3. Chế độ Develop (Hot Restart cho Test):**
Giúp viết test nhanh hơn. Patrol sẽ không build lại app từ đầu mà chỉ hot restart ứng dụng mỗi khi bạn lưu file test:

```bash
PATROL_FLUTTER_COMMAND="fvm flutter" patrol develop --target patrol_test/features/auth/login_flow_test.dart
```

**Lưu ý iOS:** Cần setup thêm target `RunnerUITests` theo [Patrol iOS setup](https://patrol.leancode.co/documentation). Khuyên dùng Android Emulator trong quá trình phát triển để test nhanh gọn hơn.

---

## Phân chia lưu trữ local

| SecureStorage (flutter_secure_storage) | PreferencesStorage (shared_preferences) |
|--------------------------------------|-----------------------------------------|
| accessToken, refreshToken            | theme (dark/light), locale              |
| API keys, dữ liệu nhạy cảm           | onboarding completed, user preferences  |
| Dữ liệu cần mã hóa                    | feature flags cache, last sync time      |

---

## Cấu trúc dự án (tóm tắt)

```
lib/
├── app.dart                 # Root App, router
├── main.dart                # Khởi tạo Firebase, load tokens, runApp
├── core/
│   ├── analytics/           # Constants Firebase Analytics
│   ├── config/              # Env, Firebase options
│   ├── network/             # Dio, interceptors (AuthInterceptor)
│   └── storage/             # SecureStorage, PreferencesStorage
├── features/
│   ├── auth/                # Login, AuthRepository, AuthSessionStore
│   └── home/                # HomeScreen
├── l10n/                    # i18n (Slang)
├── routing/                 # GoRouter
└── shared/                  # Common widgets, models, providers (cấu trúc sẵn)
```

---

## Tài liệu tham khảo

- [Flutter](https://docs.flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [GoRouter](https://pub.dev/packages/go_router)
- [Slang i18n](https://github.com/slang-i18n/slang)
- [Patrol E2E](https://patrol.leancode.co/)
