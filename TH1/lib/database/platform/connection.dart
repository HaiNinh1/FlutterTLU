import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Mở kết nối SQLite trên thiết bị (Android/Windows), giống
// budget/lib/database/platform/native.dart của Cashew.
QueryExecutor openConnection(String name) {
  return LazyDatabase(() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, '$name.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
