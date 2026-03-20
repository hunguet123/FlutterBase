# 🔥 Hướng dẫn Riverpod: Từ Cơ bản đến Nâng cao

Chào mừng bạn đến với hướng dẫn sử dụng Riverpod cho dự án này. Tài liệu này được tổng hợp dựa trên tinh thần của tài liệu chính thức [Riverpod.dev](https://riverpod.dev/docs/concepts/about_providers) và áp dụng thực tế vào dự án của chúng ta.

---

## 1. Provider là gì?
Về cơ bản, một **Provider** là một "hàm được lưu nhớ" (memoized function). Nó bao bọc một logic xử lý, lưu trữ kết quả và cho phép nhiều nơi trong ứng dụng truy cập vào cùng một dữ liệu đó mà không cần khởi tạo lại.

**Tại sao dùng Provider?**
-   **Thay thế Singleton/Service Locator:** Không cần dùng `GetIt` hay biến toàn cục khó kiểm soát.
-   **Dễ dàng kiểm thử:** Có thể ghi đè (override) dữ liệu giả cho mục đích testing.
-   **Tối ưu hiệu năng:** Chỉ rebuild những phần thực sự cần thiết khi dữ liệu thay đổi.

---

## 2. Các loại Provider chính (Cách truyền thống)

| Loại Provider | Cách dùng |
| :--- | :--- |
| **Provider** | Dùng cho các giá trị không đổi hoặc các Service Class (Dio, Storage). |
| **FutureProvider** | Dùng cho dữ liệu bất đồng bộ trả về 1 lần (gọi API lấy cấu hình). |
| **StreamProvider** | Dùng cho dữ liệu luồng (Firebase Firestore, WebSockets). |
| **NotifierProvider** | Quản lý trạng thái có thể thay đổi (Mutable state). |
| **AsyncNotifierProvider** | Quản lý trạng thái bất đồng bộ có thể thay đổi (Auth, List dữ liệu). |

---

## 3. Riverpod Generator (Phương pháp được khuyến nghị)
Dự án của chúng ta ưu tiên sử dụng **Code Generation** (`@riverpod`) vì nó giúp viết code ngắn hơn, an toàn hơn và tự động xử lý kiểu dữ liệu.

### 🔹 Cách tạo Provider đơn giản
```dart
@riverpod
String label(LabelRef ref) => 'Hello World';
```

### 🔹 Cách tạo Async Notifier (Quản lý logic phức tạp)
Dùng cho màn hình cần gọi API và có trạng thái Loading/Error.
```dart
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    // Khởi tạo lấy dữ liệu lần đầu
    return ref.read(apiProvider).getProducts();
  }

  Future<void> addProduct(Product p) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ...);
  }
}
```

### 🔹 Lưu ý cực kỳ quan trọng về Code Generation

Khi bạn viết code với `@riverpod`, IDE sẽ báo **lỗi gạch đỏ** vì class cha (ví dụ: `_$ProductList`) chưa tồn tại. Đừng lo lắng! Đây là quy trình bình thường:

1.  **Gõ code**: Viết class và logic của bạn.
2.  **Khởi chạy lệnh Gen**: Chạy lệnh `dart run build_runner build` (hoặc `watch`).
3.  **Kết quả**: File `.g.dart` sẽ được tạo ra, lỗi gạch đỏ biến mất và biến `{tênClass}Provider` sẽ xuất hiện để bạn sử dụng.

> **💡 Mẹo nhỏ:** Hãy luôn chạy `dart run build_runner watch` trong suốt quá trình code để tiết kiệm thời gian chờ đợi.

## 4. Cách sử dụng (Consuming)

### 🔹 `ref.watch(provider)`
-   **Dùng trong:** Hàm `build`.
-   **Tác dụng:** Lắng nghe và **rebuild** widget khi dữ liệu thay đổi. Đa số trường hợp bạn sẽ dùng cái này.

### 🔹 `ref.read(provider)`
-   **Dùng trong:** Các hàm xử lý sự kiện (onPressed) hoặc `initState`.
-   **Tác dụng:** Lấy giá trị hiện tại của provider mà **không lắng nghe**. Tuyệt đối không dùng trong `build`.

### 🔹 `ref.listen(provider, listener)`
-   **Dùng trong:** Hàm `build`.
-   **Tác dụng:** Xử lý **Side Effects** (hiện Snackbar, điều hướng) khi state thay đổi. Không gây rebuild.

### 🔹 Widget `Consumer`
Dùng để bao bọc một đoạn code nhỏ cần lắng nghe provider thay vì rebuild cả màn hình lớn (Giống `BlocBuilder`).

---

## 5. Các tính năng nâng cao quan trọng

### 🟢 `autoDispose` (Tặc động dọn dẹp)
Trong dự án dùng Generator, mọi provider mặc định là `autoDispose`. Khi không còn ai sử dụng (màn hình đóng), state sẽ bị hủy để tiết kiệm RAM. Nếu muốn giữ state lại (dạng Singleton), dùng `@Riverpod(keepAlive: true)`.

### 🟢 `family` (Truyền tham số)
Dùng khi bạn muốn lấy dữ liệu dựa trên một ID nào đó.
```dart
@riverpod
Future<User> fetchUser(FetchUserRef ref, String userId) async {
  return ref.read(apiClient).getUser(userId);
}
// Cách dùng ở UI: ref.watch(fetchUserProvider('123'));
```

### 🟢 `select` (Tối ưu hóa rebuild)
Chỉ rebuild widget khi một trường cụ thể trong Object thay đổi.
```dart
final name = ref.watch(userProvider.select((u) => u.name));
```

---

## 6. Testing & Debugging

### 🔹 ProviderObserver (Theo dõi trạng thái toàn App)
Dùng để log lại mọi thay đổi của provider trong console, cực kỳ hữu ích khi debug.
```dart
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    print('Provider ${provider.name ?? provider.runtimeType} đã đổi sang $newValue');
  }
}
// Cách dùng trong main.dart:
// ProviderScope(observers: [MyObserver()], child: MyApp())
```

### 🔹 Provider Overrides (Ghi đè - Testing)
Dự án có thể dễ dàng mock dữ liệu test bằng cách ghi đè provider trong `ProviderScope`:
```dart
ProviderScope(
  overrides: [
    apiClientProvider.overrideWithValue(MockApiClient()),
  ],
  child: MyApp(),
)
```

---

## 7. Các kỹ thuật tối ưu hóa & Xử lý đặc biệt

### 🔹 Eager Initialization (Khởi tạo sớm)
Dùng khi bạn muốn một provider (như Database, SharedPrefs) khởi tạo ngay khi app vừa bật mà không đợi widget nào watch.
-   **Cách làm:** Trong một provider "init", hãy `ref.watch` các provider cần khởi tạo sớm. Sau đó bạn `watch` provider "init" đó ngay tại `main.dart` hoặc root widget.

### 🔹 Pull-to-refresh & Invalidating State
Lệnh `ref.invalidate(provider)` sẽ xóa bỏ cache và buộc provider đó phải chạy lại hàm `build`.
```dart
// Trong UI (Pull to refresh)
onRefresh: () async {
  ref.invalidate(productListProvider); // Reset và gọi lại build
  await ref.read(productListProvider.future); // Đợi lấy xong dữ liệu mới
}
```

### 🔹 Debouncing & Cancelling (Xử lý tìm kiếm/nhập liệu nhanh)
Dùng khi bạn không muốn gọi API liên tục mỗi khi user gõ 1 phím.
```dart
@riverpod
Future<List<User>> searchUsers(SearchUsersRef ref, String query) async {
  // 1. Chờ 500ms
  await Future.delayed(const Duration(milliseconds: 500));
  
  // 2. Kiểm tra xem user có gõ thêm gì không (nếu có, request này sẽ được dispose)
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  return ref.read(apiClient).getUsers(query, cancelToken: cancelToken);
}
```

### 🔹 Truy cập Provider ngoài Widget Tree (`ProviderContainer`)
Đôi khi bạn cần đọc dữ liệu bên ngoài màn hình (ví dụ: trong một Service độc lập hoặc trong `main.dart`).
-   Hãy dùng `ProviderContainer` (nhưng hãy cẩn thận, chỉ dùng khi thực sự cần thiết).

---
*Ghi chú: Luôn ưu tiên sử dụng code generation (`@riverpod`) thay vì khai báo tay (`final ...Provider`) để nhận được sự hỗ trợ tốt nhất từ IDE và trình biên dịch.*
