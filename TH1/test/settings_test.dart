// Kiểm thử TẦNG STRUCT (cài đặt) độc lập với giao diện và cơ sở dữ liệu.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_tai_lieu/database/tables.dart';
import 'package:quan_ly_tai_lieu/functions.dart';
import 'package:quan_ly_tai_lieu/struct/databaseGlobal.dart';
import 'package:quan_ly_tai_lieu/struct/defaultPreferences.dart';
import 'package:quan_ly_tai_lieu/struct/documentTypes.dart';
import 'package:quan_ly_tai_lieu/struct/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> khoiTaoVoi(Map<String, Object> giaTri) async {
  SharedPreferences.setMockInitialValues(giaTri);
  sharedPreferences = await SharedPreferences.getInstance();
  await initializeSettings();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Cài đặt (struct/settings.dart)', () {
    test('lần đầu chạy dùng giá trị mặc định và lưu xuống bộ nhớ', () async {
      await khoiTaoVoi({});
      expect(appStateSettings, getDefaultPreferences());
      expect(sharedPreferences.getString('userSettings'), isNotNull);
    });

    test('bổ sung khoá mới cho dữ liệu cài đặt cũ', () async {
      await khoiTaoVoi({'userSettings': jsonEncode({'theme': 'dark'})});
      expect(appStateSettings['theme'], 'dark');
      expect(appStateSettings['documentSort'], 'newest');
    });

    test('JSON hỏng thì quay về mặc định', () async {
      await khoiTaoVoi({'userSettings': '{hong'});
      expect(appStateSettings, getDefaultPreferences());
    });

    test('updateSettings lưu bền vững và báo cho giao diện', () async {
      await khoiTaoVoi({});
      final truoc = settingsVersion.value;
      await updateSettings('documentSort', DocumentSort.titleAZ.name,
          updateGlobalState: false);

      expect(settingsVersion.value, truoc + 1);
      expect(getDocumentSort(), DocumentSort.titleAZ);
      final luu = jsonDecode(sharedPreferences.getString('userSettings')!);
      expect(luu['documentSort'], 'titleAZ');
    });

    test('giá trị sắp xếp lạ thì dùng mặc định', () async {
      await khoiTaoVoi({'userSettings': jsonEncode({'documentSort': 'abc'})});
      expect(getDocumentSort(), DocumentSort.newest);
    });
  });

  group('Ánh xạ hiển thị (struct/documentTypes.dart)', () {
    test('mỗi loại tài liệu có nhãn tiếng Việt', () {
      expect(DocumentType.values.map((t) => t.label),
          ['Bài giảng', 'Bài tập', 'Tham khảo']);
    });

    test('mã lỗi nghiệp vụ được dịch thành thông báo', () {
      expect(validationMessage('title-empty'), 'Vui lòng nhập tên tài liệu');
      expect(validationMessage('ma-la'), contains('ma-la'));
    });
  });

  group('Hàm tiện ích (functions.dart)', () {
    final homNay = DateTime(2026, 10, 3, 15);

    test('mô tả hạn nộp', () {
      expect(describeDueDate(DateTime(2026, 10, 3), now: homNay), 'Hạn hôm nay');
      expect(describeDueDate(DateTime(2026, 10, 6), now: homNay), 'Còn 3 ngày');
      expect(
          describeDueDate(DateTime(2026, 10, 1), now: homNay), 'Quá hạn 2 ngày');
    });

    test('kiểm tra quá hạn', () {
      expect(isOverdue(DateTime(2026, 10, 2), now: homNay), isTrue);
      expect(isOverdue(DateTime(2026, 10, 3), now: homNay), isFalse);
    });
  });
}
