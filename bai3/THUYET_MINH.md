# Bài thuyết minh video: Mini Project Hồ Sơ Cá Nhân

**Sinh viên:** Nguyễn Hải Ninh – Đại học Thủy Lợi
**Thời lượng:** khoảng 1 phút 45 giây
**File code:** `lib/main.dart`

## Yêu cầu của đề (cần trả lời được 3 ý)

1. **Demo** ứng dụng Hồ Sơ Cá Nhân.
2. Giải thích cách dùng **Column, Row, Padding** để giao diện **cân đối**.
3. Giải thích cách **tránh lỗi tràn viền (overflow)**.

## Chuẩn bị

- Chạy app bằng lệnh `flutter run -d chrome`.
  ⚠️ Bắt buộc chạy bằng `flutter run` (chế độ debug), vì vạch vàng đen báo overflow **chỉ hiện ở chế độ debug**.
- Mở sẵn file `lib/main.dart` trong VS Code bên cạnh app.
- Công tắc "Demo overflow" để ở trạng thái **bật**.
- Phần mềm quay màn hình: Xbox Game Bar (`Win + G`) hoặc OBS.
- 💡 Trong code đã có sẵn **nhãn 👉 [PHẦN x]** nằm ngay trên đoạn cần chỉ. Lúc thuyết trình, nói đến phần nào thì **chỉ chuột vào dòng có nhãn đó**.
- 💡 Tìm nhanh: bấm **`Ctrl + F`** gõ `PHẦN 3` (hoặc `👉` để lần lượt qua từng nhãn), hoặc **`Ctrl + G`** rồi gõ số dòng.

---

## 🗺️ Bản đồ dòng code (xem nhanh trước khi quay)

| Phần nói | Nhãn trong code | Dòng | Nội dung ở dòng đó |
|---|---|---|---|
| 2. Column | 👉 [PHẦN 2-④] | **25 – 26** | `SingleChildScrollView` (chống tràn dọc) |
| 2. Column | 👉 [PHẦN 2-③] | **27 – 30** | `Center` + `SizedBox(width: 400)` |
| 2. Column | 👉 [PHẦN 2-①] | **35 – 36** | `Column(` – xếp dọc toàn màn hình |
| 2. Column | 👉 [PHẦN 2-②] | **43** (và 51, 67, 83) | `SizedBox(height: …)` – khoảng cách giữa các phần |
| 3. Row | 👉 [PHẦN 3-①] | **53 – 66** | `Row` 3 ô thống kê, mỗi ô bọc `Expanded` |
| 3. Row | *(không có nhãn)* | **129** | `Column` bên trong mỗi ô thống kê (class `OThongKe`) |
| 3. Row | 👉 [PHẦN 3-②] | **141**, **152 – 157** | `Row` dòng liên hệ, chữ bọc `Expanded` (dòng 157) |
| 4. Padding | 👉 [PHẦN 4-①] | **31 – 33** | `Padding(EdgeInsets.all(16))` |
| 4. Padding | 👉 [PHẦN 4-②] | **149 – 151** | `Padding(EdgeInsets.symmetric(vertical: 8))` |
| 5. Overflow | 👉 [PHẦN 5] | **85 – 92** | `Switch` – công tắc demo |
| 5. Overflow | 👉 [PHẦN 5 - BẬT] | **100 – 101** | Có `Expanded` → không lỗi |
| 5. Overflow | 👉 [PHẦN 5 - TẮT] | **103 – 104** | Không có `Expanded` → lỗi vàng đen |

---

## Lời thuyết minh

### 1. Giới thiệu (0:00 – 0:15)

🎬 **Màn hình:** chỉ app, cuộn từ trên xuống. *(Chưa cần mở code.)*

🗣️ **Nói:**
> Em chào thầy cô, em là **Nguyễn Hải Ninh**, sinh viên **Đại học Thủy Lợi**.
> Đây là ứng dụng Hồ Sơ Cá Nhân em làm bằng Flutter. Ứng dụng gồm ảnh đại diện, tên, ba ô thống kê, và thông tin liên hệ: số điện thoại, email và địa chỉ trường.
> Sau đây em xin giải thích cách em sắp xếp giao diện bằng Column, Row và Padding.

---

### 2. Column: xếp theo chiều dọc (0:15 – 0:35)

**① Chỉ vào nhãn 👉 [PHẦN 2-①] — dòng 35 – 36**

```dart
35  // 👉 [PHẦN 2-①] Column: xếp các phần theo chiều dọc
36  child: Column(
```

🗣️
> Toàn bộ màn hình là một **Column**. Column xếp các phần tử **từ trên xuống dưới**: ảnh đại diện, tên, hàng thống kê, rồi đến thông tin liên hệ.

**② Chỉ vào nhãn 👉 [PHẦN 2-②] — dòng 43** (và lướt qua 51, 67, 83)

```dart
43  const SizedBox(height: 12), // 👉 [PHẦN 2-②] SizedBox: khoảng cách
```

🗣️
> Giữa các phần em dùng **SizedBox** để tạo khoảng cách đều nhau.

**③ Chỉ vào nhãn 👉 [PHẦN 2-③] — dòng 27 – 30**

```dart
27  // 👉 [PHẦN 2-③] Center + SizedBox: nội dung rộng 400px ...
28  child: Center(
29    child: SizedBox(
30      width: 400,
```

🗣️
> Nội dung được đặt giữa màn hình (**Center**) với chiều rộng 400 pixel, giống màn hình điện thoại, nên cân đối cả khi mở trên máy tính.

**④ Chỉ vào nhãn 👉 [PHẦN 2-④] — dòng 25 – 26**

```dart
25  // 👉 [PHẦN 2-④] SingleChildScrollView: cho phép cuộn ...
26  body: SingleChildScrollView(
```

🗣️
> Column được bọc trong **SingleChildScrollView**. Nếu màn hình nhỏ, người dùng cuộn được, nên **không bị tràn viền phía dưới**.

---

### 3. Row: xếp theo chiều ngang (0:35 – 0:55)

**① Chỉ vào nhãn 👉 [PHẦN 3-①] — dòng 53 – 66**

```dart
53  // 👉 [PHẦN 3-①] Row: 3 ô thống kê nằm ngang, Expanded chia đều
54  const Row(
55    children: [
56      Expanded(
57        child: OThongKe(so: '3', nhan: 'Năm học'),
58      ),
59      Expanded( ... 'Dự án' ),
62      Expanded( ... 'Kỹ năng' ),
```

🗣️
> Ba ô thống kê nằm ngang nên em dùng **Row**. Mỗi ô được bọc trong **Expanded**, nên ba ô **chia đều chiều ngang**, màn hình to hay nhỏ đều cân đối.

**② Kéo xuống nhãn 👉 [PHẦN 3-②] — dòng 141, rồi chỉ vào 152 – 157** (class `DongThongTin`)

```dart
141  // 👉 [PHẦN 3-②] Dòng thông tin: Row gồm [Icon] [khoảng cách] [Chữ]
 ...
152  child: Row(
153    children: [
154      Icon(icon, color: Colors.blue),
155      const SizedBox(width: 12),
157      Expanded(child: Text(noiDung)),
```

🗣️
> Mỗi dòng liên hệ cũng là một Row gồm **icon, khoảng cách và dòng chữ**. Dòng chữ được bọc **Expanded**, nên địa chỉ dài sẽ **tự xuống dòng** chứ không tràn ra ngoài.

---

### 4. Padding: tạo khoảng cách (0:55 – 1:10)

**① Kéo lên nhãn 👉 [PHẦN 4-①] — dòng 31 – 33**

```dart
31  // 👉 [PHẦN 4-①] Padding: cách mép màn hình 16px
32  child: Padding(
33    padding: const EdgeInsets.all(16),
```

🗣️
> Em dùng **Padding 16 pixel** bao quanh toàn bộ nội dung, để chữ và ảnh **không dính sát mép màn hình**.

**② Kéo xuống nhãn 👉 [PHẦN 4-②] — dòng 149 – 151**

```dart
149  // 👉 [PHẦN 4-②] Padding dọc: các dòng cách nhau đều 8px
150  return Padding(
151    padding: const EdgeInsets.symmetric(vertical: 8),
```

🗣️
> Ở mỗi dòng liên hệ, em thêm **Padding dọc 8 pixel**, để các dòng **cách nhau đều**, nhìn thoáng và gọn.

---

### 5. Demo lỗi overflow (1:10 – 1:35) ⭐

🎬 **Màn hình:** cuộn app xuống cuối, phần "Demo overflow". Code mở ở nhãn **👉 [PHẦN 5]** (dòng 85), kéo xuống **dòng 95 – 106**.

```dart
 99  if (coExpanded)
100    // 👉 [PHẦN 5 - BẬT] Có Expanded: chữ tự xuống dòng -> không lỗi
101    const Expanded(child: Text(gioiThieu))
102  else
103    // 👉 [PHẦN 5 - TẮT] Không có Expanded: chữ tràn ra ngoài -> lỗi vàng đen
104    const Text(gioiThieu),
```

**Bước 1: TẮT công tắc** → chỉ vào nhãn **👉 [PHẦN 5 - TẮT]** (dòng 103 – 104), bên phải app hiện vạch vàng đen.

🗣️
> Bây giờ em tắt công tắc. Dòng chữ giới thiệu được đặt trong Row nhưng **không có Expanded**. Row không giới hạn chiều rộng của chữ, nên chữ dài hơn màn hình và Flutter báo lỗi bằng **vạch vàng đen**, kèm dòng chữ *"RIGHT OVERFLOWED BY … PIXELS"*, tức là bị tràn bên phải bao nhiêu pixel. Đây chính là lỗi **tràn viền, overflow**.

**Bước 2: BẬT lại công tắc** → chỉ vào nhãn **👉 [PHẦN 5 - BẬT]** (dòng 100 – 101), lỗi biến mất.

🗣️
> Khi em bật lại, dòng chữ được bọc trong **Expanded**. Chữ chỉ chiếm phần còn trống của Row và tự xuống dòng, nên **hết lỗi**.

---

### 6. Kết luận (1:35 – 1:45)

🎬 **Màn hình:** quay lại app.

🗣️
> Tóm lại, em dùng **Column** để xếp dọc, **Row** để xếp ngang, **Padding** để tạo khoảng cách. Để không bị tràn viền, em dùng **Expanded** trong Row và **SingleChildScrollView** cho Column.
> Em cảm ơn thầy cô đã xem.

---

## Ghi nhớ nhanh

| Widget | Tác dụng | Dòng trong `main.dart` |
|---|---|---|
| `Column` | Xếp dọc | 36 (toàn màn hình), 129 (ô thống kê) |
| `Row` | Xếp ngang | 54 (3 ô thống kê), 152 (dòng liên hệ) |
| `Padding` | Khoảng cách với mép | 32 (16px ngoài cùng), 150 (8px mỗi dòng) |
| `Expanded` | Chiếm phần còn trống, **chống tràn ngang** | 56, 59, 62 (ô thống kê), 157 (chữ liên hệ), 101 (demo) |
| `SingleChildScrollView` | Cho cuộn, **chống tràn dọc** | 26 |
| `SizedBox` | Khoảng trống cố định | 43, 51, 67, 83 (khoảng cách), 29 – 30 (rộng 400px) |
| `Center` | Đặt nội dung ở giữa | 28 |
