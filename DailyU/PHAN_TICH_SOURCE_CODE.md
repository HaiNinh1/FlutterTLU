# Báo cáo: Phân tích source code và tính năng của ứng dụng Daily You

- Mã nguồn: <https://github.com/Demizo/Daily_You> (Flutter/Dart, giấy phép GPL-3.0), phiên bản `3.7.0+3007000`
- Bản đã tải về: thư mục [`src/`](src/)
- Công cụ dùng để phân tích: `git`, VS Code, `grep`/PowerShell để đếm file và tìm code, `flutter analyze`, chạy thử app trên Windows

> **Lưu ý về đề bài.** Đề bài mô tả Daily You là "YouTube client không có quảng cáo". Sau khi đọc mã nguồn, em thấy điều này **không đúng**: Daily You là ứng dụng **nhật ký cá nhân** (journal), chạy offline. README viết *"No accounts, no ads, no locked features, and no tracking"*, tức là "không quảng cáo" là đúng, nhưng app không phải YouTube client. Trong toàn bộ code không có chữ `youtube` nào và không có thư viện mạng nào (mục 4 có bằng chứng). Vì vậy ở mục 4, em phân tích cách ứng dụng **làm việc với API bên ngoài** (API hệ điều hành, plugin native) và **xử lý video đính kèm** trong nhật ký, vì đây là phần code thật sự có trong app.

## 1. Thu thập source code

| Việc | Lệnh / nguồn |
|---|---|
| Tìm mã nguồn | GitHub `Demizo/Daily_You`, README dẫn tới F-Droid, IzzyOnDroid, GitHub Releases |
| Tải về | `git clone --depth 1 https://github.com/Demizo/Daily_You.git src` |
| Cài thư viện | `flutter pub get` |
| Kiểm tra bản tải về | `pubspec.yaml`: `name: daily_you`, `version: 3.7.0+3007000`; `LICENSE.txt`: GPL-3.0 |

## 2. Cấu trúc dự án

### 2.1. Thư mục gốc

| Thư mục / file | Vai trò |
|---|---|
| `lib/` | Toàn bộ mã Dart của ứng dụng |
| `test/` (47 file `_test.dart`), `integration_test/` | Kiểm thử đơn vị, widget, tích hợp (chụp màn hình) |
| `packages/` | 4 plugin tự viết: `backup_crypto` (mã hóa AES-GCM native cho Android), `saf_transfer` (chép file qua Storage Access Framework), `share_receiver` (nhận nội dung chia sẻ từ app khác), `external_opener` (mở file bằng app ngoài) |
| `android/`, `ios/`, `linux/`, `macos/`, `windows/` | Mã riêng của từng nền tảng (app chạy được trên 5 nền tảng) |
| `assets/` | Ảnh, icon, banner |
| `fastlane/` | Mô tả và ảnh chụp để đăng lên F-Droid |
| `pubspec.yaml` | Khai báo thư viện (khoảng 60 package) |
| `l10n.yaml` | Cấu hình đa ngôn ngữ (35 tệp `.arb` trong `lib/l10n/`) |
| `flake.nix`, `snap/`, `AppImageBuilder.yml` | Môi trường phát triển bằng Nix và đóng gói cho Linux |

### 2.2. Thư mục `lib/` (không tính mã sinh tự động trong `l10n/generated/`)

Tổng cộng **215 file Dart, khoảng 34.700 dòng**.

| Thư mục | Số file | Số dòng | Nội dung |
|---|---:|---:|---|
| `lib/` (gốc) | 12 | 2.205 | `main.dart` (khởi động app, chạy nền), `config_provider.dart` (cài đặt), `notification_manager.dart`, `flashback_manager.dart`, `time_manager.dart`, `template_renderer.dart` |
| `database/` | 10 | 2.319 | `app_database.dart` (mở SQLite, tạo bảng, nâng cấp schema), các DAO (`entry_dao`, `tag_dao`, `template_dao`...), `entry_store.dart` (bộ đệm nhật ký trong RAM), `attachment_storage.dart` (lưu tệp đính kèm) |
| `models/` | 8 | 693 | Lớp dữ liệu: `Entry`, `EntryAttachment`, `Tag`, `TagCategory`, `Template`, `Flashback` |
| `providers/` | 4 | 707 | Quản lý trạng thái bằng `ChangeNotifier`: `EntriesProvider`, `EntryAttachmentsProvider`, `TagsProvider`, `TemplatesProvider` |
| `pages/` | 23 | 6.700 | Các màn hình: trang chủ, thư viện, thống kê, soạn nhật ký, xem nhật ký, ghi âm, xem tệp đính kèm, 10 trang cài đặt |
| `widgets/` | 100 | 15.524 | Thành phần giao diện: lịch, thẻ nhật ký, biểu đồ, trình phát media, hộp thoại, thanh công cụ soạn thảo |
| `layouts/` | 4 | 612 | `responsive_layout.dart`, `mobile_scaffold.dart` (thanh điều hướng) |
| `storage/` | 13 | 1.010 | Lớp trừu tượng `FileStore` cùng các cài đặt `LocalFileStore`, `SafFileStore`, `InMemoryFileStore`; đồng bộ ra thư mục ngoài |
| `stats/` | 3 | 197 | Tính chuỗi ngày liên tiếp (`streaks.dart`), thống kê theo khoảng thời gian |
| `utils/` | 39 | 5.477 | Sao lưu/khôi phục, mã hóa, xuất Markdown, nhập từ app khác (`imports/`), xử lý Markdown |

### 2.3. Kiến trúc tổng thể

```
               ┌──────────────────────── UI ───────────────────────────┐
               │ pages/ (màn hình)  ←→  widgets/ (thành phần)          │
               │ layouts/responsive_layout.dart (mobile/tablet/desktop)│
               └───────────────▲───────────────────────┬───────────────┘
                 notifyListeners│                       │ gọi hàm
               ┌───────────────┴───────────────────────▼───────────────┐
               │ providers/ (ChangeNotifier, đăng ký bằng MultiProvider)│
               │ ConfigProvider (cài đặt), ThemeModeProvider            │
               └───────────────▲───────────────────────┬───────────────┘
               ┌───────────────┴───────────────────────▼───────────────┐
               │ database/: EntryStore (cache RAM) → DAO → AppDatabase │
               │ SQLite (sqflite / sqflite_common_ffi)                 │
               │ AttachmentStorage → storage/FileStore (Local / SAF)   │
               └───────────────────────────────────────────────────────┘
```

- **Khởi động** (`main.dart:220-260`): khởi tạo `media_kit` cho video/âm thanh, đọc cài đặt (`ConfigProvider`), khởi tạo hồi tưởng, giao diện, thông báo, `AndroidAlarmManager`, `Workmanager`, rồi `runApp(MultiProvider(...))` với 6 provider.
- **Quản lý trạng thái**: mẫu Provider + Singleton (`EntriesProvider.instance`). Provider giữ danh sách đã lọc/sắp xếp, gọi `notifyListeners()` để UI vẽ lại.
- **Truy cập dữ liệu**: DAO tĩnh (`EntryDao.getAll()`, `add`, `update`, `remove`) gọi `sqflite`. `EntryStore` giữ toàn bộ nhật ký trong RAM để tìm kiếm và lọc nhanh.
- **Tách biệt nơi lưu tệp**: interface `FileStore` (`storage/file_store.dart`) có `FileStore.external(...)`: trên Android trả về `SafFileStore`, nền tảng khác trả về `LocalFileStore`. Nhờ vậy code sao lưu và đồng bộ không phụ thuộc nền tảng.
- **Giao diện thích ứng** (`layouts/responsive_layout.dart`): rộng < 500px dùng bố cục mobile, < 1100px dùng tablet, còn lại dùng desktop.

### 2.4. Cơ sở dữ liệu (SQLite, `schemaVersion = 6`)

| Bảng | Cột chính | Ghi chú |
|---|---|---|
| `entries` | `id`, `text` (Markdown), `mood`, `time_create`, `time_modified` | Mỗi nhật ký |
| `entry_attachments` | `entry_id`, `type` (`image`/`audio`/`video`), `file_path`, `rank` | Chỉ lưu **tên tệp**, nội dung tệp nằm trong thư mục `Images/`, `Audio/`, `Video/` |
| `tags`, `tag_categories` | `name`, `icon`, `color`, `tag_type` (`label` hoặc `tracker`) | Thẻ và nhóm thẻ |
| `entry_tags` | `entry_id`, `tag_id`, `value` | Gắn thẻ vào nhật ký, `value` dùng cho thẻ theo dõi (số) |
| `templates`, `template_tags` | `name`, `text` | Mẫu nhật ký và thẻ đi kèm mẫu |

Lần chạy đầu (`_createDatabase`) tạo bảng, rồi thêm mẫu mặc định, thẻ mặc định và một nhật ký chào mừng. `onUpgrade` chuyển dữ liệu từ schema cũ (ví dụ bảng `entry_images` cũ sang `entry_attachments`).

## 3. Các tính năng chính (xác định từ code)

| # | Tính năng | Code liên quan |
|---|---|---|
| 1 | Viết nhật ký bằng **Markdown**, có thanh công cụ định dạng và xem trước | `pages/edit_entry_page.dart`, `widgets/editor_action_bar/`, `utils/markdown_preview_scanner.dart`, thư viện `markdown_widget` |
| 2 | **Tâm trạng** (mood từ -2 đến 2) cho mỗi ngày | `widgets/entry_mood_picker.dart`, cột `mood` |
| 3 | **Tệp đính kèm**: ảnh, **video**, âm thanh (chụp/quay, chọn từ thư viện, **ghi âm** trong app) | `widgets/entry_attachment_actions.dart`, `pages/audio_recorder_page.dart` (`record`), `widgets/media_attachment_page.dart` |
| 4 | **Thẻ** (label) và **theo dõi** (tracker, giá trị số), nhóm thẻ, icon, màu | `models/tag.dart` (`TagType.label`, `TagType.tracker`), `pages/settings/tags_settings.dart` |
| 5 | **Mẫu nhật ký** có biến `{{date}}`, `{{time}}`, `{{date:yyyy-MM-dd}}` | `template_renderer.dart` (regex `\{\{(\w+)(?::([^}]+))?\}\}`), `pages/settings/templates_page.dart` |
| 6 | **Lịch** trên trang chủ, mỗi ngày hiện tâm trạng/ảnh bìa | `pages/home_page.dart`, `widgets/vertical_calendar.dart`, `widgets/entry_day_cell.dart` |
| 7 | **Thư viện**: tìm kiếm, sắp xếp theo ngày/tâm trạng/tracker | `pages/gallery_page.dart`, `EntriesProvider` (`searchText`, `OrderBy`, `SortOrder`) |
| 8 | **Thống kê**: chuỗi ngày liên tiếp, số từ, biểu đồ tâm trạng, giá trị tracker theo thời gian | `pages/statistics_page.dart`, `stats/streaks.dart`, `widgets/mood_summary_chart.dart`, `widgets/value_over_time_chart.dart` (`fl_chart`) |
| 9 | **Hồi tưởng** (Flashback, "Ngày này năm xưa") | `flashback_manager.dart`, `widgets/flashback_card.dart` |
| 10 | **Nhắc nhở** vào một thời điểm **ngẫu nhiên** trong khoảng giờ người dùng chọn, cùng thông báo "Ngày này năm xưa" | `main.dart:285-345` (`Random().nextInt`, `AndroidAlarmManager.oneShotAt`), `notification_manager.dart` |
| 11 | **Sao lưu/khôi phục** ra file zip, có thể **mã hóa** AES-256-GCM với khóa từ Argon2id; sao lưu tự động chạy nền | `utils/backup_restore_utils.dart`, `utils/backup_encryption.dart`, `Workmanager` trong `main.dart` |
| 12 | **Nhập từ app khác**: Daily You JSON, Daybook, Daylio, Diarium, Diaro, MyBrain, OneShot, Pixels; **xuất Markdown** | `utils/imports/import_registry.dart`, `utils/export_utils.dart` |
| 13 | **Lưu dữ liệu ở thư mục ngoài** (đồng bộ CSDL và tệp đính kèm ra thư mục người dùng chọn) | `storage/external_sync.dart`, `database/attachment_storage.dart` |
| 14 | **Khóa app** bằng mật khẩu hoặc vân tay | `widgets/auth_popup.dart` (`local_auth`), `utils/password_store.dart` |
| 15 | **Giao diện**: sáng/tối/AMOLED, màu nhấn, màu động Material You, 35 ngôn ngữ, lịch Jalali | `pages/settings/appearance_settings.dart`, `dynamic_color`, `utils/jalali_calendar_delegate.dart` |
| 16 | **Nhận chia sẻ** từ app khác (văn bản, ảnh) | `pages/share_page.dart`, plugin `packages/share_receiver` |

## 4. Tương tác với API bên ngoài và xử lý video

### 4.1. Không có YouTube API, không truy cập mạng

Bằng chứng trong code:

- `grep -ri youtube lib/` trả về **0 kết quả**.
- `pubspec.yaml` **không có** thư viện mạng nào (`http`, `dio`, `googleapis`...).
- `android/app/src/main/AndroidManifest.xml` **không xin quyền `INTERNET`**, và còn **gỡ** quyền `ACCESS_NETWORK_STATE` (`tools:node="remove"`). Quyền `INTERNET` chỉ có trong manifest `debug`/`profile`, để công cụ Flutter kết nối khi phát triển.
- Thư viện liên quan đến web duy nhất là `url_launcher`: chỉ dùng để **mở liên kết bằng trình duyệt** (trang GitHub, trang dịch thuật, ủng hộ), app không tự tải dữ liệu.

Như vậy Daily You **không gọi API web nào**. "API bên ngoài" mà app dùng là API của hệ điều hành, gọi qua plugin Flutter:

| API / dịch vụ hệ điều hành | Plugin | Dùng để |
|---|---|---|
| Camera, thư viện ảnh/video | `image_picker` | Chụp ảnh, quay video, chọn nhiều video |
| Storage Access Framework (Android) | `shared_storage`, `saf_util`, `packages/saf_transfer` | Đọc/ghi thư mục ngoài do người dùng chọn |
| Micro | `record` | Ghi âm |
| Thông báo, báo thức, tác vụ nền | `flutter_local_notifications`, `android_alarm_manager_plus`, `workmanager` | Nhắc nhở, sao lưu tự động |
| Sinh trắc học, kho bí mật | `local_auth`, `flutter_secure_storage` | Khóa app, lưu mật khẩu sao lưu |
| Bộ giải mã/nén video native | `v_video_compressor`, `fc_native_video_thumbnail`, `media_kit` | Xem mục 4.2 |

### 4.2. Quy trình xử lý video

```
Quay (ImagePicker.pickVideo camera) / chọn (pickMultiVideo)
        │  entry_attachment_actions.dart:113, :122
        ▼
PendingAttachment (tên, kích thước) → cảnh báo nếu > 20 MB   (models/attachment.dart:39)
        │
        ▼
_storeVideo (entry_attachment_actions.dart:197)
  • Android + chất lượng ≠ "không nén" → VVideoCompressor().compressVideo(...)
    với mức low / medium / high (cài đặt videoQualityLevel, mặc định medium)
  • Nén lỗi → giữ bản gốc (ghi log cảnh báo)
        │
        ▼
AttachmentStorage.createFromFile(..., AttachmentType.video)
  → lưu vào thư mục Video/ (trong app, và chép ra thư mục ngoài nếu bật đồng bộ)
  → bảng entry_attachments lưu tên tệp, type = 'video'
        │
        ├──► Ảnh thu nhỏ: VideoThumbnailCache (widgets/video_thumbnail_cache.dart)
        │      FcNativeVideoThumbnail 480×480, cache 3 tầng:
        │      RAM (5 MB) → đĩa (flutter_cache_manager, 30 ngày, 500 ảnh) → tạo mới
        │      Pool(2): tối đa 2 ảnh tạo cùng lúc; lỗi thì chờ 5 phút mới thử lại
        │
        └──► Phát video: MediaAttachmentPage (widgets/media_attachment_page.dart:96)
               VideoPlayerController.file(...), initialize() timeout 10 giây,
               trên Windows/Linux dùng backend media_kit
               (VideoPlayerMediaKit.ensureInitialized, main.dart:225)
```

Một số chi tiết đáng chú ý:

- **Nén chỉ chạy trên Android** (`Platform.isAndroid`). Desktop lưu bản gốc.
- File nén tạm được xóa trong khối `finally`, nên không để lại rác dù có lỗi.
- Khi xóa tệp đính kèm, `AttachmentStorage.deletions` phát sự kiện, `VideoThumbnailCache` nghe sự kiện đó và xóa ảnh thu nhỏ khỏi RAM và đĩa.
- Video cũng được đưa vào bản sao lưu zip; khi xuất Markdown, người dùng chọn có kèm ảnh/âm thanh/video hay không (`export_utils.dart:117`).

## 5. Tổng hợp

**Kiến trúc**: Daily You là ứng dụng Flutter đa nền tảng, chia lớp rõ ràng: UI (`pages`, `widgets`) → trạng thái (`providers`, Provider + `ChangeNotifier`) → dữ liệu (`database` gồm DAO, SQLite và `EntryStore` cache RAM) → lưu tệp (`storage`, interface `FileStore`). Phần riêng của từng nền tảng được tách vào plugin trong `packages/`.

**Điểm mạnh nhìn từ code**:

- Ưu tiên quyền riêng tư: không có quyền mạng, không có tài khoản, không quảng cáo, sao lưu có mã hóa AES-256-GCM + Argon2id.
- Dữ liệu mở: CSDL SQLite, nội dung Markdown, nhập được từ 8 định dạng, xuất Markdown.
- Xử lý media cẩn thận: nén video có phương án dự phòng, ảnh thu nhỏ cache 3 tầng và giới hạn số tác vụ chạy song song, timeout khi mở video.
- Có 47 file kiểm thử, `flutter analyze lib` không báo lỗi.

**Hạn chế**:

- Nén video chỉ có trên Android.
- Nhiều singleton (`X.instance`) làm các phần phụ thuộc chặt vào nhau, khó thay thế khi viết test.
- Không có đồng bộ đám mây sẵn trong app, người dùng phải tự trỏ thư mục ngoài vào một công cụ đồng bộ riêng.

**Về đề bài**: Daily You không phải YouTube client. Ứng dụng không dùng YouTube API, phần "xử lý video" là xử lý video do người dùng đính kèm vào nhật ký (quay, nén, tạo ảnh thu nhỏ, phát lại), như đã phân tích ở mục 4.
