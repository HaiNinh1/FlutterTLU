# FlutterTLU

Bài tập môn Lập trình di động — Đại học Thủy Lợi.

## Các project

| Thư mục | Loại | Mô tả |
|---|---|---|
| `bai2/` | Flutter | Bài 2 — Hello World |
| `bai3/` | Flutter | Bài 3 — Hồ sơ cá nhân |
| `bai3Vibe/portfolio_app/` | Flutter | Bài 3 (bản mở rộng) — Portfolio app nhiều màn hình |
| `bai4/` | Android (Java/Gradle) | Bài 4 — Profile App |
| `TH1/` | Flutter (drift/SQLite) | TH1 — Quản lý tài liệu học tập theo kiến trúc Cashew ([báo cáo](TH1/BAO_CAO.md)) |

## Chạy lại trên máy khác

```bash
git clone https://github.com/HaiNinh1/FlutterTLU.git
cd FlutterTLU
```

### Project Flutter (`bai2`, `bai3`, `bai3Vibe/portfolio_app`, `TH1`)

Cần cài sẵn [Flutter SDK](https://docs.flutter.dev/get-started/install).

```bash
cd bai2            # hoac bai3, bai3Vibe/portfolio_app, TH1
flutter pub get    # tai lai package (thu muc build/ va .dart_tool/ khong duoc push)
flutter run        # chon thiet bi: Chrome, Windows, Android emulator...
```

Kiểm tra môi trường nếu gặp lỗi:

```bash
flutter doctor
```

### Project Android (`bai4`)

Mở thư mục `bai4/` bằng Android Studio, chờ Gradle sync rồi bấm Run.

File `local.properties` (đường dẫn Android SDK của từng máy) **không** được push — Android Studio sẽ tự tạo lại khi mở project.

## Lưu ý

Các thư mục sinh ra khi build (`build/`, `.dart_tool/`, `.gradle/`, `.idea/`) đều được bỏ qua trong `.gitignore`.
Sau khi clone, chạy `flutter pub get` (Flutter) hoặc Gradle sync (Android) để khôi phục.
