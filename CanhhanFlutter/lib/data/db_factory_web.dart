import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// SQLite WebAssembly chạy trong shared worker (web/sqflite_sw.js),
/// dữ liệu được lưu bền vững trong IndexedDB của trình duyệt.
DatabaseFactory platformDatabaseFactory() => databaseFactoryFfiWeb;

Future<String> platformDatabasePath(String fileName) async => fileName;
