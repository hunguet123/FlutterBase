# Hướng dẫn sử dụng Riverpod trong Project

Dự án này sử dụng `flutter_riverpod` để quản lý trạng thái (state management) và tiêm phụ thuộc (dependency injection). Dưới đây là các kiến thức cơ bản để bạn làm quen nhanh nhất.

## 1. Các loại Provider thông dụng trong dự án

### 🔹 Provider (Đơn giản nhất)
Dùng để cung cấp các đối tượng không đổi hoặc các service (singleton).
- **Ví dụ:** `apiClientProvider`, `fcmServiceProvider`.
```dart
final apiClientProvider = Provider<Dio>((ref) {
  return createApiClient();
});
```
- **Cách dùng:** `ref.read(apiClientProvider)` để lấy instance của Dio.

### 🔹 AsyncNotifierProvider (Quản lý trạng thái thông minh)
Đây là loại Provider "vạn năng" nhất để xử lý logic có trạng thái và gọi API. 

Với cách dùng `@riverpod` (Code generation), bạn không cần khai báo kiểu dữ liệu phức tạp. Hãy xem ví dụ luồng Đăng nhập (Auth):

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<bool> build() async {
    // 1. Khởi tạo: Check xem user đã đăng nhập chưa từ bộ nhớ local
    return ref.read(authRepositoryProvider).hasSession();
  }

  Future<void> login(String user, String pass) async {
    // 2. Chuyển state sang Loading (UI sẽ tự động quay tròn)
    state = const AsyncValue.loading();

    // 3. Thực thi an toàn với .guard()
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).login(user, pass);
      return true; // Thành công -> State sẽ là AsyncData(true)
    });

    // Nếu có lỗi, .guard() tự bắt và chuyển state sang AsyncError(loi)
  }
}
```

**Tại sao nó mạnh mẽ?**
-   **Tự động dọn dẹp:** Nó là `autoDispose` mặc định (tự reset state khi thoát màn hình).
-   **Quản lý 3 trạng thái:** Bạn không cần tạo thêm các biến `bool isLoading` hay `String? errorMessage`. Bản thân `state` đã chứa đủ: `.isLoading`, `.hasError`, `.value`.

### 🔹 FutureProvider
Thực chất `FutureProvider` là một dạng đơn giản của `AsyncNotifierProvider` (chỉ có `build` mà không có các hàm xử lý sự kiện như `login`, `logout`).

```dart
@riverpod
Future<String> fetchUserConfig(FetchUserConfigRef ref) async {
  return "Dữ liệu được lấy từ server";
}
```

---

## 2. Cách sử dụng trong Widget

### Với Stateless Widget -> (Dùng `ConsumerWidget`)
Thay vì `extends StatelessWidget`, hãy dùng `extends ConsumerWidget`. Bạn sẽ nhận thêm tham số `WidgetRef ref`.

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Theo dõi trạng thái (UI sẽ rebuild khi state thay đổi)
    final authState = ref.watch(authNotifierProvider);

    // 2. Xử lý UI dựa trên AsyncValue
    return authState.when(
      data: (isLoggedIn) => Text(isLoggedIn ? 'Đã đăng nhập' : 'Chưa đăng nhập'),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Lỗi: $err'),
    );
  }
}
```

### Với Stateful Widget -> (Dùng `ConsumerStatefulWidget`)
Dùng khi bạn cần `initState` hoặc `dispose`. Bạn có thể truy cập `ref` ở bất kỳ đâu trong State.

```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    // Đọc provider một lần trong initState
    ref.read(fcmServiceProvider).init();
  }
  ...
}
```

---

## 3. Quy tắc vàng (Tips)

1.  **`ref.watch`**: Luôn dùng trong hàm `build` để UI tự động cập nhật khi dữ liệu thay đổi.
2.  **`ref.read`**: Dùng trong các hàm xử lý sự kiện (onPressed) hoặc `initState`. Tuyệt đối **KHÔNG** dùng `read` trong `build`.
3.  **Hạn chế logic trong Widget**: Mọi logic xử lý dữ liệu, gọi API nên nằm trong `Notifier`. Widget chỉ nên hiển thị dữ liệu và gửi sự kiện đến Notifier.
4.  **AsyncValue.guard**: Luôn dùng bọc luồng gọi API trong Notifier để tự động bắt lỗi và chuyển trạng thái về `error` mà không làm crash app.

## 4. Kiểm tra mã nguồn tham khảo
- Auth logic: `lib/features/auth/providers/auth_provider.dart`
- API client: `lib/core/network/network_providers.dart`
- Cách dùng ở UI: `lib/features/auth/presentation/screens/login_screen.dart`

---

## 5. Xử lý Side Effects (Tương đương BlocListener)

Dùng `ref.listen` trong hàm `build` để thực hiện các hành động không liên quan đến UI (như hiện Snackbar, Dialog, hoặc điều hướng) khi state thay đổi. Nó sẽ không gây ra rebuild widget.

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Lắng nghe thay đổi state
  ref.listen<AsyncValue<bool>>(
    authNotifierProvider,
    (previous, next) {
      if (next.hasError) {
        // Hiện Snackbar khi có lỗi (Side effect)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi')),
        );
      }
    },
  );

  return Scaffold(...);
}
```

## 6. Rebuild phần nhỏ Widget (Tương đương BlocBuilder)

Nếu bạn có một widget lớn nhưng chỉ muốn một phần nhỏ của nó rebuild khi dữ liệu thay đổi (để tối ưu hiệu năng), hãy dùng `Consumer`. Điều này tránh việc gọi lại toàn bộ hàm `build` của widget cha.

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      const TitleWidget(), // Không rebuild khi dataProvider thay đổi
      Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(dataProvider); // Chỉ bao bọc phần cần lắng nghe
          return Text(data);
        },
      ),
    ],
  );
}
```
