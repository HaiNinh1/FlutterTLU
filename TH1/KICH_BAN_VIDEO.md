# KỊCH BẢN QUAY VIDEO – TH1: ỨNG DỤNG QUẢN LÝ TÀI LIỆU HỌC TẬP THEO KIẾN TRÚC CASHEW
### Sinh viên: Nguyễn Hải Ninh – MSSV 2351170609 – Đại học Thủy Lợi

> **Cách đọc file này**
> - 🖥️ **LÀM:** thao tác trên màn hình.
> - 🎤 **NÓI:** câu bạn đọc to trong video.
> - Code trong file được **chép nguyên văn** từ project, có ghi **số dòng** để bạn mở đúng chỗ (`Ctrl + P` gõ tên file, `Ctrl + G` gõ số dòng).
>
> **Chuẩn bị trước khi bấm quay:**
> - Bật **Developer Mode** của Windows (chỉ cần làm một lần): chạy `start ms-settings:developers` rồi gạt bật.
> - Mở VS Code với thư mục `TH1`.
> - Cài extension **"Markdown Preview Mermaid Support"** để sơ đồ trong `BAO_CAO.md` hiện thành hình khi bấm `Ctrl + Shift + V`.
> - Chạy app trước một lần: `flutter run -d windows` (hoặc `flutter run` trên máy ảo Android). Lần chạy đầu app tự tạo **dữ liệu mẫu**: 3 môn học và 4 tài liệu.
> - Mở sẵn một cửa sổ Terminal trong VS Code ở thư mục `TH1`.
> - Xếp **app bên phải, VS Code bên trái** để vừa demo vừa chỉ code.
>
> Video khoảng **12–14 phút**.

**Bản đồ checklist → phần trong video:**

| Checklist của đề | Phần trong video | Thời lượng |
|---|---|---|
| 1. Phân tích yêu cầu, sơ đồ luồng dữ liệu | YÊU CẦU 1 | 2 phút |
| 2. Cấu trúc thư mục, phân lớp theo Cashew | YÊU CẦU 2 | 3 phút |
| 3. Thêm, sửa, xoá, tìm kiếm | YÊU CẦU 3 | 4 phút |
| 4. Kiểm thử phân tách logic giữa các lớp | YÊU CẦU 4 | 2,5 phút |
| 5. Đóng gói, báo cáo | YÊU CẦU 5 | 1 phút |

---

## MỞ ĐẦU (30 giây)

🖥️ **LÀM:** Màn hình app đang mở ở tab **Tài liệu**, có sẵn dữ liệu mẫu.

🎤 **NÓI:**
> Em chào thầy, em là Nguyễn Hải Ninh, sinh viên Đại học Thủy Lợi. Hôm nay em xin trình bày bài TH1: **"Xây dựng ứng dụng quản lý tài liệu học tập theo kiến trúc Cashew"**.
>
> Ứng dụng giúp sinh viên lưu lại **bài giảng, bài tập và tài liệu tham khảo**, nhóm theo từng **môn học**, rồi tìm lại nhanh khi cần. Em viết bằng **Flutter**, dữ liệu lưu bằng **SQLite** qua thư viện **drift**, chính là thư viện mà Cashew dùng.
>
> Em sẽ trình bày lần lượt theo **5 mục trong checklist** của đề bài.

---

## YÊU CẦU 1 – PHÂN TÍCH YÊU CẦU CHỨC NĂNG VÀ SƠ ĐỒ LUỒNG DỮ LIỆU (2 phút)

### 1.1. Danh sách yêu cầu chức năng

🖥️ **LÀM:** Mở `BAO_CAO.md`, bấm `Ctrl + Shift + V` để xem dạng đẹp. Cuộn tới mục **1.2. Yêu cầu chức năng**.

🎤 **NÓI:**
> Đầu tiên em phân tích yêu cầu. Người dùng là sinh viên, dữ liệu lưu ngay trên máy nên app chạy được khi không có mạng.
>
> Em xác định **10 yêu cầu chức năng**. Bốn yêu cầu chính của đề là **F1 Thêm, F2 Sửa, F3 Xoá, F4 Tìm kiếm**. Ngoài ra em làm thêm lọc theo loại và môn, sắp xếp, ghim, quản lý môn học, thống kê nhanh, hạn nộp và cài đặt giao diện.

🖥️ **LÀM:** Cuộn xuống bảng **Quy tắc nghiệp vụ R1–R6**.

🎤 **NÓI:**
> Em cũng liệt kê **6 quy tắc nghiệp vụ**. Ví dụ: tên tài liệu là bắt buộc; tài liệu phải thuộc một môn học đang tồn tại; chỉ **bài tập** mới có hạn nộp; tên môn học không được trùng nhau, kể cả khi khác dấu hay khác chữ hoa. Lát nữa thầy sẽ thấy các quy tắc này đều nằm ở **một lớp duy nhất** trong code.

### 1.2. Mô hình dữ liệu

🖥️ **LÀM:** Cuộn tới mục **1.3. Mô hình dữ liệu** (sơ đồ ERD).

🎤 **NÓI:**
> Dữ liệu gồm 2 bảng. Một **môn học** có nhiều **tài liệu**, nối với nhau bằng khoá ngoại `subject_fk`.
>
> Em giữ đúng quy ước của Cashew: khoá chính là **chuỗi UUID**, loại tài liệu lưu dạng **số nguyên của enum**, và có cột ngày tạo, ngày sửa. Bảng tài liệu có thêm hai cột `search_text` và `sort_title`, là bản **đã bỏ dấu** của nội dung, dùng để tìm kiếm và sắp xếp tiếng Việt cho đúng.

### 1.3. Sơ đồ luồng dữ liệu

🖥️ **LÀM:** Cuộn tới **DFD mức 0**, rồi **DFD mức 1**.

🎤 **NÓI:**
> Đây là sơ đồ luồng dữ liệu. Ở **mức 0**, toàn bộ hệ thống là một khối: sinh viên đưa vào thông tin tài liệu, từ khoá tìm kiếm, lệnh xoá; hệ thống trả về danh sách đã lọc, thống kê và thông báo lỗi.
>
> Ở **mức 1**, em tách ra 5 tiến trình: thêm/sửa, xoá, tìm kiếm và lọc, quản lý môn học, quản lý cài đặt. Có 3 kho dữ liệu: bảng **Documents** và **Subjects** trong SQLite, và **cài đặt** lưu trong SharedPreferences, giống hệt cách Cashew tách dữ liệu nghiệp vụ và cài đặt.

🖥️ **LÀM:** Cuộn tới **Sơ đồ tuần tự – Thêm tài liệu**.

🎤 **NÓI:**
> Sơ đồ tuần tự cho thấy dữ liệu đi qua từng lớp khi thêm một tài liệu: trang giao diện chỉ gom dữ liệu rồi gọi **lớp database**. Lớp database kiểm tra quy tắc; nếu sai thì ném lỗi để giao diện hiện thông báo, nếu đúng thì ghi vào SQLite.
>
> Điểm quan trọng là **trang thêm không hề gọi "làm mới danh sách"**. drift tự phát lại dữ liệu cho trang danh sách, nên danh sách tự cập nhật. Đây là đặc trưng của Cashew mà em sẽ demo ở phần 3.

---

## YÊU CẦU 2 – CẤU TRÚC THƯ MỤC VÀ PHÂN LỚP THEO KIẾN TRÚC CASHEW (3 phút)

### 2.1. Bốn lớp của Cashew

🖥️ **LÀM:** Trong `BAO_CAO.md`, cuộn tới **2.2. Sơ đồ kiến trúc phân lớp**.

🎤 **NÓI:**
> Trước khi làm, em đọc mã nguồn Cashew, là ứng dụng quản lý chi tiêu mà nhóm em đã nghiên cứu ở bài 5. Cashew chia code trong `lib` thành **4 lớp**:
> - **`database/`**: khai báo bảng và **toàn bộ** truy vấn, quy tắc dữ liệu.
> - **`struct/`**: trạng thái dùng chung toàn app, như biến `database` và các cài đặt.
> - **`widgets/`**: các thành phần giao diện dùng lại được: khung trang, hộp thoại, snackbar.
> - **`pages/`**: các màn hình, ghép widget lại và gọi xuống database.
>
> Cộng thêm hai file tiện ích `functions.dart` và `colors.dart` ở gốc. App của em làm **đúng 4 lớp này**. Mũi tên phụ thuộc chỉ đi **từ trên xuống**: `pages` dùng `widgets`, `widgets` dùng `struct`, `struct` dùng `database`, không bao giờ ngược lại.

### 2.2. Cấu trúc thư mục thật

🖥️ **LÀM:** Bên cột Explorer của VS Code, mở lần lượt `lib/database`, `lib/struct`, `lib/widgets`, `lib/pages`.

🎤 **NÓI:**
> Đây là cây thư mục thật. Tên file em giữ **đúng kiểu Cashew**, viết camelCase như `addDocumentPage.dart`, `databaseGlobal.dart`, để dễ đối chiếu. Trong báo cáo, mục 2.1 có **bảng 17 điểm** đối chiếu từng file của em với file tương ứng trong Cashew. Em xin đi qua mấy điểm chính.

### 2.3. Lớp database · `lib/database/tables.dart` dòng 94 đến 107

🖥️ **LÀM:** Mở `lib/database/tables.dart`, bôi đen dòng 94–107.

🎤 **NÓI:**
> Lớp database gói trong **một lớp duy nhất** là `StudyDatabase`, giống `FinanceDatabase` của Cashew. Ở dòng 105 em bật **khoá ngoại** của SQLite, để không thể có tài liệu thuộc một môn đã bị xoá.
>
> File này **không import gì của giao diện Flutter**, nên lớp database chạy độc lập được. Phần kiểm thử sẽ chứng minh điều đó.

### 2.4. Lớp struct · `databaseGlobal.dart` dòng 7 đến 8, `settings.dart` dòng 57 đến 66

🖥️ **LÀM:** Mở `lib/struct/databaseGlobal.dart`, bôi đen dòng 7–8.

```dart
late StudyDatabase database;
late SharedPreferences sharedPreferences;
```

🎤 **NÓI:**
> Lớp struct giữ **biến toàn cục**, giống hệt file cùng tên của Cashew. Mọi trang chỉ cần gọi `database.` là dùng được cơ sở dữ liệu.

🖥️ **LÀM:** Mở `lib/struct/settings.dart`, bôi đen dòng 57–66.

```dart
Future<void> updateSettings(
  String key,
  dynamic value, {
  required bool updateGlobalState,
}) async {
  appStateSettings[key] = value;
  await _saveSettings();
  settingsVersion.value++;
  if (updateGlobalState) appStateKey.currentState?.refreshAppState();
}
```

🎤 **NÓI:**
> Cài đặt cũng theo kiểu Cashew: một `Map` tên `appStateSettings` lưu thành JSON. Mọi thay đổi đi qua hàm `updateSettings`. Nếu `updateGlobalState` là true, ví dụ khi đổi giao diện sáng/tối, thì cả ứng dụng được vẽ lại.

### 2.5. Thứ tự khởi động · `lib/main.dart` dòng 17 đến 28

🖥️ **LÀM:** Mở `lib/main.dart`, bôi đen dòng 17–28.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  database = StudyDatabase(openConnection('tai_lieu_hoc_tap'));
  await initializeSettings();
  if (appStateSettings['hasInitializedDefaults'] != true) {
    await initializeDefaultDatabase(database);
    await updateSettings('hasInitializedDefaults', true,
        updateGlobalState: false);
  }
  runApp(InitializeApp(key: appStateKey));
}
```

🎤 **NÓI:**
> Hàm `main` khởi động **đúng thứ tự như Cashew**: mở SharedPreferences, mở cơ sở dữ liệu, nạp cài đặt, tạo dữ liệu mẫu ở lần chạy đầu, rồi mới `runApp`.

### 2.6. Những chỗ em làm khác Cashew

🖥️ **LÀM:** Trong `BAO_CAO.md`, cuộn tới **2.4. Những điểm làm khác Cashew**.

🎤 **NÓI:**
> Khi đọc code Cashew, em thấy có vài chỗ các lớp **dính vào nhau**. Ví dụ widget dòng giao dịch của Cashew import thẳng trang sửa giao dịch, tức là `widgets` phụ thuộc ngược lên `pages`.
>
> Em sửa lại để chiều phụ thuộc luôn đúng. Ví dụ widget `DocumentEntry` không biết gì về trang nào; trang nào dùng nó thì **truyền hành động vào qua callback**.

🖥️ **LÀM:** Mở `lib/widgets/documentEntry.dart`, bôi đen dòng 12–25.

```dart
  const DocumentEntry({
    super.key,
    required this.item,
    required this.onTap,
    this.onTogglePinned,
    this.onDelete,
    this.showDescription = true,
  });
```

🎤 **NÓI:**
> `onTap`, `onTogglePinned`, `onDelete` là các hàm do trang truyền vào. Nhờ vậy widget này **dùng lại được ở bất kỳ đâu** và kiểm thử được mà không cần cơ sở dữ liệu.

---

## YÊU CẦU 3 – TRIỂN KHAI CHỨC NĂNG THÊM, SỬA, XOÁ, TÌM KIẾM (4 phút)

### 3.1. Demo THÊM tài liệu

🖥️ **LÀM:** Trên app, bấm nút **"Thêm tài liệu"**. Nhập:
- Tên: `Bài giảng 2 - Widget cơ bản`
- Loại: **Bài giảng**
- Môn: **Lập trình di động**
- Tác giả: `Nguyễn Văn Đức`

Bấm **Thêm**.

🎤 **NÓI:**
> Em thêm một bài giảng mới. Bấm **Thêm** xong, tài liệu hiện ngay trong danh sách, và ô thống kê "Bài giảng" phía trên cũng **tự tăng lên 1**. Em không viết dòng code nào để làm mới danh sách cả.

🖥️ **LÀM:** Bấm "Thêm tài liệu" lần nữa, **để trống tên**, bấm **Thêm**.

🎤 **NÓI:**
> Nếu để trống tên, app báo **"Vui lòng nhập tên tài liệu"** ngay dưới ô nhập. Câu báo lỗi này **không phải do trang giao diện kiểm tra**, mà do lớp database ném ra. Em sẽ chỉ trong code ngay sau đây.

🖥️ **LÀM:** Bấm nút quay lại (←) để thoát trang thêm.

### 3.2. Một trang cho cả Thêm và Sửa · `lib/pages/addDocumentPage.dart` dòng 18 đến 25

🖥️ **LÀM:** Mở `lib/pages/addDocumentPage.dart`, bôi đen dòng 18–25.

```dart
class AddDocumentPage extends StatefulWidget {
  const AddDocumentPage({super.key, this.document});

  final Document? document;
```

🎤 **NÓI:**
> Giống `AddTransactionPage` của Cashew, em dùng **một trang cho cả thêm và sửa**. Nếu không truyền `document` thì là **thêm mới**; nếu truyền một tài liệu vào thì trang chuyển sang chế độ **sửa**: điền sẵn dữ liệu, đổi tiêu đề thành "Sửa tài liệu" và hiện thêm nút xoá.

### 3.3. Trang chỉ gọi xuống database · dòng 110 đến 140

🖥️ **LÀM:** Bôi đen dòng 110–140 (hàm `_save`).

```dart
    try {
      await database.createOrUpdateDocument(_createDocument(),
          insert: !_isEditing);
      if (!mounted) return;
      popRoute(context);
      ...
    } on DocumentValidationException catch (e) {
      final message = validationMessage(e.code);
      if (mounted && e.code.startsWith('title')) {
        setState(() => _titleError = message);
      }
      openSnackbar(title: message, icon: Icons.error_outline_rounded);
```

🎤 **NÓI:**
> Hàm lưu của trang rất ngắn: chỉ gọi **`database.createOrUpdateDocument`**. Nếu lớp database ném lỗi `DocumentValidationException`, trang **chỉ việc hiển thị**: đổi mã lỗi thành câu tiếng Việt bằng hàm `validationMessage` ở lớp struct.

### 3.4. Quy tắc nghiệp vụ nằm ở lớp database · `lib/database/tables.dart` dòng 360 đến 410

🖥️ **LÀM:** Mở `lib/database/tables.dart`, bôi đen dòng 366–387.

```dart
    final title = document.title.trim();
    if (title.isEmpty) throw const DocumentValidationException('title-empty');
    ...
    if (await tryGetSubject(document.subjectFk) == null) {
      throw const DocumentValidationException('subject-not-found');
    }
    ...
    // Chỉ bài tập mới có hạn nộp
    final dueDate = document.type == DocumentType.assignment
        ? document.dueDate
        : null;
```

🎤 **NÓI:**
> Đây là nơi **tất cả quy tắc nghiệp vụ** được kiểm tra, giống hàm `createOrUpdateTransaction` của Cashew: cắt khoảng trắng, tên không được rỗng, môn học phải tồn tại, URL phải hợp lệ, và chỉ bài tập mới giữ hạn nộp.
>
> Một hàm này dùng cho **cả thêm và sửa**: tham số `insert` là true thì tạo khoá UUID mới, false thì giữ khoá cũ.

🖥️ **LÀM:** Bôi đen dòng 405–408.

```dart
        // toCompanion(false): cột null được ghi là NULL. Với true, drift coi null là
        // "không đổi" và UPSERT sẽ giữ lại giá trị cũ (xoá mô tả khi sửa sẽ không có tác dụng).
        .toCompanion(false);
    await into(documents).insertOnConflictUpdate(companion);
```

🎤 **NÓI:**
> Có một lỗi em phát hiện khi review code: ban đầu em dùng `toCompanion(true)`, nên khi sửa tài liệu và **xoá trắng ô mô tả** thì mô tả cũ vẫn còn trong cơ sở dữ liệu. Em đã sửa thành `false` và viết **test riêng** cho trường hợp này.

### 3.5. Demo SỬA tài liệu

🖥️ **LÀM:** Trên app, bấm vào tài liệu **"Bài giảng 2 - Widget cơ bản"**. Sửa tên thành `Bài giảng 2 - Widget và Layout`, xoá trắng ô **Tác giả**. Bấm **Lưu thay đổi**.

🎤 **NÓI:**
> Bấm vào một tài liệu là mở trang **sửa**, dữ liệu được điền sẵn. Em đổi tên và xoá tác giả, bấm lưu, danh sách cập nhật ngay.

🖥️ **LÀM:** Mở lại tài liệu đó, gõ thêm vài chữ vào tên rồi bấm nút **← quay lại**.

🎤 **NÓI:**
> Nếu em sửa dở rồi bấm quay lại, app **hỏi "Bỏ các thay đổi?"** để tránh mất dữ liệu, giống hộp thoại `discardChangesPopup` của Cashew.

🖥️ **LÀM:** Bấm **"Bỏ thay đổi"**.

### 3.6. Demo XOÁ tài liệu và Hoàn tác

🖥️ **LÀM:** Bấm biểu tượng **thùng rác** ở dòng "Bài giảng 2 - Widget và Layout" → hộp thoại hiện ra → bấm **Xoá**. Sau đó bấm **Hoàn tác** trên snackbar (trong vòng 4 giây).

🎤 **NÓI:**
> Khi xoá, app luôn **hỏi xác nhận**. Xoá xong có snackbar với nút **Hoàn tác** trong 4 giây. Em bấm hoàn tác thì tài liệu quay lại đúng như cũ, giữ nguyên cả ngày tạo.

🖥️ **LÀM:** Mở `lib/pages/addDocumentPage.dart`, bôi đen dòng 322–353.

```dart
Future<DeletePopupAction?> deleteDocumentPopup(
  BuildContext context, {
  required Document document,
  required RoutesToPopAfterDelete routesToPopAfterDelete,
}) async {
  final action = await openDeletePopup(
    context,
    title: 'Xoá tài liệu?',
    subtitle: document.title,
  );
  if (action != DeletePopupAction.delete) return action;
  ...
  await database.deleteDocument(document.documentPk);
```

🎤 **NÓI:**
> Hàm `deleteDocumentPopup` đặt **ngay cạnh trang của tài liệu**, đúng cách Cashew đặt `deleteTransactionPopup`. Nó dùng `openDeletePopup` của lớp widgets để hỏi, rồi gọi `database.deleteDocument`. Tham số `RoutesToPopAfterDelete` cho biết xoá xong có cần đóng trang hay không: xoá từ danh sách thì không đóng, xoá trong trang sửa thì đóng.

### 3.7. Demo TÌM KIẾM và LỌC

🖥️ **LÀM:** Trên app, gõ vào ô tìm kiếm lần lượt:
1. `giao trinh` → ra "Giáo trình Cơ sở dữ liệu…"
2. `DRIFT` → ra "Drift documentation"
3. Xoá ô tìm kiếm, bấm thẻ thống kê **"Bài tập"** → chỉ còn bài tập
4. Bấm thêm chip môn **"Lập trình di động"**

🎤 **NÓI:**
> Ô tìm kiếm tìm theo tên, mô tả, tác giả và đường dẫn. Em gõ **không dấu** "giao trinh" vẫn ra "Giáo trình", gõ chữ hoa vẫn ra. Bấm vào thẻ thống kê thì **lọc theo loại**, bấm chip thì **lọc theo môn**. Các điều kiện **kết hợp được với nhau**.

### 3.8. Code tìm kiếm · `searchNormalize.dart` dòng 24 đến 32, `tables.dart` dòng 240 đến 292

🖥️ **LÀM:** Mở `lib/database/searchNormalize.dart`, bôi đen dòng 24–32.

🎤 **NÓI:**
> SQLite chỉ bỏ qua chữ hoa/thường với chữ tiếng Anh, nên "GIẢI TÍCH" và "giải tích" sẽ không khớp nhau. Em xử lý ở lớp database: hàm `normalizeForSearch` chuyển chữ thường và **bỏ dấu tiếng Việt**, kể cả "đ" thành "d". Mỗi lần lưu, tài liệu được tính sẵn chuỗi này vào cột `searchText`.

🖥️ **LÀM:** Mở `lib/database/tables.dart`, bôi đen dòng 240–249, rồi dòng 278–292.

```dart
      ..where(
        onlyShowBasedOnSearchQuery(searchFor) &
            onlyShowBasedOnTypes(types) &
            onlyShowBasedOnSubjects(subjectFks) &
            (onlyPinned ? documents.pinned.equals(true) : const Constant(true)),
      )
      ..orderBy([
        OrderingTerm.desc(documents.pinned),
        sortTerm,
        OrderingTerm.desc(documents.dateCreated),
      ]);
```

🎤 **NÓI:**
> Mỗi điều kiện lọc là một **biểu thức riêng, dùng lại được**: theo từ khoá, theo loại, theo môn. Em ghép chúng bằng dấu `&`, đúng cách Cashew viết `onlyShowTransactionBasedOnSearchQuery`. Tài liệu được ghim luôn xếp đầu.
>
> Em dùng hàm `instr` thay cho `LIKE`, để nếu người dùng gõ ký tự `%` thì nó được hiểu là chữ thường, không phải ký tự đại diện.

### 3.9. Vì sao danh sách tự cập nhật · `lib/pages/homePage/homePage.dart` dòng 137 đến 145

🖥️ **LÀM:** Mở `lib/pages/homePage/homePage.dart`, bôi đen dòng 137–145.

```dart
        ValueListenableBuilder<int>(
          valueListenable: settingsVersion,
          builder: (context, _, _) => StreamBuilder<List<DocumentWithSubject>>(
            stream: _documentsStream(activeSubjectFks, getDocumentSort()),
```

🎤 **NÓI:**
> Trang danh sách đọc dữ liệu bằng **`StreamBuilder`** trên `database.watchDocuments`. Đây là cách Cashew làm. drift theo dõi bảng, nên bất cứ khi nào có thêm, sửa hay xoá ở đâu, stream **tự phát lại** và danh sách vẽ lại. Vì thế lúc nãy thêm tài liệu xong, danh sách và thống kê cập nhật mà em không phải làm mới bằng tay.

---

## YÊU CẦU 4 – KIỂM THỬ TÍNH ĐÚNG ĐẮN CỦA VIỆC PHÂN TÁCH LOGIC GIỮA CÁC LỚP (2,5 phút)

### 4.1. Chạy toàn bộ test

🖥️ **LÀM:** Ở Terminal, chạy:

```bash
flutter analyze
flutter test
```

Chờ đến dòng `+48: All tests passed!`.

🎤 **NÓI:**
> Em viết **48 test**, tất cả đều pass, và `flutter analyze` không có cảnh báo nào.

### 4.2. Mỗi lớp được kiểm thử riêng

🖥️ **LÀM:** Trong `BAO_CAO.md`, cuộn tới **4.1. Chiến lược: mỗi lớp được kiểm thử riêng**.

🎤 **NÓI:**
> Em chia test theo đúng các lớp:
> - `database_test.dart`, **22 test**, kiểm thử lớp database trên SQLite **trong bộ nhớ**, **không dựng một màn hình nào**.
> - `settings_test.dart` kiểm thử lớp struct, **không cần cơ sở dữ liệu**.
> - `widgets_test.dart` kiểm thử lớp widgets bằng dữ liệu giả, **cũng không cần cơ sở dữ liệu**.
> - `widget_test.dart` kiểm thử **tích hợp**: bấm nút thật trên giao diện để thêm, tìm, sửa, xoá, hoàn tác.
>
> Việc mỗi lớp **chạy riêng được** mà không cần lớp kia chính là bằng chứng các lớp đã tách rời nhau.

### 4.3. Test kiến trúc · `test/architecture_test.dart`

🖥️ **LÀM:** Mở `test/architecture_test.dart`, bôi đen dòng 114–121.

```dart
  test('widgets/ không import pages/ hay main.dart', () {
    expect(
      violations((e) =>
          layerOfEdge(e) == 'widgets' &&
          {'pages', 'main.dart'}.contains(e.target)),
      isEmpty,
    );
  });
```

🎤 **NÓI:**
> Quan trọng nhất là file **test kiến trúc**. Test này đọc **toàn bộ lệnh `import`** trong thư mục `lib`, xác định mỗi file thuộc lớp nào, rồi kiểm tra 9 quy tắc. Ví dụ: database không được dùng Flutter giao diện; struct chỉ được dùng database; widgets không được import pages; và giao diện **không được tự viết câu SQL** hay gọi thẳng truy vấn, mà phải đi qua hàm của lớp database.

### 4.4. Demo: cố tình phá quy tắc

🖥️ **LÀM:** Mở `lib/widgets/noResults.dart`, thêm vào **dòng 2**:

```dart
import '../pages/homePage/homePage.dart';
```

Lưu lại, rồi chạy:

```bash
flutter test test/architecture_test.dart
```

🎤 **NÓI:**
> Để chứng minh test này có tác dụng, em **cố tình vi phạm**: cho một widget import ngược lên trang chủ. Chạy test thì báo đỏ ngay:

🖥️ **LÀM:** Chỉ vào kết quả trên Terminal:

```
00:00 +4 -1: widgets/ không import pages/ hay main.dart [E]
  Expected: empty
    Actual: ['widgets\\noResults.dart -> ../pages/homePage/homePage.dart']
```

🎤 **NÓI:**
> Test chỉ ra **đúng file và đúng dòng import** vi phạm. Như vậy sau này ai sửa code mà làm sai kiến trúc thì test sẽ bắt được ngay.

🖥️ **LÀM:** Xoá dòng vừa thêm (`Ctrl + Z`), lưu, chạy lại `flutter test test/architecture_test.dart` → xanh.

🎤 **NÓI:**
> Em xoá dòng đó đi thì test xanh trở lại.

---

## YÊU CẦU 5 – ĐÓNG GÓI MÃ NGUỒN VÀ BÁO CÁO (1 phút)

### 5.1. Đóng gói

🖥️ **LÀM:** Ở Terminal, chạy:

```powershell
powershell -ExecutionPolicy Bypass -File tool\dong_goi.ps1
```

🎤 **NÓI:**
> Để nộp bài, em viết script `dong_goi.ps1`. Script **chỉ lấy mã nguồn, test và tài liệu**, bỏ các thư mục sinh ra khi build như `build` và `.dart_tool`, rồi nén thành file `TH1_QuanLyTaiLieu_NguyenHaiNinh.zip`, khoảng 170 KB.
>
> Ngoài ra em đã build thử được file **APK cho Android**. Thư viện SQLite được đóng gói tự động vào APK.

### 5.2. Báo cáo

🖥️ **LÀM:** Mở `BAO_CAO.md` (chế độ preview), cuộn nhanh từ đầu đến cuối.

🎤 **NÓI:**
> Báo cáo giải trình của em nằm trong file `BAO_CAO.md`, đi theo đúng 5 mục checklist: phân tích yêu cầu và sơ đồ luồng dữ liệu; kiến trúc và bảng đối chiếu với Cashew; cách cài đặt từng chức năng; chiến lược kiểm thử và kết quả; cách đóng gói. Cuối báo cáo em có ghi **cách mở rộng** hệ thống, ví dụ thêm chức năng gắn nhãn thì sửa ở những lớp nào, và các **hạn chế** còn lại.

---

## KẾT LUẬN (30 giây)

🎤 **NÓI:**
> Tóm lại, em đã hoàn thành 5 mục của checklist:
> 1. **Phân tích** 10 yêu cầu chức năng, 6 quy tắc nghiệp vụ, vẽ mô hình dữ liệu, **sơ đồ luồng dữ liệu** mức 0, mức 1 và sơ đồ tuần tự.
> 2. Tổ chức code theo **4 lớp của Cashew**: `database`, `struct`, `widgets`, `pages`. Phụ thuộc chỉ đi một chiều từ trên xuống.
> 3. Làm đủ **thêm, sửa, xoá, tìm kiếm**, có tìm không dấu, hoàn tác khi xoá, và danh sách tự cập nhật nhờ Stream.
> 4. **48 test** đều pass, trong đó có test kiến trúc **tự động phát hiện** khi các lớp bị phụ thuộc sai.
> 5. **Đóng gói** mã nguồn bằng script và viết **báo cáo** giải trình.
>
> Em cảm ơn thầy đã xem.

---

## 📌 PHỤ LỤC – NẾU THẦY HỎI THÊM
*(Kiến thức để trả lời miệng.)*

| Câu hỏi | Trả lời |
|---|---|
| Kiến trúc Cashew khác MVC / Clean Architecture thế nào? | Cashew không có lớp Repository hay ViewModel riêng. Lớp **database** vừa giữ dữ liệu vừa giữ quy tắc nghiệp vụ; giao diện đọc dữ liệu trực tiếp qua **Stream** của drift. Đơn giản hơn Clean Architecture nhưng vẫn tách rõ dữ liệu / trạng thái / giao diện. |
| drift là gì, sao không dùng sqflite? | drift là thư viện SQLite cho Dart, viết bảng bằng code Dart và **sinh code tự động** (`tables.g.dart`). Truy vấn kiểm tra kiểu lúc biên dịch và có **`.watch()` trả về Stream**, nên giao diện tự cập nhật. Cashew dùng drift nên em dùng theo. |
| Vì sao danh sách tự cập nhật mà không cần gọi làm mới? | `watchDocuments` trả về Stream. drift biết truy vấn đọc bảng `documents`; khi có lệnh ghi vào bảng đó, drift chạy lại truy vấn và phát dữ liệu mới. `StreamBuilder` nhận được thì vẽ lại. |
| Vì sao kiểm tra dữ liệu ở database mà không ở form? | Để quy tắc nằm **một chỗ**. Dù dữ liệu đến từ trang thêm, nút hoàn tác hay dữ liệu mẫu đều phải qua cùng một hàm kiểm tra. Test lớp database kiểm tra được quy tắc mà không cần giao diện. |
| Tìm kiếm không dấu làm thế nào? | Lúc lưu, tính sẵn cột `searchText` = nội dung đã chữ thường và bỏ dấu. Lúc tìm, từ khoá cũng được bỏ dấu rồi so bằng `instr`. |
| UUID là gì, sao không dùng số tự tăng? | UUID là chuỗi ngẫu nhiên gần như không bao giờ trùng. Cashew dùng UUID để đồng bộ giữa nhiều máy không bị trùng khoá; em giữ quy ước đó. |
| `insertOnConflictUpdate` là gì? | Là **UPSERT**: chưa có khoá thì thêm, có rồi thì cập nhật. Nhờ vậy một hàm dùng cho cả thêm và sửa. Em không dùng `REPLACE` như Cashew vì `REPLACE` là xoá rồi chèn lại, dễ vi phạm khoá ngoại. |
| Xoá môn học thì tài liệu của môn đó ra sao? | App hỏi: **chuyển** tài liệu sang môn khác, hoặc **xoá luôn**. Lớp database làm trong **một transaction** nên không bao giờ xoá dở dang. |
| Provider dùng để làm gì? | Chỉ để phát **danh sách môn học** cho mọi trang (chip lọc, ô chọn môn), giống `watchAllWallets.dart` của Cashew. Trạng thái còn lại dùng `setState` và Stream. |
| Test kiến trúc hoạt động thế nào? | Đọc mọi file `.dart` trong `lib`, lấy các dòng `import`, đổi đường dẫn thành tên lớp, rồi kiểm tra không có lớp dưới import lớp trên. Ngoài ra quét để giao diện không gọi thẳng `database.select`, `customStatement` hay viết câu SQL. |
| Muốn thêm chức năng mới thì sửa ở đâu? | Đi theo lớp: thêm bảng và hàm ở `database`, thông báo lỗi ở `struct`, widget dùng chung ở `widgets`, màn hình ở `pages`. Test kiến trúc tự áp dụng cho file mới. |
