import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/habit.dart';
import '../utils/date_utils.dart';

/// Nhắc nhở thói quen theo giờ đã đặt.
///
/// * Android / iOS: đặt lịch thông báo của hệ điều hành (`zonedSchedule`),
///   lặp hằng ngày hoặc theo từng thứ trong tuần.
/// * Windows / desktop / web: đồng hồ trong ứng dụng kiểm tra mỗi 20 giây, đến
///   giờ thì hiện banner trong ứng dụng (desktop có thêm thông báo hệ thống).
class ReminderService {
  ReminderService({required this.messengerKey});

  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _pluginReady = false;
  Timer? _ticker;
  List<Habit> _habits = const [];
  bool Function(Habit habit, DateTime day)? _isDone;
  final _firedToday = <String>{};

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'habit_reminder',
      'Nhắc nhở thói quen',
      channelDescription: 'Thông báo đến giờ thực hiện thói quen',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// [requestPermission] = false: không hỏi quyền thông báo lúc mở app
  /// (kịch bản demo tự cấp quyền qua adb).
  Future<void> init({bool requestPermission = true}) async {
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (_) {}
    if (!kIsWeb) await _initPlugin(requestPermission);
    if (!_isMobile) {
      _ticker = Timer.periodic(const Duration(seconds: 20), (_) => _tick());
    }
  }

  Future<void> _initPlugin(bool requestPermission) async {
    try {
      _pluginReady =
          await _plugin.initialize(
            settings: const InitializationSettings(
              android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              iOS: DarwinInitializationSettings(),
              windows: WindowsInitializationSettings(
                appName: 'Kỷ luật cá nhân',
                appUserModelId: 'TLU.KyLuatCaNhan',
                guid: '8f3c2a6e-4b1d-4e8a-9c57-2d6b1f0a9e41',
              ),
            ),
          ) ??
          false;
      if (defaultTargetPlatform == TargetPlatform.android &&
          requestPermission) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
    } catch (e) {
      debugPrint('Không khởi tạo được thông báo hệ thống: $e');
    }
  }

  /// Cập nhật lại toàn bộ lịch nhắc sau mỗi lần thêm / sửa / xóa thói quen.
  Future<void> sync(
    List<Habit> habits,
    bool Function(Habit habit, DateTime day) isDone,
  ) async {
    _habits = habits;
    _isDone = isDone;
    if (!_isMobile || !_pluginReady) return;
    await _plugin.cancelAll();
    for (final h in habits) {
      final r = h.reminder;
      if (r == null || h.id == null) continue;
      if (h.frequency == Frequency.daily) {
        await _schedule(h.id! * 10, h, _next(r, null), DateTimeComponents.time);
      } else {
        for (final wd in h.weekdays) {
          await _schedule(
            h.id! * 10 + wd,
            h,
            _next(r, wd),
            DateTimeComponents.dayOfWeekAndTime,
          );
        }
      }
    }
  }

  Future<void> _schedule(
    int id,
    Habit h,
    tz.TZDateTime when,
    DateTimeComponents repeat,
  ) {
    return _plugin.zonedSchedule(
      id: id,
      title: '⏰ ${h.name}',
      body: h.description.isEmpty ? 'Đến giờ rèn luyện rồi!' : h.description,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: repeat,
    );
  }

  /// Lần kế tiếp đến giờ [t] (và đúng thứ [weekday] nếu có).
  tz.TZDateTime _next(TimeOfDay t, int? weekday) {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      t.hour,
      t.minute,
    );
    while (!when.isAfter(now) || (weekday != null && when.weekday != weekday)) {
      when = when.add(const Duration(days: 1));
    }
    return when;
  }

  void _tick() {
    final now = DateTime.now();
    final day = dateOnly(now);
    for (final h in _habits) {
      final r = h.reminder;
      if (r == null || r.hour != now.hour || r.minute != now.minute) continue;
      if (!h.isScheduledOn(day) || (_isDone?.call(h, day) ?? false)) continue;
      final key = '${h.id}|${dateKey(day)}|${formatTime(r)}';
      if (_firedToday.add(key)) notifyNow(h);
    }
  }

  /// Hiện nhắc nhở ngay: thông báo hệ thống + banner trong ứng dụng.
  Future<void> notifyNow(Habit h) async {
    final body = h.description.isEmpty
        ? 'Đến giờ rèn luyện rồi!'
        : h.description;
    if (_pluginReady) {
      try {
        await _plugin.show(
          id: (h.id ?? 0) * 10,
          title: '⏰ ${h.name}',
          body: body,
          notificationDetails: _details,
        );
      } catch (e) {
        debugPrint('Lỗi gửi thông báo: $e');
      }
    }
    final messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          leading: CircleAvatar(
            backgroundColor: h.color,
            child: const Icon(Icons.alarm_rounded, color: Colors.white),
          ),
          content: Text('Nhắc nhở: ${h.name}\n$body'),
          actions: [
            TextButton(
              onPressed: () => messenger.hideCurrentMaterialBanner(),
              child: const Text('ĐÃ HIỂU'),
            ),
          ],
        ),
      );
  }

  void dispose() => _ticker?.cancel();
}
