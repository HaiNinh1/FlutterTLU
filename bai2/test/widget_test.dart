// Kiểm thử giao diện (widget test) cho ứng dụng Hello World.
// Widget test giúp kiểm tra giao diện hiển thị đúng mà không cần chạy thiết bị thật.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bai2/main.dart';

void main() {
  // Kiểm tra 1: khi mở ứng dụng phải thấy dòng chữ "Hello World".
  testWidgets('Hiển thị dòng chữ Hello World', (WidgetTester tester) async {
    // Dựng ứng dụng trong môi trường kiểm thử.
    await tester.pumpWidget(const MyApp());

    // findsOneWidget: mong đợi tìm thấy đúng 1 widget chứa chữ "Hello World".
    expect(find.text('Hello World'), findsOneWidget);
  });

  // Kiểm tra 2: bấm nút "Đổi lời chào" thì nội dung phải thay đổi.
  testWidgets('Bấm nút thì đổi lời chào', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Giả lập thao tác chạm vào nút có biểu tượng refresh.
    await tester.tap(find.byIcon(Icons.refresh));
    // pump() vẽ lại giao diện sau khi trạng thái thay đổi.
    await tester.pump();

    // Lời chào cũ biến mất, lời chào mới xuất hiện.
    expect(find.text('Hello World'), findsNothing);
    expect(find.text('Xin chào Flutter'), findsOneWidget);
  });
}
