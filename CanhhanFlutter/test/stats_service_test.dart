import 'package:flutter_test/flutter_test.dart';
import 'package:ky_luat_ca_nhan/models/habit.dart';
import 'package:ky_luat_ca_nhan/services/stats_service.dart';

void main() {
  // Thứ Năm 05/11/2026; tuần bắt đầu thứ Hai 02/11.
  final now = DateTime(2026, 11, 5, 9);

  final daily = Habit(id: 1, name: 'Dậy sớm', createdAt: DateTime(2026, 10, 1));
  final mwf = Habit(
    id: 2,
    name: 'Tập gym',
    frequency: Frequency.weekly,
    weekdays: const [1, 3, 5],
    createdAt: DateTime(2026, 10, 1),
  );

  StatsService make(Map<int, Set<String>> c) =>
      StatsService([daily, mwf], c, now: now);

  test('tỷ lệ theo ngày chỉ tính thói quen có lịch', () {
    final s = make({
      1: {'2026-11-04'},
      2: {'2026-11-04'},
    });
    // 04/11 là thứ Tư: cả 2 thói quen có lịch, cả 2 hoàn thành.
    expect(s.day(DateTime(2026, 11, 4)).rate, 1.0);
    // 03/11 là thứ Ba: chỉ "Dậy sớm" có lịch và chưa làm.
    final tue = s.day(DateTime(2026, 11, 3));
    expect(tue.scheduled, 1);
    expect(tue.rate, 0.0);
  });

  test('tỷ lệ theo tuần bỏ qua ngày tương lai', () {
    final s = make({
      1: {'2026-11-02', '2026-11-03', '2026-11-05'},
      2: {'2026-11-02'},
    });
    // Lượt có lịch từ T2 02/11 đến T5 05/11: daily 4 + mwf (T2, T4) 2 = 6.
    final w = s.week(now);
    expect(w.scheduled, 6);
    expect(w.done, 4);
    expect(w.rate, closeTo(4 / 6, 1e-9));
  });

  test('tỷ lệ theo tháng', () {
    final s = make({
      1: {for (var d = 1; d <= 5; d++) '2026-11-0$d'},
    });
    // 01..05/11: daily 5 lượt, mwf có T2 02/11 và T4 04/11 = 2 lượt.
    final m = s.month(now);
    expect(m.scheduled, 7);
    expect(m.done, 5);
  });

  test('không tính ngày trước khi tạo thói quen', () {
    final fresh = Habit(id: 3, name: 'Mới', createdAt: DateTime(2026, 11, 5));
    final s = StatsService([fresh], {}, now: now);
    expect(s.day(DateTime(2026, 11, 4)).scheduled, 0);
    expect(s.day(DateTime(2026, 11, 4)).rate, isNull);
  });

  test('chuỗi ngày: hôm nay chưa làm không làm đứt chuỗi', () {
    final s = make({
      1: {'2026-11-02', '2026-11-03', '2026-11-04'},
      2: {'2026-10-30', '2026-11-02', '2026-11-04'},
    });
    expect(s.currentStreak(daily), 3);
    // mwf: T6 30/10, T2 02/11, T4 04/11 liên tiếp theo lịch.
    expect(s.currentStreak(mwf), 3);
    expect(s.bestStreak(daily), 3);
  });

  test('chuỗi ngày bị đứt khi bỏ một ngày có lịch', () {
    final s = make({
      1: {'2026-11-01', '2026-11-02', '2026-11-04', '2026-11-05'},
    });
    expect(s.currentStreak(daily), 2);
    expect(s.bestStreak(daily), 2);
  });
}
