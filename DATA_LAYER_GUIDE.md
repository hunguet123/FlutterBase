# Hướng dẫn Tầng Dữ liệu (Data Layer Guide)

Tài liệu này giải thích cách tổ chức và vận hành của tầng dữ liệu trong dự án Flutter Base.

---

## 1. Cấu trúc thư mục

Mỗi feature tuân theo Clean Architecture với 3 tầng rõ ràng:

```
lib/features/auth/
├── domain/
│   ├── interfaces/
│   │   └── auth_token_provider.dart   # Contract cho network layer (DI boundary)
│   ├── models/
│   │   └── auth_tokens.dart           # Domain model (AccessToken, RefreshToken)
│   └── repositories/
│       └── auth_repository.dart       # Contract (interface) của AuthRepository
└── data/
    ├── auth_session_store.dart        # Token storage (class + provider cùng file)
    ├── auth_repository_provider.dart  # Riverpod wiring → trả về AuthRepository
    └── repositories/
        └── auth_repository_impl.dart  # Implementation cụ thể (Dio)
```

**Quy tắc phụ thuộc:**
- `domain/` không import bất kỳ thứ gì ngoài Dart core.
- `data/` được phép import `domain/` và thư viện hạ tầng (Dio, Firebase...).
- `presentation/` chỉ import `domain/` và `data/` của cùng feature, hoặc `app/providers/`.

---

## 2. Repository Pattern

Dự án tách biệt `interface` (domain contract) và `implementation` (data class) để dễ mock khi test.

```dart
// domain/repositories/auth_repository.dart
abstract interface class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> hasSession();
}

// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._sessionStore);
  // ...
}
```

---

## 3. Provider Wiring

Provider nằm trong `data/` để composition/dependency injection diễn ra đúng tầng. Dự án tuân thủ Riverpod 3.0 — phải khai báo `dependencies` rõ ràng.

```dart
// lib/features/auth/data/auth_repository_provider.dart
@Riverpod(dependencies: [apiClient, authSessionStore])
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(apiClientProvider);
  final sessionStore = ref.watch(authSessionStoreProvider);
  return AuthRepositoryImpl(dio, sessionStore);
}
```

**Khi nào tách provider ra file riêng?**
- Nếu class nhỏ và provider chỉ wrap class đó: đặt cùng file (ví dụ `auth_session_store.dart`).
- Nếu provider cần import nhiều dependency từ nhiều nơi: tách ra file riêng (ví dụ `auth_repository_provider.dart`).

---

## 4. Quản lý lưu trữ (Stores)

| Loại lưu trữ | Công nghệ | Provider | Mục đích |
| :--- | :--- | :--- | :--- |
| **Secure Store** | `flutter_secure_storage` | `secureStorageProvider` | Lưu Token, API Key (dữ liệu nhạy cảm). |
| **Prefs Store** | `shared_preferences` | `preferencesStorageProvider` | Lưu theme, ngôn ngữ, cài đặt UI. |

**Cấu trúc `core/storage/`:**
- Contract (interface) nằm ở `domain/`.
- Implementation + provider nằm ở `data/`.
- Hai file barrel `secure_storage.dart` và `preferences_storage.dart` ở root chỉ re-export để thống nhất import.

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
