"""Video thuyet minh giong AI cho ung dung "Ky luat ca nhan" (~7 phut, du 5 muc checklist).

Quy trinh:
  1. python make_video.py tts        -> tao giong doc (edge-tts), ghi build/durations.json
  2. python record_demo.py           -> quay demo tren Chrome theo dung thoi luong loi thoai
  3. python make_video.py build      -> ghep slide + doan quay + giong doc -> ../KyLuatCaNhan_Demo.mp4
"""
import asyncio
import html
import json
import re
import subprocess
import sys
from pathlib import Path

import edge_tts
import imageio_ffmpeg

HERE = Path(__file__).resolve().parent
BUILD = HERE / "build"
OUT = HERE.parent / "KyLuatCaNhan_Demo.mp4"
CHROME = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
FFMPEG = imageio_ffmpeg.get_ffmpeg_exe()
VOICE = "vi-VN-HoaiMyNeural"
W, H, FPS = 1920, 1080, 30

CHECKLIST = ["Giao diện 3 màn hình", "Thêm / sửa / xóa", "Đánh dấu hoàn thành",
             "Lưu trữ SQLite", "Thống kê ngày/tuần/tháng"]

CSS = """
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;background:#0f1a1a;color:#e8f0ef;font-family:'Segoe UI',sans-serif;overflow:hidden;position:relative}
.top{position:absolute;top:0;left:0;right:0;height:80px;display:flex;align-items:center;gap:12px;padding:0 56px;background:#142424;border-bottom:1px solid #244040}
.brand{font-weight:700;color:#7fe0d0;font-size:24px;margin-right:auto}
.step{font-size:19px;padding:8px 16px;border-radius:999px;background:#1c3131;color:#7f9d9a}
.step.on{background:#26a69a;color:#fff;font-weight:700}
.step.done{background:#1f3a2c;color:#8fe0a8}
.main{position:absolute;top:80px;left:0;right:0;bottom:0;padding:44px 80px;display:flex;flex-direction:column;justify-content:center}
h1{font-size:54px;margin-bottom:14px}
h1 small{display:block;font-size:24px;color:#7fe0d0;letter-spacing:2px;text-transform:uppercase;margin-bottom:8px}
.sub{font-size:27px;color:#a9c3bf;margin-bottom:26px}
ul{list-style:none;font-size:29px;line-height:1.5}
ul li{padding-left:34px;position:relative;margin-bottom:10px}
ul li:before{content:'';position:absolute;left:4px;top:17px;width:14px;height:14px;border-radius:4px;background:#26a69a}
pre{background:#081212;border:1px solid #244040;border-radius:14px;padding:20px 24px;font-family:Consolas,monospace;font-size:21px;line-height:1.45;color:#d6e6e3;white-space:pre}
.c{color:#6a8a86;font-style:italic}
.cols{display:flex;gap:44px}.cols>*{flex:1}
.card{background:#142424;border:1px solid #244040;border-radius:16px;padding:22px 28px}
.card h3{font-size:26px;color:#7fe0d0;margin-bottom:12px}
.phone{position:absolute;left:200px;top:96px;width:476px;height:974px;border-radius:40px;background:#000;border:2px solid #2e4a48}
.side{position:absolute;left:780px;top:80px;right:70px;bottom:0;display:flex;flex-direction:column;justify-content:center}
.big-check{font-size:38px;line-height:1.75}
.big-check div:before{content:'✔';color:#8fe0a8;margin-right:20px}
"""

# Vi tri dat doan quay trong khung "dien thoai" (824x1784 -> 452x978)
PHONE_X, PHONE_Y, PHONE_W, PHONE_H = 212, 94 + 12, 452, 978


def page(step, body):
    chips = []
    for i, name in enumerate(CHECKLIST, 1):
        cls = "on" if i == step else ("done" if (step and i < step) or step == 99 else "")
        chips.append(f'<div class="step {cls}">{i}. {html.escape(name)}</div>')
    return (f"<!doctype html><html lang='vi'><head><meta charset='utf-8'><style>{CSS}</style></head>"
            f"<body><div class='top'><div class='brand'>Kỷ luật cá nhân · Flutter</div>{''.join(chips)}</div>"
            f"{body}</body></html>")


def slide(body):
    return f"<div class='main'>{body}</div>"


def demo_panel(title, small, bullets):
    lis = "".join(f"<li>{b}</li>" for b in bullets)
    return (f"<div class='phone'></div><div class='side'><h1><small>{small}</small>{title}</h1>"
            f"<ul>{lis}</ul></div>")


def code(src):
    out = html.escape(src)
    out = re.sub(r"(//[^\n]*)", r"<span class='c'>\1</span>", out)
    return f"<pre>{out}</pre>"


SCENES = [
    dict(id="intro", step=0, body=slide(f"""
<h1 style="font-size:70px">Ứng dụng Kỷ luật cá nhân</h1>
<p class="sub" style="font-size:32px">Theo dõi và rèn luyện thói quen hằng ngày · Flutter · Provider · SQLite</p>
<div class="cols"><div class="card"><h3>Checklist 5 mục</h3><ul>
{''.join(f'<li>{i}. {c}</li>' for i, c in enumerate(CHECKLIST, 1))}</ul></div>
<div class="card"><h3>Demo</h3><ul><li>Chạy trực tiếp trên trình duyệt Chrome (Flutter web)</li>
<li>Cùng mã nguồn build được cho Android</li><li>9 unit test cho CSDL và thống kê</li></ul></div></div>"""),
         say="""Xin chào thầy cô. Em xin trình bày ứng dụng Kỷ luật cá nhân, một ứng dụng Flutter giúp theo dõi
         và rèn luyện thói quen hằng ngày. Em sẽ giới thiệu ngắn kiến trúc, rồi demo trực tiếp trên trình duyệt
         Chrome lần lượt 5 mục trong checklist: giao diện ba màn hình, thêm sửa xóa thói quen, đánh dấu hoàn thành,
         lưu trữ bằng SQLite, và thống kê theo ngày, tuần, tháng."""),

    dict(id="arch", step=0, body=slide("""
<h1><small>Kiến trúc</small>Cấu trúc mã nguồn</h1>
<div class="cols"><pre>lib/
├─ main.dart, app.dart      <span class='c'>// khởi tạo CSDL, Provider</span>
├─ models/habit.dart        <span class='c'>// lớp Habit</span>
├─ data/habit_database.dart <span class='c'>// đọc ghi SQLite</span>
├─ providers/habit_provider.dart
├─ services/
│   ├─ stats_service.dart   <span class='c'>// tỷ lệ, chuỗi ngày</span>
│   └─ reminder_service.dart<span class='c'>// nhắc nhở</span>
├─ screens/  today · habit_form · stats
└─ widgets/  habit_tile · day_strip · ...
test/  9 unit test</pre>
<div class="card"><h3>Luồng dữ liệu</h3><ul style="font-size:26px">
<li>Giao diện gọi hàm của <b>HabitProvider</b></li>
<li>Provider ghi xuống <b>SQLite</b> trước</li>
<li>Rồi gọi <b>notifyListeners()</b> → giao diện vẽ lại</li>
<li><b>StatsService</b>: Dart thuần, dễ test</li></ul></div></div>"""),
         say="""Mã nguồn chia theo lớp. Thư mục screens và widgets là giao diện. HabitProvider dùng thư viện Provider
         với ChangeNotifier để quản lý state: mỗi thao tác được ghi xuống SQLite trước, rồi gọi notifyListeners để
         giao diện tự vẽ lại. HabitDatabase lo đọc ghi cơ sở dữ liệu, StatsService là lớp Dart thuần tính tỷ lệ
         hoàn thành và chuỗi ngày, còn ReminderService phụ trách nhắc nhở."""),

    dict(id="tour", step=1, demo="main", body=demo_panel("Giao diện người dùng", "Mục 1", [
        "Màn hình <b>danh sách thói quen</b>: dải 7 ngày, thẻ tiến độ, thẻ thói quen",
        "Màn hình <b>thêm / sửa thói quen</b>", "Màn hình <b>thống kê tiến độ</b>",
        "Material 3, mỗi thói quen có màu và biểu tượng riêng"]),
         say="""Mục 1, giao diện người dùng. Lần đầu mở ứng dụng, danh sách đang trống và có lời hướng dẫn.
         Em bấm Dùng dữ liệu mẫu để nạp 4 thói quen kèm lịch sử 60 ngày. Màn hình danh sách gồm dải 7 ngày gần nhất,
         thẻ tiến độ hôm nay và các thẻ thói quen. Nút Thêm thói quen mở màn hình thêm và sửa.
         Tab Thống kê ở thanh điều hướng dưới là màn hình thứ ba."""),

    dict(id="crud_code", step=2, body=slide("""
<h1><small>Mục 2</small>Thêm, sửa, xóa thói quen</h1>
<div class="cols"><div class="card"><h3>Thuộc tính (bảng habits)</h3><ul style="font-size:26px">
<li>Tên (bắt buộc), mô tả</li><li>Tần suất: hằng ngày / các thứ trong tuần</li>
<li>Giờ nhắc nhở (có thể tắt)</li><li>Màu, biểu tượng, ngày bắt đầu</li></ul></div>
""" + code("""// habit_provider.dart
Future<Habit> addHabit(Habit habit) async {
  final saved = await _db.insertHabit(habit);
  _habits = [..._habits, saved];
  notifyListeners();      // vẽ lại danh sách
  _syncReminders();       // đặt lại lịch nhắc
  return saved;
}
// updateHabit -> UPDATE habits ... WHERE id = ?
// deleteHabit -> DELETE FROM habits WHERE id = ?""") + "</div>"),
         say="""Mục 2, thêm, sửa, xóa thói quen. Mỗi thói quen có tên, mô tả, tần suất hằng ngày hoặc theo các thứ
         trong tuần, giờ nhắc nhở, màu và biểu tượng. Màn hình HabitFormScreen dùng chung cho thêm và sửa.
         Khi lưu, form kiểm tra tên không được trống và phải chọn ít nhất một ngày, sau đó provider gọi insert
         hoặc update xuống bảng habits."""),

    dict(id="add", step=2, demo="main", body=demo_panel("Thêm thói quen", "Mục 2", [
        "Bỏ trống tên → báo lỗi", "Tên, mô tả", "Tần suất: ngày cụ thể T2–T6",
        "Bật nhắc nhở lúc 21:00", "Chọn màu, biểu tượng → Lưu"]),
         say="""Em bấm Thêm thói quen. Nếu bấm lưu khi chưa nhập tên, form báo lỗi ngay. Em nhập tên Đọc sách
         20 phút và phần mô tả. Ở tần suất, em chọn Ngày cụ thể rồi bỏ thứ bảy và chủ nhật. Tiếp theo bật nhắc nhở,
         nhập giờ 21 giờ, chọn màu cam và biểu tượng quyển sách, rồi bấm lưu. Thói quen mới hiện ngay trong
         danh sách, kèm tần suất và giờ nhắc."""),

    dict(id="edit", step=2, demo="main", body=demo_panel("Sửa thói quen", "Mục 2", [
        "Chạm vào thẻ → màn hình sửa, dữ liệu điền sẵn", "Đổi tên: Đọc sách 30 phút",
        "Đổi giờ nhắc: 21:30", "Gửi thử nhắc nhở", "Lưu thay đổi"]),
         say="""Để sửa, em chạm vào thẻ thói quen. Màn hình sửa đã điền sẵn dữ liệu cũ. Em đổi tên thành Đọc sách
         30 phút và đổi giờ nhắc sang 21 giờ 30. Nút Gửi thử nhắc nhở cho xem trước thông báo khi đến giờ.
         Trên Android, nhắc nhở được đặt lịch bằng flutter local notifications, còn trên web ứng dụng tự kiểm tra
         giờ mỗi 20 giây. Bấm Lưu thay đổi, thẻ được cập nhật ngay."""),

    dict(id="delete", step=2, demo="main", body=demo_panel("Xóa thói quen", "Mục 2", [
        "Vuốt thẻ sang trái (hoặc menu ⋮ → Xóa)", "Hộp thoại xác nhận",
        "Lịch sử hoàn thành bị xóa theo (ON DELETE CASCADE)"]),
         say="""Để xóa, em vuốt thẻ Thiền 10 phút sang trái. Ứng dụng hỏi xác nhận trước khi xóa, vì toàn bộ
         lịch sử hoàn thành của thói quen cũng bị xóa theo nhờ khóa ngoại ON DELETE CASCADE."""),

    dict(id="mark", step=3, demo="main", body=demo_panel("Đánh dấu hoàn thành", "Mục 3", [
        "Chạm nút tròn → tô màu, gạch tên, cập nhật %", "Chạm lại để bỏ đánh dấu",
        "Chọn hôm qua để đánh dấu bù", "Chuỗi ngày liên tiếp 🔥", "Xong hết → thẻ chúc mừng"]),
         say="""Mục 3, đánh dấu hoàn thành hằng ngày. Mỗi thẻ có một nút tròn. Chạm vào là đánh dấu xong: nút tô
         màu, tên thói quen được gạch ngang, và thẻ tiến độ phía trên cập nhật phần trăm ngay. Chạm lại lần nữa để
         bỏ đánh dấu. Em cũng có thể chọn ngày hôm qua trong dải 7 ngày để đánh dấu bù. Khi hoàn thành tất cả thói
         quen của hôm nay, thẻ tiến độ chuyển sang màu cam chúc mừng."""),

    dict(id="mark_code", step=3, body=slide("""
<h1><small>Mục 3</small>Đánh dấu hoàn thành: code</h1>
<div class="cols">""" + code("""// habit_provider.dart
Future<void> toggle(Habit habit, DateTime day) async {
  final done = !isDone(habit, day);
  await _db.setCompleted(habit.id!, day, done);
  // done  -> INSERT INTO completions(habit_id, date)
  // !done -> DELETE FROM completions WHERE ...
  ...
  notifyListeners();
}""") + """<div class="card"><h3>Bảng completions</h3><ul style="font-size:26px">
<li>(habit_id, date) là khóa chính → mỗi ngày ghi nhận 1 lần</li>
<li>Chuỗi ngày: đếm lùi các ngày có lịch đã hoàn thành</li>
<li>Hôm nay chưa làm thì chưa tính là đứt chuỗi</li></ul></div></div>"""),
         say="""Về code, hàm toggle trong provider thêm hoặc xóa một dòng trong bảng completions gồm mã thói quen
         và ngày. Khóa chính là cặp hai cột này nên mỗi ngày chỉ ghi nhận một lần. Chuỗi ngày, biểu tượng ngọn lửa,
         được tính bằng cách đếm lùi các ngày có lịch đã hoàn thành."""),

    dict(id="storage", step=4, body=slide("""
<h1><small>Mục 4</small>Lưu trữ dữ liệu bằng SQLite</h1>
<div class="cols">""" + code("""CREATE TABLE habits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL, description TEXT,
  frequency TEXT,         -- daily | weekly
  weekdays TEXT,          -- '1,2,3,4,5'
  reminder_minutes INTEGER,
  color INTEGER, icon INTEGER, created_at TEXT);

CREATE TABLE completions (
  habit_id INTEGER REFERENCES habits(id)
           ON DELETE CASCADE,
  date TEXT,              -- yyyy-MM-dd
  PRIMARY KEY (habit_id, date));""") + """<div class="card"><h3>Thư viện sqflite</h3><ul style="font-size:26px">
<li>Android / iOS: plugin sqflite gốc</li><li>Windows: sqflite_common_ffi</li>
<li>Chrome: SQLite WebAssembly, lưu trong IndexedDB</li>
<li>Unit test: đóng rồi mở lại CSDL, dữ liệu còn nguyên</li></ul></div></div>"""),
         say="""Mục 4, lưu trữ dữ liệu. Em dùng SQLite qua thư viện sqflite. Trên Android dùng plugin gốc, trên
         Windows dùng bản FFI, còn trên Chrome là SQLite biên dịch sang WebAssembly, lưu bền vững trong IndexedDB.
         Cơ sở dữ liệu có hai bảng: habits lưu thông tin thói quen, completions lưu từng lần hoàn thành."""),

    dict(id="persist", step=4, demo="persist", body=demo_panel("Tắt và mở lại ứng dụng", "Mục 4", [
        "Đóng hẳn trình duyệt", "Mở lại ứng dụng",
        "Thói quen đã thêm, sửa, xóa và các dấu hoàn thành vẫn còn nguyên"]),
         say="""Bây giờ em tắt hẳn trình duyệt rồi mở lại ứng dụng. Thói quen vừa thêm và sửa, thói quen đã xóa,
         cùng các dấu hoàn thành hôm nay vẫn giữ nguyên. Dữ liệu không bị mất khi tắt ứng dụng."""),

    dict(id="stats_code", step=5, body=slide("""
<h1><small>Mục 5</small>Thống kê: cách tính tỷ lệ</h1>
<div class="cols">""" + code("""// stats_service.dart
PeriodStats habitDay(Habit h, DateTime day) {
  if (!h.isScheduledOn(day) || day.isAfter(today))
    return PeriodStats.zero;        // không có lịch
  return PeriodStats(isDone(h, day) ? 1 : 0, 1);
}
PeriodStats range(DateTime start, DateTime end)
  // cộng dồn mọi ngày trong khoảng
PeriodStats week(d)  => range(thứ Hai, Chủ nhật);
PeriodStats month(d) => range(ngày 1, ngày cuối);""") + """<div class="card"><h3>Tỷ lệ = đã làm / có lịch</h3><ul style="font-size:26px">
<li>Chỉ tính ngày thói quen có lịch</li><li>Bỏ qua ngày tương lai, ngày trước khi tạo</li>
<li>Một hàm range cho ngày, tuần, tháng</li></ul></div></div>"""),
         say="""Mục 5, thống kê tiến độ. Tỷ lệ hoàn thành bằng số lượt đã làm chia cho số lượt có lịch. Một lượt là
         một thói quen trong một ngày mà nó có lịch, nên thói quen tập thể dục chỉ tính vào thứ hai, tư, sáu.
         Ngày tương lai và ngày trước khi tạo thói quen được bỏ qua. Cùng một hàm range dùng cho ngày, tuần và tháng."""),

    dict(id="stats", step=5, demo="main", body=demo_panel("Màn hình thống kê", "Mục 5", [
        "<b>Ngày</b>: tỷ lệ, biểu đồ 7 ngày, chi tiết từng thói quen",
        "<b>Tuần</b>: biểu đồ T2–CN, tỷ lệ từng thói quen",
        "<b>Tháng</b>: lịch nhiệt, ô càng đậm càng hoàn thành nhiều",
        "Mũi tên để xem kỳ trước / kỳ sau", "Chuỗi kỷ lục"]),
         say="""Ở tab Thống kê, chế độ Ngày hiển thị tỷ lệ của hôm nay, biểu đồ cột 7 ngày gần nhất và chi tiết từng
         thói quen đã làm hay chưa. Bấm mũi tên để xem ngày trước. Chế độ Tuần hiển thị tỷ lệ cả tuần, biểu đồ từ
         thứ hai đến chủ nhật và tỷ lệ của từng thói quen, có thể lùi về tuần trước. Chế độ Tháng hiển thị lịch
         nhiệt: ô càng đậm thì ngày đó hoàn thành càng nhiều. Lùi về tháng trước sẽ thấy tỷ lệ của tháng trước để so
         sánh sự tiến bộ. Phía trên còn có tổng số lượt hoàn thành và chuỗi kỷ lục."""),

    dict(id="end", step=99, body=slide("""
<h1>Hoàn thành checklist</h1>
<div class="big-check" style="margin-top:20px">
<div>1. Giao diện: danh sách, thêm/sửa, thống kê</div>
<div>2. Thêm, sửa, xóa với tên, mô tả, tần suất, giờ nhắc</div>
<div>3. Đánh dấu hoàn thành hằng ngày trực quan</div>
<div>4. Lưu trữ SQLite, tắt mở lại không mất dữ liệu</div>
<div>5. Thống kê tỷ lệ theo ngày, tuần, tháng</div></div>
<p class="sub" style="margin-top:36px;font-size:30px">Em cảm ơn thầy cô đã theo dõi.</p>"""),
         say="""Như vậy ứng dụng đã đáp ứng đủ 5 mục trong checklist: giao diện ba màn hình, thêm sửa xóa thói quen
         với đủ thuộc tính, đánh dấu hoàn thành trực quan, lưu trữ bằng SQLite không mất dữ liệu khi tắt ứng dụng,
         và thống kê theo ngày, tuần, tháng. Em xin cảm ơn thầy cô đã theo dõi."""),
]


async def tts(text, out):
    text = " ".join(text.split())
    key = out.with_suffix(".txt")
    if out.exists() and key.exists() and key.read_text(encoding="utf-8") == text:
        return
    for attempt in range(10):
        try:
            await edge_tts.Communicate(text, VOICE).save(str(out))
            key.write_text(text, encoding="utf-8")
            return
        except Exception as e:
            print("  TTS loi, thu lai:", e)
            await asyncio.sleep(5 * (attempt + 1))
    raise RuntimeError("TTS that bai")


def duration(path):
    r = subprocess.run([FFMPEG, "-i", str(path)], capture_output=True, text=True)
    h, m, s = re.search(r"Duration: (\d+):(\d+):([\d.]+)", r.stderr).groups()
    return int(h) * 3600 + int(m) * 60 + float(s)


def run(args):
    subprocess.run(args, check=True, capture_output=True)


def make_tts():
    BUILD.mkdir(exist_ok=True)
    durs = {}
    total = 0
    for sc in SCENES:
        mp3 = BUILD / f"{sc['id']}.mp3"
        asyncio.run(tts(sc["say"], mp3))
        d = duration(mp3)
        durs[sc["id"]] = round(d + 0.8, 2)
        total += d + 1
        print(f"{sc['id']:>10}: {d:5.1f}s")
    (BUILD / "durations.json").write_text(json.dumps(durs, indent=1))
    print(f"tong loi thoai ~ {total / 60:.1f} phut")


def render_png(name, markup):
    h = BUILD / f"{name}.html"
    png = BUILD / f"{name}.png"
    h.write_text(markup, encoding="utf-8")
    run([CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
         "--window-size=1920,1080", f"--screenshot={png}", h.as_uri()])
    return png


def demo_clip(session, start, end, out):
    """Ghep cac khung JPEG (co moc thoi gian) trong [start, end] thanh doan video CFR."""
    fdir = BUILD / "frames" / session
    idx = json.loads((fdir / "index.json").read_text())
    sel = [f for f in idx if start <= f[0] <= end]
    before = [f for f in idx if f[0] < start]
    if before:
        sel.insert(0, [start, before[-1][1]])
    lines = []
    for i, (ts, name) in enumerate(sel):
        nxt = sel[i + 1][0] if i + 1 < len(sel) else end
        lines.append(f"file '{(fdir / name).as_posix()}'\nduration {max(nxt - max(ts, start), 0.001):.4f}\n")
    lines.append(f"file '{(fdir / sel[-1][1]).as_posix()}'\n")
    lst = BUILD / f"{out.stem}_frames.txt"
    lst.write_text("".join(lines), encoding="utf-8")
    run([FFMPEG, "-y", "-f", "concat", "-safe", "0", "-i", str(lst), "-vf",
         f"fps={FPS},scale={PHONE_W}:{PHONE_H}:flags=lanczos", "-c:v", "libx264", "-preset", "veryfast",
         "-crf", "18", "-pix_fmt", "yuv420p", str(out)])
    return end - start


def build():
    marks = json.loads((BUILD / "marks.json").read_text())
    segs = []
    for sc in SCENES:
        sid = sc["id"]
        png = render_png(sid, page(sc["step"], sc["body"]))
        mp3 = BUILD / f"{sid}.mp3"
        a = duration(mp3)
        seg = BUILD / f"seg_{sid}.mp4"
        common = ["-c:v", "libx264", "-preset", "medium", "-crf", "24", "-pix_fmt", "yuv420p", "-r", str(FPS),
                  "-c:a", "aac", "-b:a", "96k", "-ar", "44100", "-ac", "1"]
        if "demo" in sc:
            s, e = marks[sid]
            clip = BUILD / f"clip_{sid}.mp4"
            v = demo_clip(sc["demo"], s, e, clip)
            d = max(v, a + 0.8)
            run([FFMPEG, "-y", "-loop", "1", "-framerate", str(FPS), "-i", str(png), "-i", str(clip), "-i", str(mp3),
                 "-filter_complex",
                 f"[1:v]tpad=stop_mode=clone:stop_duration=60[p];[0:v][p]overlay={PHONE_X}:{PHONE_Y}:shortest=0[v];"
                 f"[2:a]adelay=300|300,apad[a]",
                 "-map", "[v]", "-map", "[a]", "-t", f"{d:.2f}", *common, str(seg)])
        else:
            d = a + 1.2
            run([FFMPEG, "-y", "-loop", "1", "-framerate", str(FPS), "-i", str(png), "-i", str(mp3),
                 "-af", "adelay=300|300,apad", "-t", f"{d:.2f}", "-tune", "stillimage", *common, str(seg)])
        segs.append(seg)
        print(f"{sid:>10}: {d:5.1f}s")
    lst = BUILD / "list.txt"
    lst.write_text("".join(f"file '{s.as_posix()}'\n" for s in segs), encoding="utf-8")
    run([FFMPEG, "-y", "-f", "concat", "-safe", "0", "-i", str(lst), "-c", "copy", "-movflags", "+faststart", str(OUT)])
    print("XONG:", OUT, f"{duration(OUT) / 60:.2f} phut")


if __name__ == "__main__":
    {"tts": make_tts, "build": build}[sys.argv[1]]()
