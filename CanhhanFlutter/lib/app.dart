import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/habit_database.dart';
import 'providers/habit_provider.dart';
import 'screens/home_shell.dart';
import 'services/reminder_service.dart';
import 'widgets/touch_indicator.dart';

/// Khởi tạo CSDL, nhắc nhở, provider rồi trả về widget gốc.
/// [resetData] = true thì xóa file CSDL cũ, [showTouches] = true thì vẽ điểm
/// chạm (cả hai chỉ dùng cho kịch bản quay video demo).
Future<Widget> bootstrap({
  bool resetData = false,
  bool showTouches = false,
  bool requestPermission = true,
}) async {
  if (resetData) await HabitDatabase.deleteAll();
  final db = await HabitDatabase.open();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  final reminders = ReminderService(messengerKey: messengerKey);
  await reminders.init(requestPermission: requestPermission);
  final provider = HabitProvider(db, reminders: reminders);
  await provider.load();
  return ChangeNotifierProvider.value(
    value: provider,
    child: HabitApp(messengerKey: messengerKey, showTouches: showTouches),
  );
}

class HabitApp extends StatelessWidget {
  const HabitApp({
    super.key,
    required this.messengerKey,
    this.showTouches = false,
  });

  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final bool showTouches;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF26A69A);
    return MaterialApp(
      title: 'Kỷ luật cá nhân',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorSchemeSeed: seed,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      builder: showTouches ? (_, child) => TouchIndicator(child: child!) : null,
      home: const HomeShell(),
    );
  }
}
