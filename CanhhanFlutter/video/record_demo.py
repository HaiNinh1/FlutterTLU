"""Quay demo ung dung tren Chrome (Flutter web) bang Playwright + CDP screencast.

Chay sau khi `flutter build web` va phuc vu thu muc build/web:
    python -m http.server 8765 --bind 127.0.0.1   (trong build/web)
    python record_demo.py [--trial]

Ket qua: build/frames/<phien>/*.jpg (moi khung co moc thoi gian) + build/marks.json
(thoi diem bat dau / ket thuc cua tung canh), make_video.py dung de ghep video.
Thoi luong moi canh duoc keo dai cho bang loi thoai (build/durations.json).
"""
import argparse
import base64
import json
import shutil
import time
from pathlib import Path

from playwright.sync_api import sync_playwright

HERE = Path(__file__).resolve().parent
BUILD = HERE / "build"
FRAMES = BUILD / "frames"
URL = "http://127.0.0.1:8765/"
VIEW = {"width": 412, "height": 892}
DSF = 2

FIND_JS = """([label, exact]) => {
  let best = null;
  for (const e of document.querySelectorAll('flt-semantics, input, textarea')) {
    const r = e.getBoundingClientRect();
    if (r.width <= 0 || r.height <= 0 || r.bottom < 0 || r.top > innerHeight) continue;
    const al = (e.getAttribute('aria-label') || '').trim();
    const tx = (e.innerText || e.value || '').trim();
    const ok = exact === 'prefix' ? (al.startsWith(label) || tx.startsWith(label))
             : exact ? (al === label || tx === label)
             : (al.includes(label) || tx.includes(label));
    if (!ok) continue;
    const a = r.width * r.height;
    if (!best || a < best.a) best = {x: r.x + r.width / 2, y: r.y + r.height / 2, a, w: r.width, h: r.height};
  }
  return best;
}"""


class Recorder:
    """Ghi lai khung hinh qua CDP screencast, kem moc thoi gian (epoch)."""

    def __init__(self, page, ctx, name):
        self.page = page
        self.dir = FRAMES / name
        shutil.rmtree(self.dir, ignore_errors=True)
        self.dir.mkdir(parents=True)
        self.index = []
        self.cdp = ctx.new_cdp_session(page)
        self.cdp.on("Page.screencastFrame", self._frame)
        self.cdp.send("Page.startScreencast", {
            "format": "jpeg", "quality": 92,
            "maxWidth": VIEW["width"] * DSF, "maxHeight": VIEW["height"] * DSF,
        })

    def _frame(self, ev):
        ts = ev["metadata"].get("timestamp") or time.time()
        f = self.dir / f"{len(self.index):05}.jpg"
        f.write_bytes(base64.b64decode(ev["data"]))
        self.index.append([ts, f.name])
        try:
            self.cdp.send("Page.screencastFrameAck", {"sessionId": ev["sessionId"]})
        except Exception:
            pass

    def stop(self):
        try:
            self.cdp.send("Page.stopScreencast")
        except Exception:
            pass
        (self.dir / "index.json").write_text(json.dumps(self.index))


class Demo:
    def __init__(self, page, targets, trial):
        self.p = page
        self.targets = targets
        self.trial = trial
        self.marks = {}
        self.shot = 0

    # ------------------------------------------------------------- tien ich
    def wait(self, s):
        self.p.wait_for_timeout(int(s * 1000))

    def find(self, label, exact=True, timeout=8):
        t0 = time.time()
        while time.time() - t0 < timeout:
            b = self.p.evaluate(FIND_JS, [label, exact])
            if b:
                return b
            self.wait(0.15)
        raise RuntimeError(f"khong tim thay: {label}")

    def tap_at(self, x, y, after=0.8):
        self.p.mouse.move(x, y, steps=6)
        self.p.mouse.down()
        self.wait(0.09)
        self.p.mouse.up()
        self.p.mouse.move(1, 450)  # dua chuot ra mep de khong hien tooltip / hover
        self.wait(after)

    def tap(self, label, after=0.8, exact=True):
        b = self.find(label, exact)
        self.tap_at(b["x"], b["y"], after)

    def type(self, label, text, exact=False, clear=False):
        self.tap(label, after=0.4, exact=exact)
        if clear:
            self.p.keyboard.press("Control+A")
            self.wait(0.2)
        self.p.keyboard.type(text, delay=55)
        self.wait(0.5)
        self.blur()

    def blur(self):
        """Bo focus o nhap lieu de cu click tiep theo khong bi nuot."""
        self.p.evaluate("() => document.activeElement && document.activeElement.blur()")
        self.wait(0.4)

    def switch_on(self, label):
        js = """(l) => { const e = [...document.querySelectorAll('flt-semantics[role=switch]')]
            .find(e => (e.getAttribute('aria-label') || '').includes(l));
            return e ? e.getAttribute('aria-checked') : null; }"""
        for _ in range(3):
            if self.p.evaluate(js, label) == "true":
                return
            self.tap(label, after=1, exact=False)
        if self.p.evaluate(js, label) != "true":
            raise RuntimeError("khong bat duoc cong tac " + label)

    def scroll(self, dy, x=206, y=520, step=60):
        self.p.mouse.move(x, y)
        n = max(1, abs(dy) // step)
        for _ in range(n):
            self.p.mouse.wheel(0, step if dy > 0 else -step)
            self.wait(0.03)
        self.wait(0.8)

    def scroll_to(self, label, exact=False, y_target=420):
        """Cuon cho den khi nhan nam gan vi tri y_target."""
        for _ in range(12):
            b = self.p.evaluate(FIND_JS, [label, exact])
            if b and abs(b["y"] - y_target) < 140:
                return
            dy = 300 if (not b or b["y"] > y_target) else -300
            self.scroll(dy)
        self.wait(0.3)

    def swipe_left(self, label, dist=300):
        b = self.find(label, exact="prefix")
        x, y = b["x"] - 60, b["y"]
        self.p.mouse.move(x, y)
        self.p.mouse.down()
        for i in range(1, 25):
            self.p.mouse.move(x - dist * i / 24, y)
            self.wait(0.025)
        self.p.mouse.up()
        self.wait(0.6)

    def set_time(self, hh, mm):
        self.find("Chọn giờ nhắc nhở", exact=False)
        for label, v in [("Giờ", hh), ("Phút", mm)]:
            self.tap(label, after=0.3)
            self.p.keyboard.press("Control+A")
            self.p.keyboard.type(v, delay=150)
            self.wait(0.7)
        self.blur()
        self.tap("OK", after=1.2)

    def snap(self, tag):
        if self.trial:
            self.shot += 1
            self.p.screenshot(path=str(BUILD / f"trial_{self.shot:02}_{tag}.png"))

    def scene(self, name, body):
        print("canh", name, flush=True)
        self.wait(0.3)
        t0 = time.time()
        body()
        used = time.time() - t0
        target = self.targets.get(name, 0)
        print(f"  thao tac {used:.1f}s / loi thoai {target:.1f}s", flush=True)
        if used < target:
            self.wait(target - used)
        self.marks[name] = [t0, time.time()]
        self.snap(name)


def today_days():
    import datetime as dt
    t = dt.date.today()
    return t, t - dt.timedelta(days=1)


def ddmmyyyy(d):
    return d.strftime("%d/%m/%Y")


def run_main(d: Demo):
    today, yesterday = today_days()

    def tour():
        d.wait(3)
        d.tap("Dùng dữ liệu mẫu", after=3.5)
        d.tap("Thêm thói quen", after=3)
        d.snap("form")
        d.tap("Quay lại", after=2)
        d.tap("Thống kê", after=4)
        d.tap("Hôm nay", after=2)

    def add():
        d.tap("Thêm thói quen", after=1.5)
        d.tap("Thêm thói quen", after=2.2)  # nut luu o cuoi form, chua nhap ten -> loi
        d.snap("error")
        d.type("Tên thói quen", "Đọc sách 20 phút")
        d.type("Mô tả", "Đọc trước khi ngủ, ít nhất 20 trang")
        d.tap("Ngày cụ thể", after=1.2, exact=False)
        for wd, label in [(5, "T7"), (6, "CN")]:
            if today.weekday() != wd:
                d.tap(label, after=0.7)
        d.snap("weekdays")
        d.scroll_to("Bật nhắc nhở")
        d.switch_on("Bật nhắc nhở")
        d.tap("Giờ nhắc", after=1.5, exact=False)
        d.snap("timepicker")
        d.set_time("21", "00")
        d.scroll_to("Biểu tượng 5", y_target=560)
        d.tap("Màu 3", after=0.8)
        d.tap("Biểu tượng 5", after=1.2)
        d.snap("filled")
        d.tap("Thêm thói quen", after=3)

    def edit():
        d.wait(1)
        d.scroll_to("Đọc sách 20 phút", y_target=450)
        d.tap("Đọc sách 20 phút", after=1.8, exact="prefix")
        d.type("Tên thói quen", "Đọc sách 30 phút", clear=True)
        d.scroll_to("Giờ nhắc")
        d.tap("Giờ nhắc", after=1.5, exact=False)
        d.set_time("21", "30")
        d.tap("Gửi thử nhắc nhở", after=5, exact=False)
        d.snap("banner")
        d.tap("ĐÃ HIỂU", after=1)
        d.tap("Lưu thay đổi", after=3, exact=False)

    def delete():
        d.scroll_to("Thiền 10 phút", y_target=450)
        d.wait(0.5)
        d.swipe_left("Thiền 10 phút")
        d.wait(2)
        d.snap("confirm")
        d.tap("Xóa", after=3)

    def mark():
        d.scroll(-2000)
        d.wait(0.5)
        d.tap("Hoàn thành Dậy sớm", after=2.2, exact=False)
        d.tap("Hoàn thành Uống đủ", after=2.2, exact=False)
        d.tap("Bỏ đánh dấu Uống đủ", after=1.8, exact=False)
        d.tap("Hoàn thành Uống đủ", after=1.8, exact=False)
        d.tap("Ngày " + ddmmyyyy(yesterday), after=2.5)
        d.snap("yesterday")
        # danh dau bu thoi quen dau tien chua lam hom qua
        b = d.p.evaluate(FIND_JS, ["Hoàn thành ", False])
        if b:
            d.tap_at(b["x"], b["y"], after=2.2)
        d.tap("Ngày " + ddmmyyyy(today), after=2)
        for _ in range(4):
            b = d.p.evaluate(FIND_JS, ["Hoàn thành ", False])
            if not b:
                break
            d.tap_at(b["x"], b["y"], after=1.8)
        d.wait(2)

    def stats():
        d.tap("Thống kê", after=1.5)
        d.tap("Ngày", after=3.5)
        d.scroll_to("Chi tiết trong ngày", y_target=300)
        d.wait(3)
        d.scroll(-2000)
        d.tap("Kỳ trước", after=3)
        d.tap("Tuần", after=4)
        d.scroll_to("Tỷ lệ theo từng thói quen", y_target=300)
        d.wait(4)
        d.scroll(-2000)
        d.tap("Kỳ trước", after=3)
        d.tap("Tháng", after=3)
        d.scroll_to("Lịch hoàn thành trong tháng", y_target=200)
        d.wait(3.5)
        d.scroll(-2000)
        d.tap("Kỳ trước", after=3.5)
        d.tap("Kỳ sau", after=2)

    for name, fn in [("tour", tour), ("add", add), ("edit", edit), ("delete", delete),
                     ("mark", mark), ("stats", stats)]:
        d.scene(name, fn)
    d.tap("Hôm nay", after=1.5)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--trial", action="store_true", help="chay thu, chup anh tung buoc")
    a = ap.parse_args()
    BUILD.mkdir(exist_ok=True)
    dur_file = BUILD / "durations.json"
    targets = json.loads(dur_file.read_text()) if dur_file.exists() and not a.trial else {}
    profile = BUILD / "chrome_profile"
    shutil.rmtree(profile, ignore_errors=True)

    with sync_playwright() as pw:
        def launch():
            ctx = pw.chromium.launch_persistent_context(
                str(profile), channel="chrome", headless=True,
                viewport=VIEW, device_scale_factor=DSF, locale="vi-VN")
            page = ctx.pages[0] if ctx.pages else ctx.new_page()
            return ctx, page

        # ---- phien 1: lan dau mo ung dung (xoa du lieu cu), demo muc 1, 2, 3, 5
        ctx, page = launch()
        rec = Recorder(page, ctx, "main")
        page.goto(URL + "?reset=1&touches=1")
        page.wait_for_selector("flt-semantics", state="attached", timeout=60000)
        d = Demo(page, targets, a.trial)
        d.find("Dùng dữ liệu mẫu", timeout=30)
        run_main(d)
        rec.stop()
        marks = d.marks
        ctx.close()  # tat han trinh duyet

        # ---- phien 2: mo lai trinh duyet voi cung ho so -> du lieu van con (muc 4)
        ctx, page = launch()
        rec = Recorder(page, ctx, "persist")
        d = Demo(page, targets, a.trial)
        t0 = time.time()
        d.wait(1.5)
        page.goto(URL + "?touches=1")
        d.find("Thống kê", timeout=60)
        d.wait(max(6, targets.get("persist", 0) - (time.time() - t0)))
        marks["persist"] = [t0, time.time()]
        d.snap("persist")
        rec.stop()
        ctx.close()

    (BUILD / "marks.json").write_text(json.dumps(marks, indent=1))
    print("XONG", json.dumps({k: round(v[1] - v[0], 1) for k, v in marks.items()}))


if __name__ == "__main__":
    main()
