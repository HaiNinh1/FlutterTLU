import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/tables.dart';
import 'databaseGlobal.dart';
import 'defaultPreferences.dart';

// ============================================================================
// TẦNG STRUCT - cài đặt toàn cục (giống budget/lib/struct/settings.dart)
// appStateSettings là "nguồn sự thật" duy nhất của cài đặt, lưu thành JSON
// trong SharedPreferences. Mọi nơi đọc: appStateSettings['key'].
// ============================================================================

Map<String, dynamic> appStateSettings = {};

const String _settingsKey = 'userSettings';

// State gốc của ứng dụng trộn mixin này để updateSettings() có thể yêu cầu
// dựng lại toàn bộ MaterialApp (đổi giao diện sáng/tối, màu chủ đạo...).
// Cashew đặt appStateKey trong main.dart; ở đây đặt trong struct/ để struct
// không phải import ngược lên main.dart.
mixin RefreshableAppState<T extends StatefulWidget> on State<T> {
  void refreshAppState() {
    if (mounted) setState(() {});
  }
}

final GlobalKey<RefreshableAppState> appStateKey =
    GlobalKey<RefreshableAppState>();

// Tăng mỗi khi cài đặt đổi. Trang đang mở (ví dụ danh sách tài liệu) lắng nghe
// để vẽ lại; thay cho cơ chế pagesNeedingRefresh + GlobalKey từng trang của Cashew
// (cơ chế đó buộc struct/ phải import pages/).
final ValueNotifier<int> settingsVersion = ValueNotifier<int>(0);

Future<void> initializeSettings() async {
  appStateSettings = getUserSettings();
  await _saveSettings();
}

Map<String, dynamic> getUserSettings() {
  final defaults = getDefaultPreferences();
  final raw = sharedPreferences.getString(_settingsKey);
  if (raw == null) return defaults;
  try {
    final decoded = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    // Bổ sung khoá mới cho người dùng đã cài phiên bản cũ
    defaults.forEach((key, value) => decoded.putIfAbsent(key, () => value));
    return decoded;
  } catch (_) {
    // JSON hỏng -> quay về mặc định thay vì làm sập ứng dụng
    return defaults;
  }
}

Future<void> updateSettings(
  String key,
  dynamic value, {
  required bool updateGlobalState,
}) async {
  appStateSettings[key] = value;
  await _saveSettings();
  settingsVersion.value++;
  if (updateGlobalState) appStateKey.currentState?.refreshAppState();
}

Future<void> _saveSettings() {
  return sharedPreferences.setString(_settingsKey, jsonEncode(appStateSettings));
}

// Chuyển chuỗi lưu trữ sang kiểu dùng trong ứng dụng (giống getSettingConstants)
ThemeMode getThemeMode() {
  return switch (appStateSettings['theme']) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

DocumentSort getDocumentSort() {
  return DocumentSort.values.firstWhere(
    (s) => s.name == appStateSettings['documentSort'],
    orElse: () => DocumentSort.newest,
  );
}
