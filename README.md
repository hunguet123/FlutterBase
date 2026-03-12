# Flutter Base

Template Flutter với kiến trúc sẵn: Auth API, Riverpod, GoRouter, Firebase, lưu token local (SecureStorage + SharedPreferences).

---

## Công nghệ sử dụng

- **State management**: Riverpod
- **Định tuyến**: Go Router
- **Mạng**: Dio
- **Biến môi trường**: Envied (type-safe)
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
```

---

## Cấu hình

### 1. Biến môi trường

Dự án dùng **2 flavor**: `development` và `production`. Mỗi flavor dùng file env riêng:

| Flavor      | File env   |
|------------|------------|
| development | `.env.dev` |
| production | `.env.prod` |

**Bước 1**: Copy file mẫu và điền giá trị thực:

```bash
# Tạo .env.dev (hoặc copy từ .env.example nếu có)
cp .env.dev .env.dev.local

# Tạo .env.prod
cp .env.prod .env.prod.local
```

**Bước 2**: Các biến cần thiết trong `.env.dev` / `.env.prod`:

- `API_BASE_URL` – Base URL API
- `API_KEY` – API key (nếu dùng)
- `FIREBASE_PROJECT_ID`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_MESSAGING_SENDER_ID`
- Android: `FIREBASE_ANDROID_API_KEY`, `FIREBASE_ANDROID_APP_ID`
- iOS: `FIREBASE_IOS_API_KEY`, `FIREBASE_IOS_APP_ID`, `FIREBASE_IOS_BUNDLE_ID`

**Lưu ý**: Nếu dùng `.env.dev` / `.env.prod` thay vì `.env.dev.local`, hãy thêm chúng vào `.gitignore` nếu chứa thông tin nhạy cảm.

### 2. Code generation

Chạy build_runner để sinh code cho Envied và Riverpod:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Sinh i18n từ Slang:

```bash
dart run slang
```

### 3. Firebase

**Tạo file cấu hình cho từng flavor:**

Dự án dùng **2 Firebase project** (dev và prod). Chạy lệnh riêng cho từng flavor:

```bash
# Development (chọn Firebase project dev khi được hỏi)
flutterfire configure \
  --android-out=android/app/src/development/google-services.json \
  --ios-out=ios/Runner/GoogleService-Info-Development.plist

# Production (chọn Firebase project prod khi được hỏi)
flutterfire configure \
  --android-out=android/app/src/production/google-services.json \
  --ios-out=ios/Runner/GoogleService-Info-Production.plist
```

**Lưu ý:** Dự án dùng `FirebaseOptionsProvider` (từ `.env`) cho Dart, không dùng `firebase_options.dart`. Các file `google-services.json` và `GoogleService-Info.plist` vẫn cần cho native Firebase SDK.

**Thay thế nếu flutterfire lỗi:** Tải file từ [Firebase Console](https://console.firebase.google.com/) → Project Settings → Your apps → Download config, rồi copy thủ công vào đúng đường dẫn trên.

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

**Credentials mẫu cho login**: `username: Hunghq`, `password: 123456` (cần mock API trả 200 + token).

---

## Cách test

### Unit & Widget tests

```bash
flutter test
# hoặc
fvm flutter test
```

Các nhóm test:

- `test/features/auth/auth_repository_test.dart` – AuthRepository (login, logout, hasSession)
- `test/features/auth/auth_notifier_test.dart` – AuthNotifier (login, logout, restore session)
- `test/widget_test.dart` – LoginScreen (form, submit)

### E2E với Patrol

```bash
# Cài (1 lần)
fvm flutter pub global activate patrol_cli
export PATH="$PATH:$HOME/.pub-cache/bin"   # thêm vào ~/.zshrc nếu cần

# Chạy (mở Android emulator trước)
patrol test --flavor development --flutter-command "fvm flutter" --device android
```

**Lưu ý iOS:** Cần thêm target `RunnerUITests` theo [Patrol iOS setup](https://patrol.leancode.co/documentation). Trước khi setup xong, dùng Android emulator.

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
└── routing/                 # GoRouter
```

---

## Tài liệu tham khảo

- [Flutter](https://docs.flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [GoRouter](https://pub.dev/packages/go_router)
- [Slang i18n](https://github.com/slang-i18n/slang)
- [Patrol E2E](https://patrol.leancode.co/)
