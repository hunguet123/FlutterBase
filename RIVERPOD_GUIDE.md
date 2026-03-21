# Hướng dẫn Riverpod: Dự án Flutter Base (Chuẩn 2026)

Tài liệu này hướng dẫn chi tiết cách sử dụng Riverpod trong dự án, tuân thủ Riverpod 3.0.

---

## 1. Nguyên tắc cốt lõi: Sử dụng Code Generation

Dự án **bắt buộc** sử dụng `@riverpod` (Riverpod Generator).

**Tại sao?**
- **An toàn**: Cảnh báo lỗi ngay khi biên dịch thay vì lúc chạy.
- **Đơn giản**: Generator tự nhận diện kiểu trả về (Sync, Future, Stream).
- **Hiệu năng**: Mặc định là `autoDispose` (hủy khi không dùng) giúp tiết kiệm tài nguyên.

---

## 2. Các loại Provider thông dụng

### 2.1. Functional Provider (Service / giá trị đọc)

| Cú pháp (Generator) | Loại tương đương | Khi nào dùng? |
| :--- | :--- | :--- |
| `T name(Ref ref) => ...` | `Provider<T>` | Cung cấp Service (Dio, Storage, Analytics). |
| `Future<T> name(Ref ref) async => ...` | `FutureProvider<T>` | Gọi API lấy dữ liệu 1 lần. |

```dart
@Riverpod(keepAlive: true, dependencies: [])
FirebaseAnalytics analytics(Ref ref) => FirebaseAnalytics.instance;
```

### 2.2. Notifier Provider (Quản lý logic & trạng thái)

Dùng khi cần expose các action (login, logout) và state có thể thay đổi.

**Sync Notifier** — dùng khi state không cần async khi khởi tạo:
```dart
// lib/features/auth/ui/login/login_notifier.dart
@Riverpod(dependencies: [authRepository, appConfig, analytics])
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).login(username, password);
      state = state.copyWith(isLoading: false);
      ref.invalidate(authSessionNotifierProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
```

**Async Notifier** — dùng khi `build()` cần await (ví dụ: check session):
```dart
// lib/app/riverpod/auth_session_notifier.dart
@Riverpod(keepAlive: true, dependencies: [authRepository, analytics])
class AuthSessionNotifier extends _$AuthSessionNotifier {
  @override
  Future<AuthSessionState> build() async {
    final hasSession = await ref.watch(authRepositoryProvider).hasSession();
    return AuthSessionState(isLoggedIn: hasSession);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(AuthSessionState(isLoggedIn: false));
  }
}
```

---

## 3. `keepAlive` — khi nào dùng?

| Trường hợp | `keepAlive` |
| :--- | :--- |
| Firebase singletons (Analytics, RemoteConfig, FCM) | `true` |
| App-level state (AuthSessionNotifier, Router) | `true` |
| UI-scoped state (LoginNotifier, form state) | `false` (mặc định) |

---

## 4. Cách sử dụng tại UI

### 4.1. Truy cập `WidgetRef`

- **Stateless:** Dùng `ConsumerWidget` — hàm `build` có thêm `WidgetRef ref`.
- **Stateful:** Dùng `ConsumerStatefulWidget` và `ConsumerState` — `ref` truy cập được ở mọi nơi trong class.
- **Inline:** Dùng widget `Consumer` khi chỉ muốn rebuild một phần nhỏ của UI.

### 4.2. `watch`, `read`, `listen`

- `ref.watch(provider)` — dùng trong `build`, tự rebuild khi state thay đổi.
- `ref.read(provider.notifier)` — dùng trong callback (`onPressed`, `onTap`). **Không dùng trong `build`**.
- `ref.listen(provider, (prev, next) { })` — dùng cho side effects (SnackBar, Dialog, navigation) mà không rebuild UI.

### 4.3. Xử lý `AsyncValue`

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final authAsync = ref.watch(authSessionNotifierProvider);

  return authAsync.when(
    data: (_) => const HomeScreen(),
    loading: () => const CircularProgressIndicator(),
    error: (err, _) => Text('Lỗi: $err'),
  );
}
```

### 4.4. Tối ưu rebuild với `.select`

```dart
// Chỉ rebuild khi isLoading thay đổi, không rebuild khi username thay đổi
final isLoading = ref.watch(loginNotifierProvider.select((s) => s.isLoading));
```

---

## 5. Quy tắc quan trọng

### Luôn dùng `Ref` generic
Tránh cảnh báo deprecated — dùng `Ref` (không phải `ProviderRef`, `WidgetRef`...) cho tham số của provider.

### Khai báo `dependencies`
Khi Provider A dùng `ref.watch` Provider B, **phải** khai báo B trong `dependencies: [B]`. Build runner sẽ báo lỗi nếu thiếu.

### `Raw<T>` cho `ChangeNotifier`
Nếu provider trả về `ChangeNotifier`, dùng `Raw<T>` để generator không can thiệp vào vòng đời:

```dart
@Riverpod(keepAlive: true)
Raw<RouterRefreshNotifier> routerRefreshNotifier(Ref ref) { ... }
```

### Slot Provider (Dependency Inversion)
Khi một module trong `core/` cần dependency từ `features/`, dùng slot provider — khai báo placeholder trong `core/`, override tại `main.dart`:

```dart
// core/network/auth_token_provider.dart
final authTokenProviderRef = Provider<AuthTokenProvider>(
  (ref) => throw UnimplementedError('Must be overridden'),
);

// main.dart
ProviderContainer(overrides: [
  authTokenProviderRef.overrideWith((ref) => ref.watch(authSessionStoreProvider)),
])
```

---

## 6. Lệnh sinh Code (Build Runner)

```bash
# Sinh code 1 lần
fvm dart run build_runner build --delete-conflicting-outputs

# Tự động sinh khi sửa file (khuyên dùng khi dev)
fvm dart run build_runner watch --delete-conflicting-outputs
```

---
*Tài liệu này được soạn thảo để chuẩn hóa quy trình code trong dự án.*
