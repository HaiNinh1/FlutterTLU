import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  const tabs = ['Trang chủ', 'Kỹ năng', 'Kinh nghiệm', 'Dự án', 'Liên hệ'];

  for (final size in const [Size(360, 740), Size(1280, 800)]) {
    testWidgets('Mở đủ 5 trang không lỗi bố cục ở kích thước $size',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MyApp());
      expect(find.text('Nguyễn Hải Ninh'), findsWidgets);

      for (final tab in tabs.skip(1)) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
      }

      // Mở trang chi tiết dự án rồi quay lại
      await tester.tap(find.text('Dự án').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Stock Management'));
      await tester.tap(find.text('Stock Management'));
      await tester.pumpAndSettle();
      expect(find.text('Công việc chính'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    });
  }
}
