import 'package:sqflite_common/sqlite_api.dart';

import '../models/habit.dart';
import '../utils/date_utils.dart';
import 'db_factory.dart';

/// Lớp truy cập SQLite: lưu thói quen và các lần hoàn thành.
///
/// Gồm 2 bảng:
/// * `habits`: thông tin thói quen (tên, mô tả, tần suất, giờ nhắc...).
/// * `completions`: mỗi dòng là một lần hoàn thành (habit_id, ngày).
class HabitDatabase {
  HabitDatabase._(this._db);

  final Database _db;

  static const fileName = 'ky_luat_ca_nhan.db';
  static const _version = 1;

  /// Mở (hoặc tạo) CSDL. Dữ liệu nằm trên bộ nhớ bền vững (file trên
  /// điện thoại / máy tính, IndexedDB trên trình duyệt) nên không mất khi tắt ứng dụng.
  static Future<HabitDatabase> open({
    String? path,
    DatabaseFactory? factory,
  }) async {
    final f = factory ?? platformDatabaseFactory();
    final dbPath = path ?? await defaultPath();
    final db = await f.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _version,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: _onCreate,
      ),
    );
    return HabitDatabase._(db);
  }

  static Future<String> defaultPath() => platformDatabasePath(fileName);

  /// Xóa toàn bộ CSDL (dùng khi chạy lại kịch bản demo từ đầu).
  static Future<void> deleteAll() async =>
      platformDatabaseFactory().deleteDatabase(await defaultPath());

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        name             TEXT    NOT NULL,
        description      TEXT    NOT NULL DEFAULT '',
        frequency        TEXT    NOT NULL,          -- 'daily' | 'weekly'
        weekdays         TEXT    NOT NULL DEFAULT '', -- '1,3,5' (T2, T4, T6)
        reminder_minutes INTEGER,                   -- phút trong ngày, NULL = tắt
        color            INTEGER NOT NULL,
        icon             INTEGER NOT NULL,
        created_at       TEXT    NOT NULL           -- yyyy-MM-dd
      )''');
    await db.execute('''
      CREATE TABLE completions (
        habit_id INTEGER NOT NULL REFERENCES habits(id) ON DELETE CASCADE,
        date     TEXT    NOT NULL,                  -- yyyy-MM-dd
        PRIMARY KEY (habit_id, date)
      )''');
  }

  // ---------------------------------------------------------------- habits

  Future<List<Habit>> getHabits() async {
    final rows = await _db.query('habits', orderBy: 'id');
    return rows.map(Habit.fromMap).toList();
  }

  /// Thêm thói quen, trả về bản ghi có id mới.
  Future<Habit> insertHabit(Habit habit) async {
    final id = await _db.insert('habits', habit.toMap()..remove('id'));
    return habit.copyWith(id: id);
  }

  Future<void> updateHabit(Habit habit) async {
    await _db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  /// Xóa thói quen; các dòng `completions` bị xóa theo (ON DELETE CASCADE).
  Future<void> deleteHabit(int id) async {
    await _db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // ----------------------------------------------------------- completions

  /// Tất cả lần hoàn thành, nhóm theo habit_id.
  Future<Map<int, Set<String>>> getCompletions() async {
    final rows = await _db.query('completions');
    final result = <int, Set<String>>{};
    for (final r in rows) {
      result
          .putIfAbsent(r['habit_id'] as int, () => <String>{})
          .add(r['date'] as String);
    }
    return result;
  }

  Future<void> setCompleted(int habitId, DateTime day, bool done) async {
    if (done) {
      await _db.insert('completions', {
        'habit_id': habitId,
        'date': dateKey(day),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    } else {
      await _db.delete(
        'completions',
        where: 'habit_id = ? AND date = ?',
        whereArgs: [habitId, dateKey(day)],
      );
    }
  }

  /// Ghi nhiều lần hoàn thành trong một transaction (dùng cho dữ liệu mẫu).
  Future<void> insertCompletions(int habitId, Iterable<DateTime> days) async {
    final batch = _db.batch();
    for (final d in days) {
      batch.insert('completions', {
        'habit_id': habitId,
        'date': dateKey(d),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() => _db.close();
}
