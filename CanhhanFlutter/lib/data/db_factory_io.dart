import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show databaseFactorySqflitePlugin;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

DatabaseFactory platformDatabaseFactory() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    return databaseFactoryFfi;
  }
  return databaseFactorySqflitePlugin;
}

/// File CSDL trong thư mục dữ liệu riêng của ứng dụng.
Future<String> platformDatabasePath(String fileName) async {
  final dir = await getApplicationSupportDirectory();
  await dir.create(recursive: true);
  return p.join(dir.path, fileName);
}
