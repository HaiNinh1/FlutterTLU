import '../models/habit.dart';
import '../utils/date_utils.dart';

/// Kết quả thống kê của một khoảng thời gian.
class PeriodStats {
  const PeriodStats(this.done, this.scheduled);

  /// Số lượt đã hoàn thành.
  final int done;

  /// Số lượt có lịch (thói quen x ngày có lịch).
  final int scheduled;

  /// Tỷ lệ hoàn thành 0..1, null nếu không có lượt nào có lịch.
  double? get rate => scheduled == 0 ? null : done / scheduled;

  PeriodStats operator +(PeriodStats o) =>
      PeriodStats(done + o.done, scheduled + o.scheduled);

  static const zero = PeriodStats(0, 0);
}

/// Tính tỷ lệ hoàn thành và chuỗi ngày (streak) từ dữ liệu thô.
///
/// Thuần Dart, không phụ thuộc giao diện hay CSDL nên dễ viết unit test.
class StatsService {
  StatsService(this.habits, this.completions, {DateTime? now})
    : today = dateOnly(now ?? DateTime.now());

  final List<Habit> habits;

  /// habit_id -> tập ngày đã hoàn thành (yyyy-MM-dd).
  final Map<int, Set<String>> completions;
  final DateTime today;

  bool isDone(Habit h, DateTime day) =>
      completions[h.id]?.contains(dateKey(day)) ?? false;

  /// Thống kê của 1 thói quen trong 1 ngày (0/1 hoặc 0/0 nếu không có lịch).
  PeriodStats habitDay(Habit h, DateTime day) {
    if (!h.isScheduledOn(day) || day.isAfter(today)) return PeriodStats.zero;
    return PeriodStats(isDone(h, day) ? 1 : 0, 1);
  }

  /// Tất cả thói quen trong 1 ngày.
  PeriodStats day(DateTime day) =>
      habits.fold(PeriodStats.zero, (s, h) => s + habitDay(h, day));

  /// Tất cả thói quen trong khoảng [start, end] (bỏ qua ngày tương lai).
  PeriodStats range(DateTime start, DateTime end) {
    var s = PeriodStats.zero;
    for (var d = dateOnly(start); !d.isAfter(end); d = addDays(d, 1)) {
      s = s + day(d);
    }
    return s;
  }

  /// Một thói quen trong khoảng [start, end].
  PeriodStats habitRange(Habit h, DateTime start, DateTime end) {
    var s = PeriodStats.zero;
    for (var d = dateOnly(start); !d.isAfter(end); d = addDays(d, 1)) {
      s = s + habitDay(h, d);
    }
    return s;
  }

  PeriodStats week(DateTime anyDay) {
    final start = startOfWeek(anyDay);
    return range(start, addDays(start, 6));
  }

  PeriodStats month(DateTime anyDay) =>
      range(startOfMonth(anyDay), endOfMonth(anyDay));

  /// Chuỗi hiện tại: số ngày có lịch liên tiếp đã hoàn thành, tính lùi từ hôm nay.
  /// Nếu hôm nay chưa làm thì chưa tính là đứt chuỗi (vẫn còn thời gian).
  int currentStreak(Habit h) {
    var streak = 0;
    var d = today;
    if (h.isScheduledOn(d) && !isDone(h, d)) d = addDays(d, -1);
    while (!d.isBefore(h.createdAt)) {
      if (h.isScheduledOn(d)) {
        if (!isDone(h, d)) break;
        streak++;
      }
      d = addDays(d, -1);
    }
    return streak;
  }

  /// Chuỗi dài nhất từ ngày bắt đầu đến hôm nay.
  int bestStreak(Habit h) {
    var best = 0, cur = 0;
    for (var d = h.createdAt; !d.isAfter(today); d = addDays(d, 1)) {
      if (!h.isScheduledOn(d)) continue;
      if (isDone(h, d)) {
        cur++;
        if (cur > best) best = cur;
      } else if (!isSameDay(d, today)) {
        cur = 0;
      }
    }
    return best;
  }
}
