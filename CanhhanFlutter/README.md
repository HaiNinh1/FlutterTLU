# Kỷ luật cá nhân

Ứng dụng Flutter theo dõi và rèn luyện thói quen hằng ngày (Provider + SQLite/sqflite).

- **Giao diện**: danh sách thói quen, thêm/sửa thói quen, thống kê tiến độ.
- **Thêm/sửa/xóa** thói quen: tên, mô tả, tần suất (hằng ngày / các thứ trong tuần), giờ nhắc nhở, màu, biểu tượng.
- **Đánh dấu hoàn thành** hằng ngày, đánh dấu bù 7 ngày gần nhất, chuỗi ngày liên tiếp.
- **Lưu trữ SQLite**: Android/iOS dùng sqflite, Windows dùng sqflite_common_ffi, web dùng SQLite WebAssembly (IndexedDB).
- **Thống kê** tỷ lệ hoàn thành theo ngày, tuần, tháng.

Video demo (giọng AI): [KyLuatCaNhan_Demo_4mb.mp4](KyLuatCaNhan_Demo_4mb.mp4)

## Chạy

```bash
flutter pub get
flutter run -d chrome     # hoặc thiết bị Android
flutter test              # 9 unit test
```

## Làm lại video

Trong `video/` (cần Python có `edge-tts`, `imageio-ffmpeg`, `playwright`):

```bash
python make_video.py tts      # tạo giọng đọc
flutter build web --release   # rồi phục vụ build/web ở cổng 8765
python record_demo.py         # quay demo trên Chrome
python make_video.py build    # ghép video
```
