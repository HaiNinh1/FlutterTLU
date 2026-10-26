# Báo cáo: Xây dựng và Việt hóa ứng dụng Daily You

- Mã nguồn gốc: <https://github.com/Demizo/Daily_You> (Flutter, giấy phép GPL-3.0), phiên bản `3.7.0+3007000`
- Thư mục mã nguồn: [`src/`](src/)
- Nền tảng chạy thử: Windows 11 (desktop, chạy cục bộ trên máy), Flutter 3.47.5 / Dart 3.13.4

## 1. Thiết lập môi trường và cài thư viện

```bash
git clone --depth 1 https://github.com/Demizo/Daily_You.git src
cd src
flutter doctor     # Flutter, Visual Studio 2026 (C++ desktop) đều OK
flutter pub get    # tải toàn bộ package trong pubspec.yaml
```

`flutter pub get` chạy thành công. Ứng dụng dùng `sqflite_common_ffi` + `sqlite3` (CSDL), `provider`, `flutter_local_notifications`, `media_kit`, `record`...

## 2. Build và chạy trên máy cục bộ

```bash
flutter run -d windows            # chạy debug
flutter build windows --debug     # -> build/windows/x64/runner/Debug/daily_you.exe
```

Mã nguồn gốc **không build/chạy được ngay trên Windows**. Tôi sửa 2 lỗi:

| Lỗi | Nguyên nhân | Cách sửa (`windows/CMakeLists.txt`) |
|---|---|---|
| `error STL1011: ... <experimental/coroutine> ... deprecated` khi build plugin `permission_handler_windows` | MSVC mới (VS 2026) chặn header coroutine cũ | Thêm `add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)` |
| App mở lên rồi treo, không hiện cửa sổ: `Failed to load dynamic library 'sqlite3.dll'` | `sqlite3` 3.x build `sqlite3.dll` qua *native assets*, nhưng CMakeLists cũ của project không chép thư mục `build/native_assets/windows/` vào thư mục chạy | Thêm lệnh `install(DIRECTORY "${PROJECT_BUILD_DIR}native_assets/windows/" ...)` như template Flutter mới |

Sau khi sửa: build thành công (`✓ Built build\windows\x64\runner\Debug\daily_you.exe`) và app chạy ổn định. Tôi cũng đổi tiêu đề cửa sổ từ `daily_you` thành `Daily You` (`windows/runner/main.cpp`).

## 3. Rà soát tệp ngôn ngữ, UI và thông báo hệ thống

- Cơ chế đa ngôn ngữ: `flutter_localizations` + tệp ARB (`l10n.yaml` → `lib/l10n/intl_*.arb`, mã sinh ra ở `lib/l10n/generated/`).
- `intl_en.arb` (tệp gốc) có **297 chuỗi**. `intl_vi.arb` có sẵn chỉ dịch **30/297 chuỗi**, nên `flutter gen-l10n` báo `"vi": 267 untranslated message(s)`.
- Tôi rà toàn bộ thư mục `lib/` để tìm chuỗi tiếng Anh viết cứng trong code (`Text('...')`, `title:`, `tooltip:`, thông báo...). Kết quả:
  - Tên/nội dung thông báo dự phòng chạy nền: `'On This Day'`, `'Log Today!'`, `'Backup Failed'` (`main.dart`, `notification_manager.dart`, `backup_restore_utils.dart`).
  - **Lỗi logic**: nhật ký chào mừng, thẻ mặc định (Favorite, Energy, Exercise...) và mẫu mặc định được ghi vào CSDL ở lần chạy đầu theo **ngôn ngữ hệ điều hành** (máy đang để `en-US`), không theo ngôn ngữ của app. Vì vậy app đã Việt hóa mà nội dung này vẫn là tiếng Anh.
  - Các chuỗi còn lại trong code chỉ là log nội bộ cho lập trình viên (`Logger`), không hiển thị cho người dùng.
- Các phần của framework (nút `Huỷ`, `OK`, tên thứ/tháng `Th 2`, `thg 10`) do `GlobalMaterialLocalizations` / `intl` cung cấp sẵn cho `vi`.

## 4. Dịch và thay thế sang tiếng Việt

| Tệp | Thay đổi |
|---|---|
| `lib/l10n/intl_vi.arb` | Dịch thêm 267 chuỗi, tổng cộng **297/297**. Giữ nguyên placeholder (`{count}`, `{tag}`, `{time}`, `{percent}`...) và cú pháp plural ICU. Sửa lại 7 chuỗi dịch cũ cho tự nhiên và thống nhất (vd. "Một Ngày Tốt lành" → "Một ngày tốt lành", "Hôm trước" → "Ngày khác") |
| `lib/config_provider.dart` | Thêm `appLocale()`: trả về ngôn ngữ người dùng chọn, mặc định là `vi` |
| `lib/main.dart` | `MaterialApp` dùng `appLocale()` nên app **mặc định tiếng Việt**, người dùng vẫn đổi được trong Cài đặt → Ngôn ngữ. Việt hóa tên thông báo dự phòng |
| `lib/database/app_database.dart`, `lib/providers/tags_provider.dart`, `lib/providers/templates_provider.dart` | Nhật ký chào mừng, thẻ và mẫu mặc định được tạo theo `appLocale()` thay vì ngôn ngữ hệ điều hành |
| `lib/notification_manager.dart`, `lib/utils/backup_restore_utils.dart` | Việt hóa chuỗi dự phòng của thông báo |

Một số thuật ngữ đã thống nhất: *log* → **nhật ký**, *flashback* → **hồi tưởng**, *tag* → **thẻ**, *template* → **mẫu**, *tracker* → **theo dõi**, *backup/restore* → **sao lưu/khôi phục**, *streak* → **chuỗi**, *accent color* → **màu nhấn**, *biometric unlock* → **mở khóa sinh trắc học**. Tên riêng (Daily You, Daylio, Markdown, AMOLED, GPL-3.0) giữ nguyên.

Kiểm tra: `flutter gen-l10n` không còn báo thiếu chuỗi của `vi`.

## 5. Kiểm tra lại chức năng

- `flutter analyze lib` → **No issues found!**
- Chạy app trên Windows, xóa dữ liệu cũ để kiểm tra lần chạy đầu, rồi đi qua từng màn hình (ảnh trong [`screenshots/`](screenshots/)):

| Màn hình / chức năng | Kết quả |
|---|---|
| Trang chủ, lịch (Th 2 … CN) | Tiếng Việt, hiển thị đúng ([1](screenshots/1_trang_chu.png)) |
| Nhật ký chào mừng, thẻ "Yêu thích", "Năng lượng", ngày "Th 2, 26 thg 10, 2026" | Tiếng Việt, Markdown hiển thị đúng ([2](screenshots/2_nhat_ky_chao_mung.png)) |
| Sửa nhật ký → chọn mẫu → chèn mẫu "Suy ngẫm" → lưu | Hoạt động bình thường ([3](screenshots/3_chon_mau.png), [4](screenshots/4_soan_thao_mau.png)) |
| Cài đặt, Giao diện, Lưu trữ & Đồng bộ | Tiếng Việt, không tràn chữ ([5](screenshots/5_cai_dat.png), [6](screenshots/6_giao_dien.png)) |
| Hộp thoại "Xóa tất cả nhật ký" (placeholder `{prompt}` thay đúng) | Đúng; bấm Huỷ đóng hộp thoại ([7](screenshots/7_hop_thoai_xoa.png)) |
| Thống kê: chuỗi, số từ, biểu đồ, bộ lọc thời gian (plural `{count}`) | Đúng ([8](screenshots/8_thong_ke.png)) |
| Thư viện, ô tìm kiếm | Đúng ([9](screenshots/9_thu_vien.png)) |
| Cài đặt → Ngôn ngữ | Đúng ([10](screenshots/10_ngon_ngu.png)) |

- `flutter test`: **488 test đạt, 18 test lỗi**. Các test lỗi thuộc nhóm zip/sao lưu/đường dẫn tệp và lỗi Windows khóa tệp tạm (`PathAccessException ... being used by another process`), không test nào liên quan đến ngôn ngữ. Các lỗi này đã có trước khi tôi sửa phần ngôn ngữ (lần chạy đầu cũng ra 18 lỗi như vậy).

## Chạy lại

```bash
cd DailyU/src
flutter pub get
flutter run -d windows
```
