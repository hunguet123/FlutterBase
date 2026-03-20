# 🚀 Flutter Base Template

Template Flutter chuyên nghiệp: Kiến trúc layered, Riverpod, GoRouter, Firebase, và quản lý Token bảo mật.

---

## 📘 Tài liệu hướng dẫn (Documentation)

Dự án được tài liệu hóa chi tiết cho từng thành phần. Vui lòng đọc kỹ trước khi bắt đầu:

| Tài liệu | Nội dung chính |
| :--- | :--- |
| 📘 **[Project Guide](PROJECT_GUIDE.md)** | Tổng quan kiến trúc, sơ đồ thư mục và luồng hoạt động. |
| 🏗️ **[Data Layer Guide](DATA_LAYER_GUIDE.md)** | Cách tổ chức Repository, quản lý Session và lưu trữ local. |
| 🚀 **[Riverpod Guide](RIVERPOD_GUIDE.md)** | Cách sử dụng Provider, AsyncNotifier và quản lý trạng thái. |
| 🔥 **[Firebase Guide](FIREBASE_GUIDE.md)** | Cấu hình Remote Config, Analytics, FCM và Crashlytics. |

---

## 🛠️ Cài đặt nhanh (Quick Start)

### 1. Môi trường
- **Flutter SDK**: Đã cấu hình với **FVM** (khuyên dùng).
- **Dart SDK**: ^3.10.0.

### 2. Lệnh cơ bản
```bash
# Lấy thư viện
fvm flutter pub get

# Sinh code (Riverpod, Slang i18n)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Chạy ứng dụng (Flavor Development)
fvm flutter run --flavor development
```

---

## ⚙️ Cấu hình quan trọng

### 1. Biến môi trường (.env)
Copy các file mẫu thành file thực tế và điền giá trị của bạn:
- `cp .env.dev.example .env.dev`
- `cp .env.prod.example .env.prod`

### 2. Firebase Setup (Android/iOS)
Vui lòng đặt các file `google-services.json` và `GoogleService-Info.plist` vào đúng thư mục flavor (`src/development` hoặc `src/production`) như mô tả chi tiết trong **[Firebase Guide](FIREBASE_GUIDE.md)**.

---

## 🧪 Kiểm thử (Testing)

Dự án sử dụng **Patrol** để chạy E2E Integration Tests trên thiết bị thật/giả lập:

```bash
# Chạy toàn bộ test suite
PATROL_FLUTTER_COMMAND="fvm flutter" patrol test
```

---

## 📁 Phân chia Layer (Tóm tắt)
- `lib/core/`: Hạ tầng dùng chung (Network, Storage, Messaging, Config).
- `lib/features/`: Mã nguồn theo tính năng (Data, Presentation, Logic).
- `lib/routing/`: Định nghĩa luồng di chuyển trang.
- `lib/shared/`: Widget và Model dùng chung toàn App.

---
*Ghi chú: Luôn ưu tiên tái sử dụng widget tại `lib/shared/widgets/` trước khi tạo mới.*
