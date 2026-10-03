# TH1 — Ứng dụng Quản lý Tài liệu Học tập theo kiến trúc Cashew

Ứng dụng Flutter lưu trữ và tra cứu bài giảng, bài tập, tài liệu tham khảo theo môn học. Mã nguồn được tổ chức theo kiến trúc của ứng dụng mã nguồn mở **Cashew** (`database/ → struct/ → widgets/ → pages/`), dữ liệu lưu bằng SQLite (drift).

📄 **Báo cáo đầy đủ:** [BAO_CAO.md](BAO_CAO.md) (phân tích yêu cầu, sơ đồ luồng dữ liệu, sơ đồ kiến trúc, đối chiếu với Cashew, kiểm thử).

🎬 **Kịch bản quay video:** [KICH_BAN_VIDEO.md](KICH_BAN_VIDEO.md)

## Chức năng

- **Thêm / Sửa / Xoá** tài liệu (có xác nhận khi xoá và nút *Hoàn tác*)
- **Tìm kiếm** không phân biệt dấu tiếng Việt theo tên, mô tả, tác giả, đường dẫn
- Lọc theo loại tài liệu và môn học, sắp xếp, ghim, hạn nộp cho bài tập
- Quản lý môn học (xoá môn: chuyển tài liệu sang môn khác hoặc xoá luôn)
- Thống kê nhanh, giao diện sáng/tối, màu chủ đạo

## Cấu trúc mã nguồn

| Thư mục | Vai trò (giống Cashew) |
|---|---|
| `lib/database/` | Bảng drift, `StudyDatabase` với toàn bộ CRUD, tìm kiếm, quy tắc nghiệp vụ |
| `lib/struct/` | Biến toàn cục (`database`, `sharedPreferences`), cài đặt `appStateSettings` / `updateSettings` |
| `lib/widgets/` | Thành phần giao diện dùng chung: khung trang, popup, snackbar, Provider |
| `lib/pages/` | Các màn hình; trang thêm/sửa dùng chung; hàm `delete*Popup` |
| `lib/functions.dart`, `lib/colors.dart` | Tiện ích, màu sắc và theme |

## Cách chạy

```bash
flutter pub get
flutter run -d windows     # cần bật Developer Mode trên Windows
flutter run                # thiết bị/emulator Android
```

Khi sửa bảng trong `lib/database/tables.dart`:

```bash
dart run build_runner build
```

## Kiểm tra chất lượng

```bash
flutter analyze   # No issues found!
flutter test      # 48/48 test pass
```

## Đóng gói

```powershell
powershell -ExecutionPolicy Bypass -File tool\dong_goi.ps1
```
