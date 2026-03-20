# 🏗️ Hướng dẫn Tầng Dữ liệu (Data Layer Guide)

Tài liệu này giải thích cách tổ chức và vận hành của tầng dữ liệu trong dự án Flutter Base.

---

## 1. Cấu trúc thư mục
Mỗi tính năng (`feature`) sẽ có một thư mục `data/` riêng biệt để quản lý dữ liệu cục bộ:
```
lib/features/auth/data/
├── auth_repository.dart        # Chứa Interface, Implementation và Provider
├── auth_session_store.dart     # Quản lý Session (Token)
└── auth_repository.g.dart      # File tự động sinh (Generator)
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

Để giữ cho code "neat & clean" (gọn gàng), chúng ta đặt Provider khai báo Repository ngay trong cùng file dữ liệu.

**Mục đích:**
1.  **Dependency Injection (DI)**: Tự động cung cấp `Dio` hoặc các `Store` khác vào Repository.
2.  **Singleton**: Đảm bảo toàn bộ App chỉ dùng duy nhất 1 instance của Repository đó.

```dart
@Riverpod(dependencies: [apiClient, authSessionStore])
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(authSessionStoreProvider),
  );
}
```

---

## 4. Quản lý lưu trữ (Stores)

Dự án chia làm 2 loại lưu trữ dữ liệu local chính:

| Loại lưu trữ | Công nghệ sử dụng | Khi nào dùng? |
| :--- | :--- | :--- |
| **Secure Store** | `flutter_secure_storage` | Lưu Token, API Key (Dữ liệu nhạy cảm). |
| **Prefs Store** | `shared_preferences` | Lưu Theme mode, Ngôn ngữ, ghi nhớ Login. |

*Lưu ý: Luôn sử dụng class `AuthSessionStore` để quản lý Token thay vì gọi trực tiếp Storage ở khắp nơi.*

---

## 5. Quy tắc vàng khi làm việc với Data Layer

1.  **Không gọi UI trực tiếp**: Tuyệt đối không import bất kỳ widget nào vào tầng Data.
2.  **Xử lý Exception**: Các lỗi API nên được ném (throw) dưới dạng `AppException` để tầng Logic xử lý và hiển thị thông báo.
3.  **Generator**: Sau khi sửa bất kỳ file nào có `@riverpod`, hãy chạy lệnh `fvm flutter pub run build_runner build`.

---
*Tầng Data là nền móng của ứng dụng, hãy giữ nó luôn sạch sẽ và dễ hiểu.*
