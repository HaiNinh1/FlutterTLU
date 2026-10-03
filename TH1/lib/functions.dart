import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Hàm tiện ích dùng chung, giống budget/lib/functions.dart của Cashew.

Future<T?> pushRoute<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));
}

void popRoute<T>(BuildContext context, [T? result]) {
  Navigator.of(context).pop<T>(result);
}

String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

String formatDateTime(DateTime date) =>
    DateFormat('HH:mm, dd/MM/yyyy').format(date);

// Mô tả hạn nộp so với hôm nay: "Hạn hôm nay", "Còn 3 ngày", "Quá hạn 2 ngày"
String describeDueDate(DateTime dueDate, {DateTime? now}) {
  final days = _dayNumber(dueDate) - _dayNumber(now ?? DateTime.now());
  if (days == 0) return 'Hạn hôm nay';
  if (days > 0) return 'Còn $days ngày';
  return 'Quá hạn ${-days} ngày';
}

bool isOverdue(DateTime dueDate, {DateTime? now}) {
  return _dayNumber(dueDate) < _dayNumber(now ?? DateTime.now());
}

// Số thứ tự ngày theo UTC: tránh lệch 1 ngày ở nơi có giờ mùa hè (ngày 23 hoặc 25 giờ)
int _dayNumber(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;
