import 'package:flutter/foundation.dart';

import '../data/habit_database.dart';
import '../models/habit.dart';
import '../services/reminder_service.dart';
import '../services/stats_service.dart';
import '../utils/date_utils.dart';

/// Trạng thái dùng chung của ứng dụng (Provider + ChangeNotifier).
///
/// Giữ danh sách thói quen và các lần hoàn thành trong bộ nhớ, mọi thay đổi
/// đều ghi xuống SQLite trước rồi mới [notifyListeners] để giao diện vẽ lại.
class HabitProvider extends ChangeNotifier {
  HabitProvider(this._db, {this.reminders});

  final HabitDatabase _db;
  final ReminderService? reminders;

  List<Habit> _habits = [];
  Map<int, Set<String>> _completions = {};
  bool _loaded = false;
  DateTime _selectedDay = today();

  List<Habit> get habits => List.unmodifiable(_habits);
  bool get loaded => _loaded;

  /// Ngày đang xem trên màn hình "Hôm nay" (có thể chọn ngày trước đó).
  DateTime get selectedDay => _selectedDay;

  StatsService get stats => StatsService(_habits, _completions);

  Future<void> load() async {
    _habits = await _db.getHabits();
    _completions = await _db.getCompletions();
    _loaded = true;
    notifyListeners();
    _syncReminders();
  }

  void selectDay(DateTime day) {
    final d = dateOnly(day);
    if (d.isAfter(today())) return; // không đánh dấu trước cho tương lai
    _selectedDay = d;
    notifyListeners();
  }

  // ------------------------------------------------------------ thêm/sửa/xóa

  Future<Habit> addHabit(Habit habit) async {
    final saved = await _db.insertHabit(habit.copyWith(createdAt: today()));
    _habits = [..._habits, saved];
    notifyListeners();
    _syncReminders();
    return saved;
  }

  Future<void> updateHabit(Habit habit) async {
    await _db.updateHabit(habit);
    _habits = [for (final h in _habits) h.id == habit.id ? habit : h];
    notifyListeners();
    _syncReminders();
  }

  Future<void> deleteHabit(Habit habit) async {
    // Cập nhật bộ nhớ trước để Dismissible rời khỏi cây widget ngay lập tức.
    _habits = _habits.where((h) => h.id != habit.id).toList();
    _completions.remove(habit.id);
    notifyListeners();
    await _db.deleteHabit(habit.id!);
    _syncReminders();
  }

  Habit? byId(int id) {
    for (final h in _habits) {
      if (h.id == id) return h;
    }
    return null;
  }

  // ------------------------------------------------------------ hoàn thành

  bool isDone(Habit habit, DateTime day) =>
      _completions[habit.id]?.contains(dateKey(day)) ?? false;

  /// Đánh dấu / bỏ đánh dấu hoàn thành của [habit] trong [day].
  Future<void> toggle(Habit habit, DateTime day) async {
    final done = !isDone(habit, day);
    await _db.setCompleted(habit.id!, day, done);
    final set = _completions.putIfAbsent(habit.id!, () => <String>{});
    done ? set.add(dateKey(day)) : set.remove(dateKey(day));
    notifyListeners();
  }

  /// Các thói quen có lịch / không có lịch trong ngày đang chọn.
  List<Habit> scheduledOn(DateTime day) =>
      _habits.where((h) => h.isScheduledOn(day)).toList();

  List<Habit> notScheduledOn(DateTime day) =>
      _habits.where((h) => !h.isScheduledOn(day)).toList();

  // ------------------------------------------------------------ dữ liệu mẫu

  /// Thêm các thói quen mẫu kèm lịch sử hoàn thành để xem thử thống kê.
  Future<void> addSample(List<(Habit, Iterable<DateTime>)> items) async {
    for (final (habit, history) in items) {
      final saved = await _db.insertHabit(habit);
      await _db.insertCompletions(saved.id!, history);
    }
    await load();
  }

  void _syncReminders() => reminders?.sync(_habits, isDone);
}
