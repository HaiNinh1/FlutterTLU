import 'dart:math';

import 'package:flutter/material.dart';

import '../models/habit.dart';
import 'date_utils.dart';

/// Dữ liệu mẫu: 4 thói quen với lịch sử 60 ngày để xem thử thống kê.
///
/// Xác suất hoàn thành tăng dần theo thời gian (mô phỏng người dùng ngày càng
/// kỷ luật hơn). Ngày hôm nay để trống để người dùng tự đánh dấu.
List<(Habit, Iterable<DateTime>)> buildSampleData({DateTime? now}) {
  final t = dateOnly(now ?? DateTime.now());
  final start = addDays(t, -60);
  final rnd = Random(2026);

  Habit make(
    String name,
    String desc,
    int color,
    int icon,
    TimeOfDay? reminder, {
    List<int>? weekdays,
  }) {
    return Habit(
      name: name,
      description: desc,
      frequency: weekdays == null ? Frequency.daily : Frequency.weekly,
      weekdays: weekdays ?? const [],
      reminder: reminder,
      colorIndex: color,
      iconIndex: icon,
      createdAt: start,
    );
  }

  Iterable<DateTime> history(Habit h, double base) sync* {
    for (var d = start; d.isBefore(t); d = addDays(d, 1)) {
      if (!h.isScheduledOn(d)) continue;
      final progress = d.difference(start).inDays / 60; // 0 -> 1
      if (rnd.nextDouble() < base + 0.3 * progress) yield d;
    }
  }

  final wake = make(
    'Dậy sớm lúc 6:00',
    'Không bấm báo thức lại',
    2,
    0,
    const TimeOfDay(hour: 6, minute: 0),
  );
  final gym = make(
    'Tập thể dục 30 phút',
    'Chạy bộ hoặc tập tạ',
    0,
    1,
    const TimeOfDay(hour: 17, minute: 30),
    weekdays: const [DateTime.monday, DateTime.wednesday, DateTime.friday],
  );
  final water = make('Uống đủ 2 lít nước', '8 cốc nước mỗi ngày', 1, 2, null);
  final meditate = make(
    'Thiền 10 phút',
    'Hít thở sâu trước khi ngủ',
    4,
    3,
    const TimeOfDay(hour: 22, minute: 0),
  );

  return [
    (wake, history(wake, 0.45).toList()),
    (gym, history(gym, 0.55).toList()),
    (water, history(water, 0.6).toList()),
    (meditate, history(meditate, 0.35).toList()),
  ];
}
