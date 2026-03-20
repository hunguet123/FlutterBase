# 🏗️ Hướng dẫn Tầng Dữ liệu (Data Layer Guide)

Tài liệu này giải thích cách tổ chức và vận hành của tầng dữ liệu trong dự án Flutter Base.

---

## 1. Cấu trúc thư mục
Mỗi tính năng (`feature`) sẽ có các thư mục `domain/` (contract/entity) và `data/` (implementation + wiring) để quản lý dữ liệu cục bộ:
```
lib/features/auth/
├── domain/
│   └── repositories/
│       └── auth_repository.dart   # Contract (interface) của AuthRepository
└── data/
    ├── auth_repository.dart        # Barrel export (không chứa trực tiếp implementation)
    ├── auth_repository_provider.dart # Provider (Riverpod wiring) trả về AuthRepository
    ├── repositories/
    │   └── auth_repository_impl.dart # Implementation cụ thể (Dio)
    └── auth_session_store.dart     # Quản lý Session (Token)
```

---

## 2. Repository Pattern (Mẫu thiết kế Kho dữ liệu)

Dự án sử dụng Repository để tách biệt logic gọi API/DB với logic nghiệp vụ (Business Logic).

### 🔹 Interface & Implementation
Chúng ta tách biệt thành `interface` (định nghĩa) và `class Implementation` (thực thi) để dễ dàng thay thế hoặc Mock khi viết Test.

```dart
// Định nghĩa (Interface)
abstract interface class AuthRepository {
  Future<void> login(String user, String pass);
}

// Thực thi (Implementation)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(...) { ... }
}
```

---

## 3. Tại sao Data Layer có Provider?

Để giữ cho code "neat & clean" (gọn gàng), chúng ta đặt **provider wiring** (khai báo `@Riverpod`) trong `data/` để composition/dependency injection diễn ra đúng tầng. Dự án tuân thủ Riverpod 3.0 (phải khai báo `dependencies` rõ ràng).

**Mục đích:**
1.  **Dependency Injection (DI)**: Tự động cung cấp `Dio`, `SecureStorage` hoặc các `Store` khác vào Repository.
2.  **Testability**: Dễ dàng override các Provider này bằng mock/fake trong môi trường test mà không cần can thiệp vào code main.
3.  **Instance Management**: Riverpod quản lý vòng đời (Lifecycle) của instance, đảm bảo dùng chung instance (Singleton) thông qua `keepAlive: true`.

```dart
// Ví dụ khai báo chuẩn tại lib/features/auth/data/auth_repository_provider.dart
@Riverpod(dependencies: [apiClient, authSessionStore])
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(apiClientProvider);
  final sessionStore = ref.watch(authSessionStoreProvider);
  return AuthRepositoryImpl(dio, sessionStore);
}
```

---

## 4. Quản lý lưu trữ (Stores)

Dự án sử dụng Dependency Injection cho toàn bộ hệ thống lưu trữ:

| Loại lưu trữ | Công nghệ | Provider | Mục đích |
| :--- | :--- | :--- | :--- |
| **Secure Store** | `flutter_secure_storage` | `secureStorageProvider` | Lưu Token, API Key (Dữ liệu nhạy cảm). |
| **Prefs Store** | `shared_preferences` | `preferencesStorageProvider` | Lưu Theme mode, Ngôn ngữ, cài đặt UI. |

**Note về cấu trúc:** Contract nằm ở `lib/core/storage/domain/`, còn implementation + provider nằm ở `lib/core/storage/data/`. Hai file barrel `lib/core/storage/secure_storage.dart` và `lib/core/storage/preferences_storage.dart` chỉ `export` để thống nhất import.

**Luồng hoạt động:**
1.  `secureStorageProvider` khởi tạo instance Native storage.
2.  `authSessionStoreProvider` nhận `SecureStorage` instance và quản lý logic Token.
3.  `AuthRepository` nhận `AuthSessionStore` để thực hiện ghi Token sau khi Login thành công.

*Lưu ý: Tuyệt đối không dùng Singleton pattern kiểu `AuthSessionStore.instance`. Hãy dùng Riverpod để inject dependency.*

---

## 5. Quy tắc vàng khi làm việc với Data Layer

1.  **Không gọi UI trực tiếp**: Tuyệt đối không import bất kỳ widget nào vào tầng Data.
2.  **Xử lý Exception**: Các lỗi API nên được ném (throw) dưới dạng `AppException` để tầng Logic xử lý và hiển thị thông báo.
3.  **Generator**: Sau khi sửa bất kỳ file nào có `@Riverpod`, hãy chạy lệnh `fvm flutter pub run build_runner build`.
4.  **Dependencies**: Khi thêm một Provider mới phụ thuộc vào các Provider khác, bạn PHẢI khai báo chúng trong danh sách `dependencies` của annotation `@Riverpod`.

---
*Tầng Data là nền móng của ứng dụng, hãy giữ nó luôn sạch sẽ và quản lý dependency thông qua Riverpod.*
