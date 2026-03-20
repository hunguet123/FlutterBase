# 🔥 Hướng dẫn Riverpod: Dự án Flutter Base (Cập nhật chuẩn 2026)

Tài liệu này hướng dẫn chi tiết cách sử dụng Riverpod trong dự án, tuân thủ các quy tắc lint mới nhất và chuẩn bị cho Riverpod 3.0.

---

## 1. Nguyên tắc cốt lõi: Sử dụng Code Generation
Dự án **bắt buộc** sử dụng `@riverpod` (Riverpod Generator). 

**Tại sao?**
-   **An toàn**: Cảnh báo lỗi ngay khi biên dịch thay vì lúc chạy.
-   **Đơn giản**: Generator tự nhận diện kiểu trả về (Sync, Future, Stream).
-   **Hiệu năng**: Mặc định là `autoDispose` (hủy khi không dùng) giúp tiết kiệm tài nguyên.

---

## 2. Các loại Provider thông dụng

Trong Riverpod Generator, bạn chỉ cần quan tâm đến 2 cách khai báo chính: Dạng Hàm (Functional) và Dạng Lớp (Notifier).

### 🔹 2.1. Functional Provider (Giá trị đọc một lần/Service)
| Cú pháp (Generator) | Loại tương đương | Khi nào dùng? |
| :--- | :--- | :--- |
| `T name(Ref ref) => ...` | `Provider<T>` | Cung cấp Service (Dio, Storage). |
| `Future<T> name(Ref ref) async => ...` | `FutureProvider<T>` | Gọi API lấy dữ liệu 1 lần. |

**Ví dụ:**
```dart
@Riverpod(keepAlive: true)
FirebaseAnalytics analytics(Ref ref) => FirebaseAnalytics.instance;
```

### 🔹 2.2. Notifier Provider (Quản lý logic & trạng thái)
Dùng cho mọi logic liên quan đến API, có trạng thái Loading/Error tự động.

```dart
@Riverpod(keepAlive: true, dependencies: [authRepository])
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<bool> build() async {
    return ref.watch(authRepositoryProvider).hasSession();
  }

  Future<void> login(String user, String pass) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).login(user, pass);
      return true;
    });
  }
}
```

---

## 3. Tìm hiểu về `AsyncValue`

Khi bạn sử dụng các Provider bất đồng bộ ở trên (như `FutureProvider` hay `AsyncNotifier`), dữ liệu mà bạn nhận được sẽ được bao bọc trong lớp **`AsyncValue`**.

`AsyncValue` là cách Riverpod giúp bạn xử lý các tác vụ bất đồng bộ một các an toàn mà không cần dùng `FutureBuilder` hay `StreamBuilder` truyền thống.

### 🔹 3.1. Ba trạng thái (States)
Một `AsyncValue<T>` luôn ở một trong ba trạng thái sau:
-   ✅ **`Data`**: Chứa dữ liệu thực tế (`T`) khi thành công.
-   ⏳ **`Loading`**: Đang trong quá trình chờ (gọi API, tải file).
-   ❌ **`Error`**: Chứa thông tin lỗi và StackTrace khi thất bại.

### 🔹 3.2. Sức mạnh của `AsyncValue.guard()`
Trong các hàm xử lý logic (ví dụ `login`), thay vì dùng `try-catch` thủ công, hãy dùng `guard`. Nó sẽ tự động bắt lỗi và chuyển `state` sang trạng thái `Error` nếu có ngoại lệ xảy ra.

---

## 4. Cách sử dụng tại UI (Consuming)

### 🔹 4.1. Cách truy cập `WidgetRef`
Để sử dụng các Provider trong UI, bạn cần có đối tượng `WidgetRef`.

-   **Dạng Stateless:** Dùng `ConsumerWidget` thay vì `StatelessWidget`. Hàm `build` sẽ có thêm tham số `WidgetRef ref`.
-   **Dạng Stateful:** Dùng `ConsumerStatefulWidget` và `ConsumerState`. `ref` có thể truy cập ở bất cứ đâu trong class (tương tự `context`).
-   **Dạng Inline:** Dùng widget `Consumer` khi bạn chỉ muốn rebuild một phần nhỏ của UI thay vì cả màn hình lớn.

### 🔹 4.2. Các câu lệnh cơ bản (`watch`, `read`, `listen`)

-   ✅ **`ref.watch(provider)`**: Luôn dùng trong `build`. Giúp UI tự động rebuild mỗi khi state của provider thay đổi.
-   ✅ **`ref.read(provider.notifier)`**: Chỉ dùng để gọi các hàm xử lý hành động (Action) trong `onPressed`, `onTap`, v.v. **Cấm** dùng trong `build`.
-   ✅ **`ref.listen(provider, (prev, next) { ... })`**: Dùng để xử lý các hiệu ứng phụ (**Side Effects**) như hiển thị Dialog, SnackBar hoặc Điều hướng dựa trên state mà không rebuild UI.

### 🔹 4.3. Xử lý UI với `AsyncValue`

Đây là pattern chuẩn trong dự án để xử lý loading và lỗi:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return authState.when(
    // 1. Khi có dữ liệu thành công
    data: (isLoggedIn) => HomeContent(isLoggedIn: isLoggedIn),
    
    // 2. Khi đang tải lần đầu/loading chung
    loading: () => const Center(child: CircularProgressIndicator()),
    
    // 3. Khi xảy ra lỗi (Có nút bấm để thử lại nếu cần)
    error: (err, stack) => Center(
      child: Column(
        children: [
          Text('Xảy ra lỗi: $err'),
          ElevatedButton(
            onPressed: () => ref.invalidate(authNotifierProvider),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    ),
  );
}
```

### 🔹 4.4. Tối ưu hiệu năng với `.select`
Nếu một Provider chứa Object lớn nhưng bạn chỉ quan tâm đến 1 trường dữ liệu, hãy dùng `select` để tránh rebuild không cần thiết:
```dart
final userName = ref.watch(userProvider.select((u) => u.name));
```

---

## 5. Quy tắc quan trọng về Phụ thuộc & Deprecation

### ✅ Luôn dùng `Ref` generic
Để tránh các cảnh báo *Deprecated*, dùng lớp **`Ref`** cho tham số đầu tiên của mọi Provider.

### ✅ Khai báo `dependencies`
Khi Provider A dùng `ref.watch` Provider B, bạn **phải** khai báo Provider B trong danh sách `dependencies`.

### ✅ `Raw<T>` cho `ChangeNotifier`
Nếu đối tượng trả về là `ChangeNotifier`, dùng `Raw<T>` để generator không can thiệp vào vòng đời:
`Raw<GoRouterRefreshNotifier> authRefreshNotifier(Ref ref) { ... }`

---

## 6. Lệnh sinh Code (Build Runner)

Cần cài đặt `fvm` trước khi chạy:

-   **Sinh code 1 lần:**
    `fvm flutter pub run build_runner build --delete-conflicting-outputs`

-   **Tự động sinh khi sửa file (Khuyên dùng khi dev):**
    `fvm flutter pub run build_runner watch --delete-conflicting-outputs`

---
*Tài liệu này được soạn thảo để chuẩn hóa quy trình code trong dự án.*
