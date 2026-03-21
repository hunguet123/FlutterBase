# Hướng dẫn Tầng Dữ liệu (Data Layer Guide)

Tài liệu này giải thích cách tổ chức và vận hành của tầng dữ liệu trong dự án Flutter Base.

---

## 1. Cấu trúc thư mục

Mỗi feature tuân theo Clean Architecture với 3 tầng rõ ràng:

```
lib/features/auth/
├── domain/                    # Thuần Dart: model + contract + use case (thư mục phẳng)
│   ├── auth_tokens.dart
│   ├── auth_repository.dart
│   ├── login_use_case.dart
│   └── logout_use_case.dart
├── data/                      # Triển khai feature: API + lưu trữ (không @Riverpod)
│   ├── auth_session_store.dart
│   └── auth_repository_impl.dart
├── riverpod/                  # Toàn bộ @Riverpod đăng ký cho feature (DI)
│   ├── auth_session_store_provider.dart
│   ├── auth_repository_provider.dart
│   ├── login_use_case_provider.dart
│   └── logout_use_case_provider.dart
└── ui/login/                  # Màn hình + notifier + state của màn login
    ├── login_screen.dart
    ├── login_notifier.dart
    └── login_state.dart
```

**Quy tắc phụ thuộc:**
- `domain/` không import Flutter/Riverpod/Dio (trừ khi contract nằm ở `core/`).
- `data/` được phép import `domain/` và thư viện hạ tầng (Dio, …).
- `ui/` import `domain/`, `riverpod/`, `app/`, `core/` theo nhu cầu màn hình.

---

## 2. Repository Pattern

Dự án tách biệt `interface` (domain contract) và `implementation` (data class) để dễ mock khi test.

```dart
// domain/auth_repository.dart
abstract interface class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> hasSession();
}

// data/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._sessionStore);
  // ...
}
```

---

## 3. Provider Wiring

Đăng ký Riverpod cho feature auth nằm trong `features/auth/riverpod/`. Dự án tuân thủ Riverpod Generator — khai báo `dependencies` rõ ràng.

```dart
// lib/features/auth/riverpod/auth_repository_provider.dart
@Riverpod(dependencies: [apiClient, authSessionStore])
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(apiClientProvider);
  final sessionStore = ref.watch(authSessionStoreProvider);
  return AuthRepositoryImpl(dio, sessionStore);
}
```

**Gợi ý:** class thuần (store, repository impl) nằm trong `data/`; file `@Riverpod` tương ứng nằm trong `riverpod/`.

---

## 4. Quản lý lưu trữ (Stores)

| Loại lưu trữ | Công nghệ | Provider | Mục đích |
| :--- | :--- | :--- | :--- |
| **Secure Store** | `flutter_secure_storage` | `secureStorageProvider` | Lưu Token, API Key (dữ liệu nhạy cảm). |
| **Prefs Store** | `shared_preferences` | `preferencesStorageProvider` | Lưu theme, ngôn ngữ, cài đặt UI. |

**Cấu trúc `core/storage/`:**
- Contract: `secure_storage_contract.dart`, `preferences_storage_contract.dart`.
- Implementation: `secure_storage_impl.dart`, `preferences_storage_impl.dart` (cùng cấp, không tách `data/`).
- Đăng ký Riverpod: `riverpod/` (import trực tiếp, không dùng file barrel `export`).

**Cấu trúc `core/messaging/`:** model (`fcm_message`, `fcm_token`), `fcm_service.dart` (logic), `fcm_background_handler.dart`, `riverpod/` — không dùng thư mục `data/`.

**Luồng token:**
1. `secureStorageProvider` khởi tạo native storage.
2. `authSessionStoreProvider` nhận `SecureStorage` và quản lý logic token (read/write/clear).
3. `AuthRepositoryImpl` nhận `AuthSessionStore` để ghi token sau khi login thành công.
4. `AuthInterceptor` nhận `AuthTokenProvider` (interface) để đọc token đồng bộ — không phụ thuộc vào `AuthSessionStore` trực tiếp.

---

## 5. Dependency Inversion: core/network ↔ features/auth

`core/network` không được phép import `features/`. Để `AuthInterceptor` đọc được token, dự án dùng pattern **slot provider**:

```dart
// core/network/auth_token_provider.dart
// Slot — phải được override tại composition root (main.dart)
final authTokenProviderRef = Provider<AuthTokenProvider>(
  (ref) => throw UnimplementedError('Must be overridden'),
);

// main.dart — override slot với implementation thực tế
final container = ProviderContainer(
  overrides: [
    authTokenProviderRef.overrideWith(
      (ref) => ref.watch(authSessionStoreProvider),
    ),
  ],
);
```

`AuthSessionStore` implement `AuthTokenProvider` (domain interface), nên có thể được inject vào `core/network` mà không tạo ra circular dependency.

---

## 6. Quy tắc vàng

1. **Không gọi UI từ Data**: Tuyệt đối không import widget vào tầng `data/` hoặc `domain/`.
2. **Throw domain exceptions**: Lỗi từ API nên được ném dưới dạng `AppException` để tầng presentation xử lý.
3. **Chạy build_runner**: Sau khi sửa file có `@Riverpod`, chạy `fvm dart run build_runner build --delete-conflicting-outputs`.
4. **Khai báo dependencies**: Khi Provider A dùng Provider B, phải khai báo B trong `dependencies: [...]`.

---
*Tầng Data là nền móng của ứng dụng — giữ nó sạch và quản lý dependency qua Riverpod.*
