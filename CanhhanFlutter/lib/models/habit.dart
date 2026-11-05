import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

/// Tần suất lặp lại của thói quen.
enum Frequency {
  daily('daily', 'Hằng ngày'),
  weekly('weekly', 'Ngày cụ thể');

  const Frequency(this.code, this.label);
  final String code;
  final String label;

  static Frequency fromCode(String code) =>
      Frequency.values.firstWhere((f) => f.code == code, orElse: () => daily);
}

/// Bảng màu và biểu tượng cố định (lưu theo chỉ số trong SQLite).
const habitColors = <Color>[
  Color(0xFF26A69A),
  Color(0xFF5C6BC0),
  Color(0xFFEF6C00),
  Color(0xFFE53935),
  Color(0xFF8E24AA),
  Color(0xFF43A047),
  Color(0xFF00897B),
  Color(0xFF3949AB),
];

const habitIcons = <IconData>[
  Icons.wb_sunny_rounded,
  Icons.fitness_center_rounded,
  Icons.water_drop_rounded,
  Icons.self_improvement_rounded,
  Icons.menu_book_rounded,
  Icons.directions_run_rounded,
  Icons.bedtime_rounded,
  Icons.code_rounded,
  Icons.savings_rounded,
  Icons.restaurant_rounded,
  Icons.edit_note_rounded,
  Icons.music_note_rounded,
];

/// Một thói quen cần rèn luyện.
class Habit {
  const Habit({
    this.id,
    required this.name,
    this.description = '',
    this.frequency = Frequency.daily,
    this.weekdays = const [],
    this.reminder,
    this.colorIndex = 0,
    this.iconIndex = 0,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String description;
  final Frequency frequency;

  /// Các ngày trong tuần (DateTime.monday = 1 ... DateTime.sunday = 7),
  /// chỉ dùng khi [frequency] là [Frequency.weekly].
  final List<int> weekdays;

  /// Giờ nhắc nhở; null nghĩa là tắt nhắc nhở.
  final TimeOfDay? reminder;
  final int colorIndex;
  final int iconIndex;

  /// Ngày bắt đầu theo dõi (chỉ phần ngày). Trước ngày này không tính thống kê.
  final DateTime createdAt;

  Color get color => habitColors[colorIndex % habitColors.length];
  IconData get icon => habitIcons[iconIndex % habitIcons.length];

  /// Thói quen có lịch thực hiện vào [day] hay không.
  bool isScheduledOn(DateTime day) {
    final d = dateOnly(day);
    if (d.isBefore(createdAt)) return false;
    return frequency == Frequency.daily || weekdays.contains(d.weekday);
  }

  /// Mô tả tần suất ngắn gọn, ví dụ "Hằng ngày" hoặc "T2, T4, T6".
  String get frequencyText {
    if (frequency == Frequency.daily || weekdays.length == 7) {
      return 'Hằng ngày';
    }
    final sorted = [...weekdays]..sort();
    return sorted.map(weekdayShort).join(', ');
  }

  Habit copyWith({
    int? id,
    String? name,
    String? description,
    Frequency? frequency,
    List<int>? weekdays,
    TimeOfDay? reminder,
    bool clearReminder = false,
    int? colorIndex,
    int? iconIndex,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      weekdays: weekdays ?? this.weekdays,
      reminder: clearReminder ? null : (reminder ?? this.reminder),
      colorIndex: colorIndex ?? this.colorIndex,
      iconIndex: iconIndex ?? this.iconIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Chuyển sang một dòng của bảng `habits`.
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'description': description,
    'frequency': frequency.code,
    'weekdays': weekdays.join(','),
    'reminder_minutes': reminder == null
        ? null
        : reminder!.hour * 60 + reminder!.minute,
    'color': colorIndex,
    'icon': iconIndex,
    'created_at': dateKey(createdAt),
  };

  factory Habit.fromMap(Map<String, Object?> m) {
    final minutes = m['reminder_minutes'] as int?;
    final days = (m['weekdays'] as String? ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .map(int.parse)
        .toList();
    return Habit(
      id: m['id'] as int?,
      name: m['name'] as String,
      description: m['description'] as String? ?? '',
      frequency: Frequency.fromCode(m['frequency'] as String),
      weekdays: days,
      reminder: minutes == null
          ? null
          : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      colorIndex: m['color'] as int? ?? 0,
      iconIndex: m['icon'] as int? ?? 0,
      createdAt: parseDateKey(m['created_at'] as String),
    );
  }
}
