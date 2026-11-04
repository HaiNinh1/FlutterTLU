"""Tao video thuyet minh "Phan tich source code Daily You" (slide + giong AI).

Chay:  <python co edge-tts va imageio-ffmpeg> make_video.py [--voice vi-VN-NamMinhNeural]
Ket qua: ../DailyYou_PhanTich_SourceCode.mp4
"""
import argparse
import asyncio
import html
import json
import re
import subprocess
from pathlib import Path

import edge_tts
import imageio_ffmpeg

HERE = Path(__file__).resolve().parent
BUILD = HERE / "build"
OUT = HERE.parent / "DailyYou_PhanTich_SourceCode.mp4"
CHROME = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
FFMPEG = imageio_ffmpeg.get_ffmpeg_exe()
RATE = "+0%"  # toc do doc

CHECKLIST = [
    "Thu thập source code",
    "Cấu trúc dự án",
    "Các tính năng chính",
    "API bên ngoài & xử lý video",
    "Báo cáo tổng hợp",
]

CSS = """
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;background:#0f1420;color:#e8ecf4;
 font-family:'Segoe UI',system-ui,sans-serif;overflow:hidden;position:relative}
.top{position:absolute;top:0;left:0;right:0;height:84px;display:flex;align-items:center;
 padding:0 64px;background:#151c2c;border-bottom:1px solid #26314a;gap:14px}
.brand{font-weight:700;color:#8fb4ff;font-size:24px;margin-right:auto}
.step{font-size:19px;padding:8px 16px;border-radius:999px;background:#1d2638;color:#7d8aa5;white-space:nowrap}
.step.on{background:#3a6df0;color:#fff;font-weight:600}
.step.done{background:#1f3a2c;color:#7fdca4}
.main{position:absolute;top:84px;left:0;right:0;bottom:0;padding:40px 72px 56px;display:flex;flex-direction:column;justify-content:center}
h1{font-size:54px;font-weight:700;margin-bottom:10px;letter-spacing:-.5px}
h1 small{display:block;font-size:24px;color:#8fb4ff;font-weight:600;letter-spacing:2px;
 text-transform:uppercase;margin-bottom:10px}
.sub{font-size:26px;color:#a9b4c9;margin-bottom:30px}
table{border-collapse:collapse;width:100%;font-size:26px}
th{text-align:left;color:#8fb4ff;font-weight:600;padding:10px 14px;border-bottom:2px solid #2c3854}
td{padding:9px 14px;border-bottom:1px solid #222c42;vertical-align:top}
td.n{text-align:right;font-variant-numeric:tabular-nums;color:#ffd479}
code,.mono{font-family:'Cascadia Code',Consolas,monospace}
td code{color:#9fe0b8;font-size:21px}
ul{list-style:none;font-size:28px;line-height:1.5}
ul li{padding-left:36px;position:relative;margin-bottom:12px}
ul li:before{content:'';position:absolute;left:4px;top:17px;width:14px;height:14px;
 border-radius:4px;background:#3a6df0}
pre{background:#0a0e17;border:1px solid #26314a;border-radius:14px;padding:22px 26px;
 font-family:'Cascadia Code',Consolas,monospace;font-size:21px;line-height:1.45;color:#d6deeb;white-space:pre}
.k{color:#c792ea}.s{color:#ecc48d}.c{color:#637777;font-style:italic}.f{color:#82aaff}
.cols{display:flex;gap:48px}.cols>*{flex:1}
.card{background:#151c2c;border:1px solid #26314a;border-radius:16px;padding:24px 28px}
.card h3{font-size:26px;color:#8fb4ff;margin-bottom:12px}
.note{background:#2a2112;border:1px solid #6b5520;color:#ffd98a;border-radius:14px;
 padding:18px 24px;font-size:24px;line-height:1.45}
.ok{color:#7fdca4;font-weight:700}
.bad{color:#ff8a8a;font-weight:700}
img.shot{border-radius:14px;border:1px solid #2c3854;width:100%}
.flow{display:flex;flex-direction:column;gap:12px}
.box{background:#151c2c;border:1px solid #2c3854;border-left:6px solid #3a6df0;
 border-radius:12px;padding:14px 22px;font-size:23px;line-height:1.4}
.box b{color:#8fb4ff}.box .mono{color:#9fe0b8;font-size:20px}
.arrow{text-align:center;color:#3a6df0;font-size:22px;line-height:1}
.big-check{font-size:40px;line-height:1.7}
.big-check div:before{content:'✔';color:#7fdca4;margin-right:22px}
"""


def page(active, body):
    steps = []
    for i, name in enumerate(CHECKLIST, 1):
        cls = "on" if i == active else ("done" if active and i < active or active == 99 else "")
        steps.append(f'<div class="step {cls}">{i}. {html.escape(name)}</div>')
    return (
        f"<!doctype html><html lang='vi'><head><meta charset='utf-8'><style>{CSS}</style></head>"
        f"<body><div class='top'><div class='brand'>Daily You · Phân tích source code</div>"
        f"{''.join(steps)}</div><div class='main'>{body}</div></body></html>"
    )


def code(src):
    """To mau rat don gian cho doan code Dart."""
    out = html.escape(src)
    out = re.sub(r"(//[^\n]*)", r"<span class='c'>\1</span>", out)
    out = re.sub(r"(&#x27;[^&\n]*&#x27;)", r"<span class='s'>\1</span>", out)
    out = re.sub(r"\b(final|await|async|static|Future|return|if|try|catch|finally|null|const)\b",
                 r"<span class='k'>\1</span>", out)
    return f"<pre>{out}</pre>"


IMG = (HERE / "anh").as_uri()

SLIDES = [
    # ---------------------------------------------------------------- mo dau
    dict(step=0, body=f"""
<h1 style="font-size:72px;margin-top:60px">Phân tích Source Code<br>và Tính năng của ứng dụng Daily You</h1>
<p class="sub" style="font-size:30px;margin:26px 0 50px">Flutter / Dart · GitHub <span class="mono">Demizo/Daily_You</span> · phiên bản 3.7.0 · GPL-3.0</p>
<div class="cols"><div class="card"><h3>Checklist 5 mục</h3><ul>
{''.join(f'<li>{i}. {c}</li>' for i, c in enumerate(CHECKLIST, 1))}</ul></div>
<div class="card"><h3>Công cụ phân tích</h3><ul>
<li>git clone, flutter pub get</li><li>VS Code: đọc code, tìm kiếm</li>
<li>Đếm file và dòng code bằng script</li><li>flutter analyze, chạy thử trên Windows</li></ul></div></div>
""", say="""Xin chào thầy cô. Em xin trình bày bài phân tích source code và tính năng của ứng dụng Daily You, gồm đủ 5 mục trong checklist."""),

    # ---------------------------------------------------------------- muc 1
    dict(step=1, body="""
<h1><small>Mục 1</small>Tìm kiếm và thu thập source code</h1>
<p class="sub">Nguồn mở trên GitHub, phát hành qua F-Droid, IzzyOnDroid và GitHub Releases</p>
<pre><span class='c'># tải mã nguồn</span>
git clone --depth 1 https://github.com/Demizo/Daily_You.git src
cd src
flutter pub get                <span class='c'># tải khoảng 60 thư viện trong pubspec.yaml</span>

<span class='c'># kiểm tra bản tải về</span>
pubspec.yaml   name: daily_you   version: 3.7.0+3007000
LICENSE.txt    GNU General Public License v3.0</pre>
<div class="note" style="margin-top:28px">Lưu ý: đề bài gọi Daily You là "YouTube client". Đọc code cho thấy đây thực chất là
<b>ứng dụng nhật ký cá nhân</b>, chạy offline, <b>không quảng cáo</b>. Không có YouTube API nào trong code (bằng chứng ở mục 4).</div>
""", say="""Mục 1, thu thập source code. Daily You là dự án mã nguồn mở trên GitHub của tác giả Demizo, viết bằng Flutter, giấy phép GPL 3. Em tải về bằng git clone rồi chạy flutter pub get. Lưu ý: đề bài gọi đây là YouTube client, nhưng đọc code cho thấy Daily You là ứng dụng nhật ký cá nhân, không quảng cáo và không dùng YouTube API."""),

    # ---------------------------------------------------------------- muc 2a
    dict(step=2, body="""
<h1><small>Mục 2</small>Cấu trúc dự án: thư mục gốc</h1>
<table style="margin-top:20px">
<tr><th style="width:30%">Thư mục / file</th><th>Vai trò</th></tr>
<tr><td><code>lib/</code></td><td>Toàn bộ mã Dart của ứng dụng: 215 file, khoảng 34.700 dòng</td></tr>
<tr><td><code>test/</code>, <code>integration_test/</code></td><td>47 file kiểm thử đơn vị, widget và tích hợp</td></tr>
<tr><td><code>packages/</code></td><td>4 plugin tự viết: <code>backup_crypto</code>, <code>saf_transfer</code>, <code>share_receiver</code>, <code>external_opener</code></td></tr>
<tr><td><code>android/ ios/ linux/ macos/ windows/</code></td><td>Mã riêng cho 5 nền tảng</td></tr>
<tr><td><code>pubspec.yaml</code></td><td>Khai báo khoảng 60 thư viện: sqflite, provider, media_kit, video_player...</td></tr>
<tr><td><code>l10n.yaml</code>, <code>lib/l10n/</code></td><td>Đa ngôn ngữ với 35 tệp ARB</td></tr>
<tr><td><code>assets/</code>, <code>fastlane/</code></td><td>Hình ảnh, icon; mô tả và ảnh chụp để đăng lên F-Droid</td></tr>
<tr><td><code>flake.nix</code>, <code>snap/</code></td><td>Môi trường phát triển bằng Nix, đóng gói cho Linux</td></tr>
</table>
""", say="""Mục 2, cấu trúc dự án. Thư mục lib chứa toàn bộ mã Dart, gồm 215 file. Thư mục test có 47 file kiểm thử, packages có 4 plugin tự viết, và ứng dụng có mã riêng cho 5 nền tảng."""),

    # ---------------------------------------------------------------- muc 2b
    dict(step=2, body="""
<h1><small>Mục 2</small>Thư mục <span class="mono">lib/</span></h1>
<table style="margin-top:14px">
<tr><th style="width:17%">Thư mục</th><th style="width:7%">File</th><th style="width:9%">Dòng</th><th>Nội dung chính</th></tr>
<tr><td><code>lib/</code> (gốc)</td><td class="n">12</td><td class="n">2.205</td><td><code>main.dart</code> khởi động app, <code>config_provider</code>, thông báo, hồi tưởng</td></tr>
<tr><td><code>database/</code></td><td class="n">10</td><td class="n">2.319</td><td>Mở SQLite, tạo bảng, các DAO, <code>EntryStore</code> (cache RAM), lưu tệp đính kèm</td></tr>
<tr><td><code>models/</code></td><td class="n">8</td><td class="n">693</td><td><code>Entry</code>, <code>EntryAttachment</code>, <code>Tag</code>, <code>Template</code>, <code>Flashback</code></td></tr>
<tr><td><code>providers/</code></td><td class="n">4</td><td class="n">707</td><td>Quản lý trạng thái bằng <code>ChangeNotifier</code></td></tr>
<tr><td><code>pages/</code></td><td class="n">23</td><td class="n">6.700</td><td>Các màn hình: trang chủ, thư viện, thống kê, soạn nhật ký, cài đặt</td></tr>
<tr><td><code>widgets/</code></td><td class="n">100</td><td class="n">15.524</td><td>Lịch, biểu đồ, trình phát media, hộp thoại, thanh công cụ soạn thảo</td></tr>
<tr><td><code>storage/</code></td><td class="n">13</td><td class="n">1.010</td><td>Interface <code>FileStore</code>: Local, SAF (Android), InMemory</td></tr>
<tr><td><code>utils/</code></td><td class="n">39</td><td class="n">5.477</td><td>Sao lưu, mã hóa, xuất Markdown, nhập dữ liệu từ 8 ứng dụng khác</td></tr>
<tr><td><code>layouts/</code>, <code>stats/</code></td><td class="n">7</td><td class="n">809</td><td>Bố cục thích ứng; tính chuỗi ngày, thống kê</td></tr>
</table>
""", say="""Trong lib, widgets là thư mục lớn nhất với 100 file giao diện. Pages chứa 23 màn hình, database lo phần SQLite, models là các lớp dữ liệu, providers quản lý trạng thái, còn utils lo sao lưu, mã hóa, nhập và xuất dữ liệu."""),

    # ---------------------------------------------------------------- muc 2c
    dict(step=2, body="""
<h1><small>Mục 2</small>Kiến trúc phân lớp</h1>
<div class="cols" style="margin-top:20px">
<div class="flow">
<div class="box"><b>UI</b>: <span class="mono">pages/</span> + <span class="mono">widgets/</span><br>
<span class="mono">ResponsiveLayout</span>: &lt; 500px mobile · &lt; 1100px tablet · còn lại desktop</div>
<div class="arrow">▲ notifyListeners() &nbsp;&nbsp; ▼ gọi hàm</div>
<div class="box"><b>Trạng thái</b>: <span class="mono">providers/</span> (Provider + ChangeNotifier)<br>
<span class="mono">EntriesProvider</span>: tìm kiếm, lọc, sắp xếp theo ngày, tâm trạng, tracker</div>
<div class="arrow">▼</div>
<div class="box"><b>Dữ liệu</b>: <span class="mono">EntryStore</span> (cache RAM) → DAO → <span class="mono">AppDatabase</span> (SQLite)</div>
<div class="arrow">▼</div>
<div class="box"><b>Lưu tệp</b>: <span class="mono">AttachmentStorage</span> → <span class="mono">FileStore</span><br>
Android dùng <span class="mono">SafFileStore</span>, nền tảng khác dùng <span class="mono">LocalFileStore</span></div>
</div>
<div class="card"><h3>Khởi động: main.dart</h3>
""" + code("""sqfliteFfiInit();             // SQLite trên desktop
VideoPlayerMediaKit
    .ensureInitialized(windows: true);
await ConfigProvider.instance.init();
await FlashbackManager.init();
await NotificationManager.instance.init();
await Workmanager().initialize(...);
runApp(MultiProvider(providers: [
  ThemeModeProvider, EntriesProvider,
  EntryAttachmentsProvider,
  TemplatesProvider, TagsProvider,
  ConfigProvider,
]));""") + """</div></div>
""", say="""Ứng dụng chia 4 lớp: giao diện, trạng thái dùng Provider, dữ liệu dùng SQLite, và lưu tệp qua interface FileStore. Hàm main khởi tạo cơ sở dữ liệu, media kit, thông báo, rồi chạy app với 6 provider."""),

    # ---------------------------------------------------------------- muc 2d
    dict(step=2, body="""
<h1><small>Mục 2</small>Quản lý dữ liệu: SQLite (schema version 6)</h1>
<table style="margin-top:18px">
<tr><th style="width:26%">Bảng</th><th style="width:44%">Cột chính</th><th>Ghi chú</th></tr>
<tr><td><code>entries</code></td><td>id, text, mood, time_create, time_modified</td><td>Nội dung nhật ký viết bằng Markdown</td></tr>
<tr><td><code>entry_attachments</code></td><td>entry_id, type, file_path, rank</td><td>type = image / audio / <b>video</b>; chỉ lưu tên tệp</td></tr>
<tr><td><code>tags</code>, <code>tag_categories</code></td><td>name, icon, color, tag_type</td><td>Thẻ thường (label) hoặc thẻ theo dõi số (tracker)</td></tr>
<tr><td><code>entry_tags</code></td><td>entry_id, tag_id, value</td><td>Gắn thẻ vào nhật ký</td></tr>
<tr><td><code>templates</code>, <code>template_tags</code></td><td>name, text</td><td>Mẫu nhật ký</td></tr>
</table>
<div class="cols" style="margin-top:30px">
<div class="card"><h3>Lần chạy đầu</h3><ul style="font-size:24px"><li>Tạo bảng</li><li>Tạo mẫu và thẻ mặc định</li><li>Tạo nhật ký chào mừng</li></ul></div>
<div class="card"><h3>Nâng cấp</h3><ul style="font-size:24px"><li><code>onUpgrade</code> chuyển schema cũ</li><li>VD: <code>entry_images</code> → <code>entry_attachments</code></li></ul></div>
<div class="card"><h3>Tệp media</h3><ul style="font-size:24px"><li>Thư mục Images/, Audio/, Video/</li><li>Có thể đồng bộ ra thư mục ngoài</li></ul></div>
</div>
""", say="""Dữ liệu được lưu trong SQLite. Bảng entries chứa nhật ký viết bằng Markdown. Bảng entry attachments lưu tên tệp ảnh, âm thanh và video, còn tệp thật nằm trong thư mục riêng. Ngoài ra có các bảng thẻ và mẫu."""),

    # ---------------------------------------------------------------- muc 3a
    dict(step=3, body=f"""
<h1><small>Mục 3</small>Các tính năng chính (xác định từ code)</h1>
<div class="cols" style="margin-top:14px">
<table style="flex:1.5;font-size:22px">
<tr><th>Tính năng</th><th>Code</th></tr>
<tr><td>Viết nhật ký <b>Markdown</b>, xem trước</td><td><code>edit_entry_page.dart</code></td></tr>
<tr><td><b>Tâm trạng</b> 5 mức (-2 … 2)</td><td><code>entry_mood_picker.dart</code></td></tr>
<tr><td>Đính kèm <b>ảnh, video, âm thanh</b>, ghi âm</td><td><code>entry_attachment_actions.dart</code></td></tr>
<tr><td><b>Thẻ</b> và <b>tracker</b> (giá trị số)</td><td><code>models/tag.dart</code></td></tr>
<tr><td><b>Mẫu</b> có biến <code>{{{{date}}}}</code>, <code>{{{{time}}}}</code></td><td><code>template_renderer.dart</code></td></tr>
<tr><td><b>Lịch</b> trên trang chủ</td><td><code>vertical_calendar.dart</code></td></tr>
<tr><td><b>Thư viện</b>: tìm kiếm, sắp xếp</td><td><code>gallery_page.dart</code></td></tr>
<tr><td><b>Thống kê</b>: chuỗi ngày, biểu đồ</td><td><code>statistics_page.dart</code>, <code>streaks.dart</code></td></tr>
</table>
<div style="flex:1;display:flex;flex-direction:column;gap:18px">
<img class="shot" src="{IMG}/1_trang_chu.png"><img class="shot" src="{IMG}/8_thong_ke.png"></div>
</div>
""", say="""Mục 3, các tính năng chính. Ứng dụng cho phép viết nhật ký bằng Markdown, chọn tâm trạng 5 mức, đính kèm ảnh, video, âm thanh, gắn thẻ, dùng mẫu, xem lịch, tìm kiếm và xem thống kê."""),

    # ---------------------------------------------------------------- muc 3b
    dict(step=3, body="""
<h1><small>Mục 3</small>Các tính năng chính (tiếp)</h1>
<table style="margin-top:14px">
<tr><th style="width:48%">Tính năng</th><th>Code</th></tr>
<tr><td><b>Hồi tưởng</b>: "Ngày này năm xưa"</td><td><code>flashback_manager.dart</code>, <code>flashback_card.dart</code></td></tr>
<tr><td><b>Nhắc nhở</b> vào giờ ngẫu nhiên trong khoảng đã chọn</td><td><code>main.dart</code>: <code>Random()</code>, <code>AndroidAlarmManager.oneShotAt</code></td></tr>
<tr><td><b>Sao lưu / khôi phục</b> zip, mã hóa AES-256-GCM + Argon2id</td><td><code>backup_restore_utils.dart</code>, <code>backup_encryption.dart</code></td></tr>
<tr><td>Sao lưu <b>tự động chạy nền</b>, thử lại tối đa 3 lần</td><td><code>Workmanager</code> trong <code>main.dart</code></td></tr>
<tr><td><b>Nhập</b> từ 8 định dạng: Daylio, Diarium, Diaro, Daybook...</td><td><code>imports/import_registry.dart</code></td></tr>
<tr><td><b>Xuất Markdown</b>, chọn kèm loại media</td><td><code>export_utils.dart</code></td></tr>
<tr><td><b>Lưu dữ liệu ra thư mục ngoài</b> (đồng bộ)</td><td><code>storage/external_sync.dart</code></td></tr>
<tr><td><b>Khóa ứng dụng</b> bằng mật khẩu hoặc vân tay</td><td><code>auth_popup.dart</code> (<code>local_auth</code>)</td></tr>
<tr><td><b>Giao diện</b>: sáng, tối, AMOLED, Material You, 35 ngôn ngữ</td><td><code>appearance_settings.dart</code></td></tr>
</table>
""", say="""Ngoài ra còn có hồi tưởng ngày này năm xưa, nhắc nhở vào giờ ngẫu nhiên, sao lưu có mã hóa AES, nhập dữ liệu từ 8 ứng dụng khác, khóa bằng vân tay, và hỗ trợ 35 ngôn ngữ."""),

    # ---------------------------------------------------------------- muc 4a
    dict(step=4, body="""
<h1><small>Mục 4</small>Tương tác với API bên ngoài</h1>
<div class="cols" style="margin-top:14px">
<div class="card"><h3>Kiểm tra YouTube API / mạng</h3>
<pre style="font-size:20px">grep -ri youtube lib/        <span class='c'># 0 kết quả</span>
grep "http|dio|googleapis" pubspec.yaml
                             <span class='c'># 0 kết quả</span></pre>
<ul style="font-size:23px;margin-top:16px">
<li><span class="bad">Không có</span> YouTube API, không có thư viện HTTP</li>
<li>AndroidManifest: <span class="bad">không có quyền INTERNET</span>, còn gỡ <code>ACCESS_NETWORK_STATE</code></li>
<li><code>url_launcher</code> chỉ mở link bằng trình duyệt</li>
<li>Kết luận: app <span class="ok">offline hoàn toàn</span></li></ul></div>
<div><table style="font-size:22px">
<tr><th>API hệ điều hành</th><th>Plugin</th></tr>
<tr><td>Camera, thư viện ảnh/video</td><td><code>image_picker</code></td></tr>
<tr><td>Storage Access Framework</td><td><code>shared_storage</code>, <code>saf_util</code></td></tr>
<tr><td>Micro (ghi âm)</td><td><code>record</code></td></tr>
<tr><td>Thông báo, báo thức, tác vụ nền</td><td><code>flutter_local_notifications</code>, <code>workmanager</code></td></tr>
<tr><td>Vân tay, kho bí mật</td><td><code>local_auth</code>, <code>flutter_secure_storage</code></td></tr>
<tr><td>Nén, ảnh thu nhỏ, phát video</td><td><code>v_video_compressor</code>, <code>fc_native_video_thumbnail</code>, <code>media_kit</code></td></tr>
</table></div></div>
""", say="""Mục 4, tương tác với API bên ngoài. Tìm chữ youtube trong code cho 0 kết quả, không có thư viện mạng, và bản Android không xin quyền INTERNET. Vậy ứng dụng chạy offline. API bên ngoài mà nó dùng là API của hệ điều hành, gọi qua plugin, như camera, micro, thông báo và vân tay."""),

    # ---------------------------------------------------------------- muc 4b
    dict(step=4, body=f"""
<h1><small>Mục 4</small>Xử lý video: thêm và nén</h1>
<div class="cols" style="margin-top:10px">
<div style="flex:1.25">""" + code("""// entry_attachment_actions.dart
static Future<NewAttachment?> _storeVideo(
    String sourcePath, String? fileName) async {
  String? compressedPath;
  try {
    final quality = ConfigProvider.instance
        .get(Settings.videoQualityLevel); // mặc định medium
    if (Platform.isAndroid &&
        quality != VideoQuality.noCompression) {
      try {
        final result = await VVideoCompressor().compressVideo(
          sourcePath,
          VVideoCompressionConfig(quality: ...));
        compressedPath = result?.compressedFilePath;
      } catch (error, stackTrace) {
        // nén lỗi -> giữ bản gốc
      }
    }
    final storedPath = compressedPath ?? sourcePath;
    await AttachmentStorage.instance.createFromFile(
        ..., File(storedPath), AttachmentType.video);
  } finally {
    // xóa file nén tạm
  }
}""") + f"""</div>
<div style="flex:1"><div class="flow">
<div class="box"><b>1. Chọn / quay</b>: <span class="mono">pickMultiVideo()</span>, <span class="mono">pickVideo(camera)</span></div>
<div class="box"><b>2. Cảnh báo</b> nếu video lớn hơn 20 MB</div>
<div class="box"><b>3. Nén</b> (Android): low / medium / high, lỗi thì giữ bản gốc</div>
<div class="box"><b>4. Lưu</b> vào thư mục Video/, ghi <span class="mono">type='video'</span> vào CSDL</div>
</div><img class="shot" style="margin-top:18px" src="{IMG}/them_video.png"></div>
</div>
""", say="""Về xử lý video: người dùng chọn hoặc quay video, ứng dụng cảnh báo nếu video lớn hơn 20 megabyte. Trên Android, video được nén theo mức chất lượng đã chọn, nén lỗi thì giữ bản gốc. Sau đó video được lưu vào thư mục Video và ghi vào cơ sở dữ liệu."""),

    # ---------------------------------------------------------------- muc 4c
    dict(step=4, body=f"""
<h1><small>Mục 4</small>Xử lý video: ảnh thu nhỏ và phát lại</h1>
<div class="cols" style="margin-top:10px">
<div style="flex:1.1">
<div class="card" style="margin-bottom:20px"><h3>VideoThumbnailCache: cache 3 tầng</h3>
<ul style="font-size:23px"><li>RAM 5 MB → đĩa (30 ngày, 500 ảnh) → tạo mới bằng <code>FcNativeVideoThumbnail</code> 480×480</li>
<li><code>Pool(2)</code>: tạo tối đa 2 ảnh cùng lúc</li>
<li>Lỗi thì chờ 5 phút mới thử lại; xóa video thì xóa luôn ảnh thu nhỏ</li></ul></div>
""" + code("""// media_attachment_page.dart
final controller = VideoPlayerController.file(
    File(localPath));
controller.addListener(_onVideoValueChanged);
await controller.initialize()
    .timeout(const Duration(seconds: 10));
// Windows/Linux: backend media_kit
// main.dart: VideoPlayerMediaKit.ensureInitialized(...)""") + f"""</div>
<div style="flex:1"><img class="shot" src="{IMG}/phat_video.png">
<p class="sub" style="font-size:22px;margin-top:12px">Video đính kèm được phát bằng <span class="mono">video_player</span> + <span class="mono">media_kit</span> trên Windows</p></div>
</div>
""", say="""Ảnh thu nhỏ của video được cache 3 tầng: bộ nhớ, ổ đĩa, rồi mới tạo mới, tối đa 2 ảnh cùng lúc. Video được phát bằng video player, trên Windows dùng media kit."""),

    # ---------------------------------------------------------------- muc 5
    dict(step=5, body="""
<h1><small>Mục 5</small>Báo cáo tổng hợp</h1>
<p class="sub">File báo cáo: <span class="mono">PHAN_TICH_SOURCE_CODE.md</span></p>
<div class="cols">
<div class="card"><h3>Kiến trúc</h3><ul style="font-size:24px">
<li>Flutter đa nền tảng, 4 lớp: UI → Provider → DAO/SQLite → FileStore</li>
<li>Singleton + Provider + ChangeNotifier</li>
<li>Mã riêng của từng nền tảng tách ra plugin trong <code>packages/</code></li></ul></div>
<div class="card"><h3>Điểm mạnh</h3><ul style="font-size:24px">
<li>Riêng tư: offline, không tài khoản, không quảng cáo</li>
<li>Sao lưu mã hóa AES-256-GCM</li>
<li>Dữ liệu mở: SQLite, Markdown, nhập 8 định dạng</li>
<li>Xử lý video có dự phòng, cache, timeout</li></ul></div>
<div class="card"><h3>Hạn chế</h3><ul style="font-size:24px">
<li>Nén video chỉ có trên Android</li>
<li>Nhiều singleton làm các phần phụ thuộc chặt vào nhau, khó test</li>
<li>Không có đồng bộ đám mây sẵn</li>
<li>Không phải YouTube client như đề bài mô tả</li></ul></div>
</div>
""", say="""Mục 5, báo cáo tổng hợp, em viết trong file PHAN TICH SOURCE CODE. Điểm mạnh của ứng dụng là riêng tư, chạy offline, sao lưu có mã hóa và dữ liệu ở định dạng mở. Hạn chế là nén video chỉ có trên Android, và dùng nhiều singleton nên khó viết test."""),

    # ---------------------------------------------------------------- ket
    dict(step=99, body="""
<h1 style="margin-top:40px">Hoàn thành checklist</h1>
<div class="big-check" style="margin-top:30px">
<div>1. Tìm kiếm và thu thập source code (GitHub Demizo/Daily_You)</div>
<div>2. Phân tích cấu trúc dự án, thư mục và file chính</div>
<div>3. Xác định và liệt kê các tính năng chính từ source code</div>
<div>4. Phân tích tương tác API bên ngoài và xử lý video</div>
<div>5. Viết báo cáo tổng hợp kiến trúc và tính năng</div>
</div>
<p class="sub" style="margin-top:40px;font-size:30px">Em cảm ơn thầy cô đã xem.</p>
""", say="""Như vậy em đã hoàn thành đủ 5 mục trong checklist. Em xin cảm ơn thầy cô đã theo dõi."""),
]


async def tts(text, voice, out):
    text = " ".join(text.split())
    key = out.with_suffix(".txt")
    sig = f"{voice}\n{text}"
    if out.exists() and key.exists() and key.read_text(encoding="utf-8") == sig:
        return  # da co am thanh cho dung loi thoai nay
    for attempt in range(12):
        try:
            await edge_tts.Communicate(text, voice, rate=RATE).save(str(out))
            key.write_text(sig, encoding="utf-8")
            return
        except Exception as e:  # dich vu TTS doi khi loi tam thoi
            print("  TTS loi, thu lai:", e)
            await asyncio.sleep(min(30, 5 * (attempt + 1)))
    raise RuntimeError("TTS that bai")


def duration(path):
    r = subprocess.run([FFMPEG, "-i", str(path)], capture_output=True, text=True)
    h, m, s = re.search(r"Duration: (\d+):(\d+):([\d.]+)", r.stderr).groups()
    return int(h) * 3600 + int(m) * 60 + float(s)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--voice", default="vi-VN-HoaiMyNeural")
    ap.add_argument("--only-slides", action="store_true")
    a = ap.parse_args()
    BUILD.mkdir(exist_ok=True)
    segs = []
    for i, sl in enumerate(SLIDES):
        h = BUILD / f"s{i:02}.html"
        png = BUILD / f"s{i:02}.png"
        h.write_text(page(sl["step"], sl["body"]), encoding="utf-8")
        subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars",
                        "--force-device-scale-factor=1", "--window-size=1920,1080",
                        f"--screenshot={png}", h.as_uri()], check=True, capture_output=True)
        print("slide", i, "ok")
        if a.only_slides:
            continue
        mp3 = BUILD / f"s{i:02}.mp3"
        asyncio.run(tts(sl["say"], a.voice, mp3))
        d = duration(mp3) + 2.8
        seg = BUILD / f"s{i:02}.mp4"
        subprocess.run([FFMPEG, "-y", "-loop", "1", "-framerate", "30", "-i", str(png), "-i", str(mp3),
                        "-af", "adelay=300|300,apad", "-t", f"{d:.2f}", "-vf", "scale=1280:720:flags=lanczos", "-r", "10",
                        "-c:v", "libx264", "-preset", "slow", "-crf", "25", "-tune", "stillimage", "-pix_fmt", "yuv420p", "-g", "300",
                        "-c:a", "aac", "-b:a", "64k", "-ac", "1", "-ar", "44100", str(seg)],
                       check=True, capture_output=True)
        segs.append(seg)
        print(f"  {d:.1f}s")
    if a.only_slides:
        return
    lst = BUILD / "list.txt"
    lst.write_text("".join(f"file '{s.as_posix()}'\n" for s in segs), encoding="utf-8")
    subprocess.run([FFMPEG, "-y", "-f", "concat", "-safe", "0", "-i", str(lst), "-c", "copy",
                    "-movflags", "+faststart", str(OUT)], check=True, capture_output=True)
    print("XONG:", OUT, f"{duration(OUT):.1f}s")


if __name__ == "__main__":
    main()
