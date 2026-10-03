import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'database/initializeDefaultDatabase.dart';
import 'database/platform/connection.dart';
import 'database/tables.dart';
import 'pages/navigationFramework.dart';
import 'struct/databaseGlobal.dart';
import 'struct/settings.dart';
import 'widgets/openSnackbar.dart';
import 'widgets/watchAllSubjects.dart';

// Trình tự khởi động giống main.dart của Cashew:
// 1. SharedPreferences  2. Cơ sở dữ liệu  3. Cài đặt  4. runApp
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  database = StudyDatabase(openConnection('tai_lieu_hoc_tap'));
  await initializeSettings();
  if (appStateSettings['hasInitializedDefaults'] != true) {
    await initializeDefaultDatabase(database);
    await updateSettings('hasInitializedDefaults', true,
        updateGlobalState: false);
  }
  runApp(InitializeApp(key: appStateKey));
}

// Widget gốc. updateSettings(..., updateGlobalState: true) gọi
// appStateKey.currentState.refreshAppState() để dựng lại MaterialApp.
class InitializeApp extends StatefulWidget {
  const InitializeApp({super.key});

  @override
  State<InitializeApp> createState() => _InitializeAppState();
}

class _InitializeAppState extends State<InitializeApp>
    with RefreshableAppState<InitializeApp> {
  @override
  Widget build(BuildContext context) {
    final accent = colorFromString(appStateSettings['accentColor'] as String?,
        fallback: Colors.green);
    return MaterialApp(
      title: 'Tài liệu học tập',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: getLightTheme(accent),
      darkTheme: getDarkTheme(accent),
      themeMode: getThemeMode(),
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // Bọc Provider bên ngoài Navigator để mọi trang đều đọc được danh sách môn học
      builder: (context, child) => WatchAllSubjects(child: child!),
      home: const NavigationFramework(),
    );
  }
}
