import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ky_luat_ca_nhan/data/habit_database.dart';
import 'package:ky_luat_ca_nhan/models/habit.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  late Directory tmp;
  late String path;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('habit_db_test');
    path = '${tmp.path}${Platform.pathSeparator}test.db';
  });

  tearDown(() => tmp.delete(recursive: true));

  Habit sample() => Habit(
    name: 'Đọc sách',
    description: '20 trang',
    frequency: Frequency.weekly,
    weekdays: const [1, 3, 5],
    reminder: const TimeOfDay(hour: 21, minute: 30),
    colorIndex: 2,
    iconIndex: 4,
    createdAt: DateTime(2026, 11, 1),
  );

  test('thêm, sửa, xóa thói quen với đầy đủ thuộc tính', () async {
    final db = await HabitDatabase.open(
      path: path,
      factory: databaseFactoryFfi,
    );
    final saved = await db.insertHabit(sample());
    expect(saved.id, isNotNull);

    var all = await db.getHabits();
    expect(all, hasLength(1));
    expect(all.single.name, 'Đọc sách');
    expect(all.single.description, '20 trang');
    expect(all.single.frequency, Frequency.weekly);
    expect(all.single.weekdays, [1, 3, 5]);
    expect(all.single.reminder, const TimeOfDay(hour: 21, minute: 30));

    await db.updateHabit(
      saved.copyWith(
        name: 'Đọc sách 30 phút',
        frequency: Frequency.daily,
        clearReminder: true,
      ),
    );
    all = await db.getHabits();
    expect(all.single.name, 'Đọc sách 30 phút');
    expect(all.single.frequency, Frequency.daily);
    expect(all.single.reminder, isNull);

    await db.deleteHabit(saved.id!);
    expect(await db.getHabits(), isEmpty);
    await db.close();
  });

  test('dữ liệu còn nguyên sau khi đóng và mở lại CSDL', () async {
    var db = await HabitDatabase.open(path: path, factory: databaseFactoryFfi);
    final h = await db.insertHabit(sample());
    await db.setCompleted(h.id!, DateTime(2026, 11, 3), true);
    await db.setCompleted(h.id!, DateTime(2026, 11, 5), true);
    await db.close();

    db = await HabitDatabase.open(path: path, factory: databaseFactoryFfi);
    expect((await db.getHabits()).single.name, 'Đọc sách');
    expect((await db.getCompletions())[h.id], {'2026-11-03', '2026-11-05'});
    await db.close();
  });

  test('bỏ đánh dấu và xóa thói quen thì xóa luôn lịch sử (cascade)', () async {
    final db = await HabitDatabase.open(
      path: path,
      factory: databaseFactoryFfi,
    );
    final h = await db.insertHabit(sample());
    await db.setCompleted(h.id!, DateTime(2026, 11, 3), true);
    await db.setCompleted(h.id!, DateTime(2026, 11, 3), true); // trùng: bỏ qua
    await db.setCompleted(h.id!, DateTime(2026, 11, 4), true);
    await db.setCompleted(h.id!, DateTime(2026, 11, 4), false);
    expect((await db.getCompletions())[h.id], {'2026-11-03'});

    await db.deleteHabit(h.id!);
    expect(await db.getCompletions(), isEmpty);
    await db.close();
  });
}
