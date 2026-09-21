# THUYẾT TRÌNH DEMO (1–2 phút)

**Chuẩn bị:** chạy `flutter run -d chrome`, mở sẵn VS Code bên cạnh.
Mẹo: trong VS Code bấm **Ctrl + P**, gõ tên file để mở nhanh; bấm **Ctrl + G**, gõ số dòng để nhảy tới dòng đó.

---

### 1. Mở đầu (10s)
🖱️ **Chrome:** đang ở Trang chủ.
> Em chào thầy, em là Nguyễn Hải Ninh. Đây là ứng dụng Hồ sơ cá nhân em làm bằng Flutter, gồm 5 trang: Trang chủ, Kỹ năng, Kinh nghiệm, Dự án và Liên hệ.

---

### 2. Cấu trúc code (20s)
📂 **VS Code:** mở rộng thư mục `lib/` ở thanh bên trái.
> Em chia code làm 3 phần: thư mục `data`, thư mục `screens` và file `main.dart`.

📂 **Mở `lib/data/profile_data.dart`**, dòng **30** (`myName`), cuộn xuống dòng **40** (`skills`).
> File `profile_data.dart` chứa toàn bộ thông tin lấy từ CV. Muốn sửa nội dung chỉ cần sửa file này.

📂 **Mở `lib/main.dart`**, dòng **42–46** (hàm `changePage`).
> Thư mục `screens` chứa các trang, mỗi trang một file. `main.dart` chứa thanh menu. Khi bấm menu, hàm `setState` cập nhật trang đang chọn và giao diện được vẽ lại.

---

### 3. Các trang (40s)

🖱️ **Chrome:** Trang chủ.
📂 **Mở `lib/screens/home_screen.dart`**, dòng **16–19** (`CircleAvatar`).
> Trang chủ dùng `CircleAvatar` để hiện ảnh đại diện hình tròn, kèm tên và lời giới thiệu.

🖱️ **Chrome:** bấm menu **Kỹ năng**.
📂 **Mở `lib/screens/skills_screen.dart`**, dòng **17–18** (`for ... Card`).
> Trang Kỹ năng và Kinh nghiệm dùng vòng lặp `for` để tạo các `Card` từ danh sách dữ liệu.

🖱️ **Chrome:** bấm menu **Dự án** → bấm vào 1 dự án → bấm nút ← quay lại.
📂 **Mở `lib/screens/projects_screen.dart`**, dòng **23–28** (`Navigator.push`).
> Bấm vào một dự án sẽ mở trang chi tiết bằng `Navigator.push`, bấm quay lại để trở về.

🖱️ **Chrome:** bấm menu **Liên hệ** → bấm nút **GitHub**.
📂 **Mở `lib/screens/contact_screen.dart`**, dòng **11–13** (`launchUrl`) và dòng **24–26** (3 nút).
> Trang Liên hệ có các nút Email, GitHub, Điện thoại. Bấm vào thì hàm `launchUrl` của thư viện `url_launcher` sẽ mở link.

---

### 4. Responsive (30s)

📂 **Mở `lib/main.dart`**, dòng **59–62** (`MediaQuery`, `if (screenWidth >= 800)`).
> Em dùng `MediaQuery` để lấy chiều rộng màn hình. Từ 800px trở lên thì menu nằm bên trái, nhỏ hơn thì menu nằm dưới.

📂 **Mở `lib/widgets/common.dart`**, dòng **43–52** (`LayoutBuilder`, `columns`).
> Các thẻ dùng `LayoutBuilder` để tự đổi số cột: 3 cột trên máy tính, 2 cột trên tablet, 1 cột trên điện thoại.

🖱️ **Chrome:** bấm **F12** → **Ctrl + Shift + M** → chọn iPhone, bấm qua Trang chủ, Dự án.
> Đây là giao diện điện thoại: menu đã chuyển xuống dưới, ảnh nằm trên chữ, thẻ dự án còn 1 cột.

---

### 5. Kết thúc (10s)
📂 **VS Code:** mở Terminal (**Ctrl + `**).
> Em đóng gói ứng dụng bằng lệnh `flutter build web` và `flutter build apk`. Em cảm ơn thầy đã xem.
