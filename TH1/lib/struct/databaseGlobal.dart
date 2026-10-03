import 'package:shared_preferences/shared_preferences.dart';

import '../database/tables.dart';

// Biến toàn cục dùng chung cho cả ứng dụng, giống budget/lib/struct/databaseGlobal.dart.
// Được gán đúng một lần trong main() (hoặc trong test với cơ sở dữ liệu bộ nhớ).
late StudyDatabase database;
late SharedPreferences sharedPreferences;
