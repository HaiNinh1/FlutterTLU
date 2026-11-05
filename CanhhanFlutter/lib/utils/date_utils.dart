import 'package:flutter/material.dart';

/// Bỏ phần giờ, chỉ giữ ngày (giờ địa phương).
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime today() => dateOnly(DateTime.now());

/// Khóa ngày dạng `yyyy-MM-dd`, dùng làm cột `date` trong SQLite.
String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime parseDateKey(String key) {
  final p = key.split('-').map(int.parse).toList();
  return DateTime(p[0], p[1], p[2]);
}

/// Cộng [n] ngày theo lịch (an toàn với giờ mùa hè).
DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

/// Thứ Hai của tuần chứa [d].
DateTime startOfWeek(DateTime d) => addDays(dateOnly(d), 1 - d.weekday);

DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

DateTime endOfMonth(DateTime d) => DateTime(d.year, d.month + 1, 0);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

const _weekdayShort = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
const _weekdayLong = [
  'Thứ Hai',
  'Thứ Ba',
  'Thứ Tư',
  'Thứ Năm',
  'Thứ Sáu',
  'Thứ Bảy',
  'Chủ Nhật',
];

/// `1` (thứ Hai) -> `T2`, `7` (Chủ nhật) -> `CN`.
String weekdayShort(int weekday) => _weekdayShort[weekday - 1];

String weekdayLong(int weekday) => _weekdayLong[weekday - 1];

/// Ví dụ: "Thứ Năm, 05/11/2026".
String formatLongDate(DateTime d) =>
    '${weekdayLong(d.weekday)}, ${formatDate(d)}';

String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

String formatDayMonth(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

String formatTime(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
