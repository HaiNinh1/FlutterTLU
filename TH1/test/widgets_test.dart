// Kiểm thử TẦNG WIDGETS: widget dùng lại được mà không cần cơ sở dữ liệu,
// vì dữ liệu và hành động được truyền vào từ ngoài (callback).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_tai_lieu/database/tables.dart';
import 'package:quan_ly_tai_lieu/widgets/documentEntry.dart';
import 'package:quan_ly_tai_lieu/widgets/openPopup.dart';

DocumentWithSubject mau({DateTime? dueDate}) => DocumentWithSubject(
      document: Document(
        documentPk: 'd1',
        title: 'Bài tập lớn',
        description: 'Nộp qua LMS',
        type: DocumentType.assignment,
        subjectFk: 's1',
        dueDate: dueDate,
        pinned: true,
        searchText: '',
        sortTitle: '',
        dateCreated: DateTime(2026, 9, 1),
      ),
      subject: Subject(
        subjectPk: 's1',
        name: 'Lập trình di động',
        colour: '0xff2e7d32',
        order: 0,
        dateCreated: DateTime(2026, 9, 1),
      ),
    );

Widget boc(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('DocumentEntry hiển thị dữ liệu và gọi callback', (tester) async {
    var daMo = 0, daGhim = 0, daXoa = 0;
    await tester.pumpWidget(boc(DocumentEntry(
      item: mau(dueDate: DateTime.now().add(const Duration(days: 2))),
      onTap: () => daMo++,
      onTogglePinned: () => daGhim++,
      onDelete: () => daXoa++,
    )));

    expect(find.text('Bài tập lớn'), findsOneWidget);
    expect(find.text('Lập trình di động'), findsOneWidget);
    expect(find.text('Bài tập'), findsOneWidget);
    expect(find.text('Còn 2 ngày'), findsOneWidget);
    expect(find.text('Nộp qua LMS'), findsOneWidget);

    await tester.tap(find.text('Bài tập lớn'));
    await tester.tap(find.byTooltip('Bỏ ghim'));
    await tester.tap(find.byTooltip('Xoá'));
    expect([daMo, daGhim, daXoa], [1, 1, 1]);
  });

  testWidgets('DocumentEntry ẩn mô tả khi showDescription = false',
      (tester) async {
    await tester.pumpWidget(boc(DocumentEntry(
      item: mau(),
      onTap: () {},
      showDescription: false,
    )));
    expect(find.text('Nộp qua LMS'), findsNothing);
    expect(find.byTooltip('Xoá'), findsNothing);
  });

  testWidgets('openDeletePopup trả về lựa chọn của người dùng', (tester) async {
    DeletePopupAction? ketQua;
    await tester.pumpWidget(boc(Builder(
      builder: (context) => TextButton(
        onPressed: () async =>
            ketQua = await openDeletePopup(context, title: 'Xoá?'),
        child: const Text('mo'),
      ),
    )));

    await tester.tap(find.text('mo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Huỷ'));
    await tester.pumpAndSettle();
    expect(ketQua, DeletePopupAction.cancel);

    await tester.tap(find.text('mo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xoá'));
    await tester.pumpAndSettle();
    expect(ketQua, DeletePopupAction.delete);
  });
}
