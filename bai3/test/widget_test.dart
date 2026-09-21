import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ho_so_ca_nhan/main.dart';

void main() {
  testWidgets('Hồ sơ hiển thị đúng, không overflow trên màn hình hẹp', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: HoSoScreen()));
    expect(find.text('Nguyễn Hải Ninh'), findsOneWidget);
    expect(find.text('0917 634 946'), findsOneWidget);
    expect(find.text('haininh320@gmail.com'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Tắt công tắc -> phải xuất hiện lỗi overflow
    await tester.ensureVisible(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(tester.takeException(), isNotNull);
  });
}
