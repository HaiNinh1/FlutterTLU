# Kịch bản video: Xây dựng và Việt hóa ứng dụng Daily You

Video dài khoảng **6 phút** (đo từ lần chạy thử). Toàn bộ thao tác trên màn hình chạy tự động bằng `demo/chay_video.ps1`, bạn chỉ cần quay và đọc lời thoại.

## Chuẩn bị

1. OBS: nguồn **Display Capture** (toàn màn hình). Bật micro nếu muốn thu tiếng.
2. Tắt thông báo (Focus assist / Do not disturb) để không có popup chen vào video.
3. Đóng ứng dụng Daily You nếu đang mở. Script tự xóa dữ liệu cũ để video thấy được lần chạy đầu tiên.
4. Chạy: `pwsh -File C:\Workin\FlutterTLU\DailyU\demo\chay_video.ps1`
5. Trong **10 giây** sau khi chạy, bấm **Start Recording** trên OBS.
6. **Không chạm chuột/bàn phím** cho đến khi màn hình hiện **TONG KET CHECKLIST**, sau đó bấm Stop Recording.

## Diễn biến và lời thoại

| Thời gian | Trên màn hình | Lời thoại gợi ý |
|---|---|---|
| 0:00 | Trang GitHub `Demizo/Daily_You` | "Em xin trình bày bài: xây dựng và Việt hóa ứng dụng nhật ký Daily You. Đây là mã nguồn gốc trên GitHub, viết bằng Flutter, giấy phép GPL-3.0." |
| **Bước 1** · 0:25 | Terminal `BUOC DEMO`: `flutter --version`, `flutter doctor`, danh sách thư viện trong `pubspec.yaml`, `flutter pub get` | "Bước 1 là thiết lập môi trường. Máy dùng Flutter 3.47.5, Dart 3.13. `flutter doctor` cho thấy đã có Visual Studio để build cho Windows. Cảnh báo Android chỉ liên quan đến license Android, không ảnh hưởng. Ứng dụng dùng các thư viện như sqflite, provider, flutter_local_notifications... `flutter pub get` tải toàn bộ thư viện về thành công." |
| **Bước 2** · 0:55 | Diff tô màu của `windows/CMakeLists.txt` và `main.cpp` | "Bước 2 là build và chạy trên máy. Mã nguồn gốc không chạy được trên Windows vì 2 lỗi. Thứ nhất, Visual Studio 2026 chặn header coroutine cũ mà plugin permission_handler dùng, em thêm một định nghĩa để bỏ qua. Thứ hai, app mở lên rồi treo vì thiếu `sqlite3.dll`, em thêm lệnh chép thư viện native vào thư mục chạy." |
| 1:15 | Cửa sổ `FLUTTER RUN`: `flutter run -d windows` build khoảng 40 giây | "Giờ em chạy `flutter run -d windows`..." |
| 2:00 | Ứng dụng Daily You mở ra, giao diện tiếng Việt | "Ứng dụng đã build và chạy thành công trên máy cục bộ." |
| **Bước 3** · 2:15 | Kết quả rà soát: `l10n.yaml`, 35 tệp ARB, thống kê **297 chuỗi, bản gốc chỉ dịch 30, thiếu 267**, các chuỗi tiếng Anh viết cứng, lỗi locale | "Bước 3 là rà soát. Ứng dụng dùng flutter_localizations với các tệp ARB. Tệp tiếng Anh có 297 chuỗi, nhưng tệp tiếng Việt gốc chỉ dịch 30, còn thiếu 267 chuỗi. Em cũng tìm thấy các thông báo hệ thống viết cứng bằng tiếng Anh như 'On This Day', 'Log Today', 'Backup Failed'. Ngoài ra có một lỗi logic: nhật ký chào mừng, thẻ và mẫu mặc định được tạo theo ngôn ngữ hệ điều hành, nên máy cài tiếng Anh thì nội dung này vẫn ra tiếng Anh." |
| **Bước 4** · 2:50 | Kết quả: **297/297**, placeholder khớp 297/297, bảng chuỗi Anh → Việt, `gen-l10n` không còn báo `vi` | "Bước 4 là dịch. Em đã dịch đủ 297 trên 297 chuỗi, giữ nguyên các placeholder như count, tag, time. Đây là một số ví dụ. Lệnh gen-l10n không còn báo tiếng Việt thiếu chuỗi, trong khi các ngôn ngữ khác như tiếng Đức vẫn còn thiếu." |
| 3:15 | VS Code so sánh `intl_vi.arb` bản gốc ↔ bản đã dịch | "Đây là so sánh tệp tiếng Việt trước và sau khi dịch. Các thuật ngữ được thống nhất: log là nhật ký, flashback là hồi tưởng, tag là thẻ, template là mẫu, backup là sao lưu." |
| 3:40 | Diff code: `appLocale()`, `app_database.dart`, `main.dart`, `notification_manager.dart` | "Về code, em thêm hàm appLocale để mặc định dùng tiếng Việt, người dùng vẫn đổi được trong cài đặt. Nội dung mặc định giờ được tạo theo ngôn ngữ của app, và các thông báo hệ thống cũng đã được Việt hóa." |
| **Bước 5** · 4:15 | `flutter analyze` chạy nền, chuyển sang ứng dụng | "Bước 5 là kiểm tra lại toàn bộ chức năng." |
| 4:20 | Thư viện → tìm "Daily" (ra "1 nhật ký") → mở nhật ký chào mừng tiếng Việt, thẻ "Yêu thích", "Năng lượng" | "Tìm kiếm hoạt động. Nhật ký chào mừng ở lần chạy đầu đã là tiếng Việt, định dạng Markdown hiển thị đúng." |
| 4:35 | Sửa → chọn mẫu → thêm mẫu "Suy ngẫm" → lưu | "Em sửa nhật ký, chèn mẫu Suy ngẫm rồi lưu, mọi thứ hoạt động bình thường." |
| 4:55 | Thống kê | "Màn hình thống kê hiển thị chuỗi ngày, số từ, biểu đồ, dạng số nhiều đúng." |
| 5:00 | Cài đặt → Giao diện → menu chủ đề → Lưu trữ & Đồng bộ → hộp thoại "Xóa tất cả nhật ký" → Huỷ → Sao lưu & Khôi phục | "Các trang cài đặt và hộp thoại xác nhận đều đã Việt hóa, chữ không bị tràn hay vỡ bố cục." |
| 5:30 | Ngôn ngữ → **English** (toàn bộ giao diện đổi sang tiếng Anh) → **Tiếng Việt** | "Cuối cùng là đổi ngôn ngữ: chuyển sang English rồi về Tiếng Việt, giao diện đổi ngay, không lỗi hiển thị hay vận hành." |
| 5:55 | Trang chủ → terminal: `flutter analyze` → **No issues found!** | "Phân tích mã nguồn không phát hiện lỗi nào." |
| 6:05 | **TONG KET CHECKLIST**, 5 mục đều [x] | "Tóm lại, em đã hoàn thành đủ 5 mục: thiết lập môi trường, build và chạy, rà soát, dịch và kiểm tra. Em cảm ơn thầy cô đã xem." → **Stop Recording** |

Thời gian chỉ là ước lượng (build, `flutter doctor` và `flutter analyze` có thể nhanh hoặc chậm hơn vài giây). Nếu muốn lời thoại khớp hình, bạn có thể đọc theo những gì đang hiện trên màn hình.

## Nếu có sự cố

- Script ghi nhật ký vào `demo/chay_video.log`. Dòng `LOI:` cho biết bước bị lỗi.
- Muốn quay lại từ đầu: đóng các cửa sổ `BUOC DEMO`, `FLUTTER RUN`, Daily You rồi chạy lại lệnh ở bước 4 phần Chuẩn bị.
