// Chọn cách mở SQLite theo nền tảng (import có điều kiện):
// * Android / iOS: plugin sqflite gốc.
// * Windows / Linux / macOS: SQLite qua FFI.
// * Web (Chrome): SQLite biên dịch sang WebAssembly, lưu trong IndexedDB.
export 'db_factory_io.dart' if (dart.library.js_interop) 'db_factory_web.dart';
