# KỊCH BẢN QUAY VIDEO – TH1 (bản ngắn, ~5 phút)
### Nguyễn Hải Ninh – MSSV 2351170609 – Đại học Thủy Lợi

> **Chuẩn bị:** chạy sẵn app (`flutter run -d windows`), mở VS Code thư mục `TH1`, mở `BAO_CAO.md` ở chế độ preview (`Ctrl + Shift + V`), mở sẵn Terminal. Xếp app bên phải, VS Code bên trái.
>
> 🖥️ = thao tác · 🎤 = lời nói

| Checklist | Phần | Thời lượng |
|---|---|---|
| 1. Phân tích yêu cầu, sơ đồ luồng dữ liệu | Phần 1 | 45 giây |
| 2. Cấu trúc thư mục, phân lớp Cashew | Phần 2 | 1 phút |
| 3. Thêm, sửa, xoá, tìm kiếm | Phần 3 | 1 phút 30 giây |
| 4. Kiểm thử phân tách logic giữa các lớp | Phần 4 | 1 phút |
| 5. Đóng gói, báo cáo | Phần 5 | 30 giây |

---

## MỞ ĐẦU (15 giây)

🎤 Em chào thầy, em là Nguyễn Hải Ninh. Đây là bài TH1: ứng dụng quản lý tài liệu học tập theo kiến trúc Cashew, viết bằng Flutter và lưu dữ liệu bằng SQLite qua thư viện drift. Em sẽ trình bày theo 5 mục của checklist.

---

## 1. PHÂN TÍCH YÊU CẦU VÀ SƠ ĐỒ LUỒNG DỮ LIỆU (45 giây)

🖥️ Trong `BAO_CAO.md`, cuộn qua **1.2 Yêu cầu chức năng**, rồi **1.4 DFD mức 0 / mức 1**, rồi **sơ đồ tuần tự Thêm tài liệu**.

🎤 Em có 10 yêu cầu chức năng; bốn yêu cầu chính là thêm, sửa, xoá và tìm kiếm tài liệu. Dữ liệu gồm hai bảng, Môn học và Tài liệu. Sơ đồ luồng dữ liệu mức 1 có 5 tiến trình và 3 kho dữ liệu. Sơ đồ tuần tự cho thấy giao diện chỉ gọi xuống lớp database; lớp database kiểm tra quy tắc rồi ghi vào SQLite, sau đó danh sách tự cập nhật qua Stream.

---

## 2. CẤU TRÚC THƯ MỤC VÀ PHÂN LỚP CASHEW (1 phút)

🖥️ Cuộn tới **2.2 Sơ đồ kiến trúc phân lớp**, sau đó mở cây thư mục `lib/` trong Explorer.

🎤 Em chia code giống Cashew thành 4 lớp:
- **`database/`**: các bảng, truy vấn và **toàn bộ quy tắc nghiệp vụ**.
- **`struct/`**: trạng thái dùng chung, gồm biến `database` và phần cài đặt.
- **`widgets/`**: các thành phần giao diện dùng lại.
- **`pages/`**: các màn hình.

Phụ thuộc chỉ đi **một chiều từ trên xuống**. Em đặt tên file giống Cashew, ví dụ `addDocumentPage.dart` và `databaseGlobal.dart`. Ở mục 2.1 của báo cáo có bảng đối chiếu từng file với Cashew.

🖥️ Mở `lib/widgets/documentEntry.dart` và chỉ vào các tham số `onTap` và `onDelete`.

🎤 Có một điểm em làm chặt hơn Cashew: widget không import trang nào. Trang muốn dùng widget thì truyền hành động vào qua callback.

---

## 3. THÊM – SỬA – XOÁ – TÌM KIẾM (1 phút 30 giây)

🖥️ **Thêm:** bấm **"Thêm tài liệu"**, nhập tên `Bài giảng 2 - Widget`, chọn loại Bài giảng và môn Lập trình di động, rồi bấm **Thêm**.

🎤 Tài liệu mới hiện ngay trong danh sách, và ô thống kê cũng tự tăng lên. Em không viết code làm mới danh sách vì drift Stream tự phát lại dữ liệu.

🖥️ Bấm "Thêm tài liệu" lần nữa, **để trống tên**, bấm Thêm, rồi bấm ← để thoát.

🎤 Câu báo lỗi này do **lớp database** ném ra, giao diện chỉ hiển thị nó.

🖥️ **Sửa:** bấm vào tài liệu vừa thêm, đổi tên thành `Bài giảng 2 - Widget và Layout`, rồi bấm **Lưu thay đổi**.

🎤 Thêm và sửa dùng chung một trang, giống `AddTransactionPage` của Cashew.

🖥️ **Xoá:** bấm biểu tượng thùng rác ở tài liệu đó, bấm **Xoá**, rồi bấm **Hoàn tác** trên snackbar.

🎤 Khi xoá, app luôn hỏi xác nhận và cho phép hoàn tác.

🖥️ **Tìm kiếm:** gõ `giao trinh`, sau đó xoá ô tìm kiếm, bấm thẻ **"Bài tập"** và bấm chip môn **"Lập trình di động"**.

🎤 Tìm kiếm không phân biệt dấu và chữ hoa. Có thể lọc thêm theo loại và theo môn, các điều kiện kết hợp được với nhau.

---

## 4. KIỂM THỬ PHÂN TÁCH LOGIC GIỮA CÁC LỚP (1 phút)

🖥️ Trong Terminal, chạy `flutter test` và chờ dòng `+48: All tests passed!`.

🎤 Em viết 48 test, chia theo từng lớp. Lớp database được test trên SQLite trong bộ nhớ, không cần giao diện. Lớp struct và lớp widgets được test mà không cần cơ sở dữ liệu. Ngoài ra có test tích hợp chạy trên giao diện thật. Mỗi lớp chạy riêng được, đó là bằng chứng các lớp đã tách rời nhau.

🖥️ Mở `lib/widgets/noResults.dart`, thêm dòng `import '../pages/homePage/homePage.dart';`, lưu lại rồi chạy `flutter test test/architecture_test.dart`. Kết quả **báo đỏ**.

🎤 File `architecture_test.dart` đọc mọi lệnh import trong `lib` và kiểm tra 9 quy tắc phân lớp. Ở đây em cố tình cho một widget import ngược lên trang, và test chỉ ra đúng file vi phạm.

🖥️ Bấm `Ctrl + Z`, lưu lại và chạy test lần nữa. Kết quả chuyển **xanh**.

---

## 5. ĐÓNG GÓI VÀ BÁO CÁO (30 giây)

🖥️ Chạy `powershell -ExecutionPolicy Bypass -File tool\dong_goi.ps1`, sau đó cuộn nhanh `BAO_CAO.md`.

🎤 Script này chỉ đóng gói mã nguồn, test và tài liệu thành một file zip để nộp, bỏ qua các thư mục build. Báo cáo `BAO_CAO.md` đi theo đúng 5 mục checklist và giải trình cách em áp dụng kiến trúc Cashew.

---

## KẾT (15 giây)

🎤 Em đã hoàn thành đủ 5 mục: phân tích và sơ đồ luồng dữ liệu, phân lớp theo Cashew, thêm sửa xoá tìm kiếm, 48 test có kèm test kiến trúc, và phần đóng gói cùng báo cáo. Em cảm ơn thầy đã xem.
