// Kiểm thử TÍCH HỢP qua giao diện: pages -> widgets -> struct -> database.
// Dùng SQLite trong bộ nhớ và SharedPreferences giả nên không đụng dữ liệu thật.
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_tai_lieu/database/tables.dart';
import 'package:quan_ly_tai_lieu/main.dart';
import 'package:quan_ly_tai_lieu/struct/databaseGlobal.dart';
import 'package:quan_ly_tai_lieu/struct/settings.dart';
import 'package:quan_ly_tai_lieu/widgets/documentEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> moUngDung(WidgetTester tester) async {
  await tester.pumpWidget(InitializeApp(key: appStateKey));
  await tester.pumpAndSettle();
}

// Chỉ tìm trong danh sách (tránh trùng với chữ trên snackbar)
Finder trongDanhSach(String text) => find.descendant(
    of: find.byType(DocumentEntry), matching: find.text(text));

// Gỡ cây widget rồi đóng CSDL để các stream của drift huỷ hết trước khi test kết thúc
Future<void> dongUngDung(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(() => database.close());
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    database = StudyDatabase(NativeDatabase.memory());
    await initializeSettings();
    await database.createOrUpdateSubject(
      Subject(
        subjectPk: '-1',
        name: 'Giải tích',
        colour: '0xff1565c0',
        order: 0,
        dateCreated: DateTime.now(),
      ),
      insert: true,
    );
  });

  testWidgets('Thêm, tìm kiếm, sửa và xoá tài liệu qua giao diện',
      (tester) async {
    await moUngDung(tester);
    expect(find.textContaining('Chưa có tài liệu nào'), findsOneWidget);

    // --- THÊM ---
    await tester.tap(find.byKey(const ValueKey('add-document-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('title-field')), '  Giáo trình Giải tích 1 ');
    await tester.enterText(
        find.byKey(const ValueKey('author-field')), 'Nguyễn Văn Đức');
    await tester.tap(find.byKey(const ValueKey('save-document-button')));
    await tester.pumpAndSettle();
    expect(trongDanhSach('Giáo trình Giải tích 1'), findsOneWidget);
    expect((await database.getDocuments()).single.document.author,
        'Nguyễn Văn Đức');

    // --- TÌM KIẾM (không dấu, theo tác giả) ---
    await tester.enterText(find.byKey(const ValueKey('search-field')), 'duc');
    await tester.pumpAndSettle();
    expect(trongDanhSach('Giáo trình Giải tích 1'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('search-field')), 'khong co');
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy tài liệu phù hợp'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('search-field')), '');
    await tester.pumpAndSettle();

    // --- SỬA ---
    await tester.tap(trongDanhSach('Giáo trình Giải tích 1'));
    await tester.pumpAndSettle();
    expect(find.text('Sửa tài liệu'), findsWidgets);
    await tester.enterText(
        find.byKey(const ValueKey('title-field')), 'Giáo trình Giải tích 2');
    await tester.tap(find.byKey(const ValueKey('save-document-button')));
    await tester.pumpAndSettle();
    expect(trongDanhSach('Giáo trình Giải tích 2'), findsOneWidget);
    expect(trongDanhSach('Giáo trình Giải tích 1'), findsNothing);
    expect(await database.getDocuments(), hasLength(1));

    // --- XOÁ (có hộp thoại xác nhận) ---
    await tester.tap(find.byTooltip('Xoá'));
    await tester.pumpAndSettle();
    expect(find.text('Xoá tài liệu?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Xoá'));
    await tester.pumpAndSettle();
    expect(trongDanhSach('Giáo trình Giải tích 2'), findsNothing);
    expect(await database.getDocuments(), isEmpty);

    // --- HOÀN TÁC ---
    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(trongDanhSach('Giáo trình Giải tích 2'), findsOneWidget);

    await dongUngDung(tester);
  });

  testWidgets('Lỗi nghiệp vụ từ tầng database được hiển thị trên giao diện',
      (tester) async {
    await moUngDung(tester);
    await tester.tap(find.byKey(const ValueKey('add-document-button')));
    await tester.pumpAndSettle();
    // Không nhập tên mà bấm Thêm -> database ném DocumentValidationException('title-empty')
    await tester.tap(find.byKey(const ValueKey('save-document-button')));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập tên tài liệu'), findsWidgets);
    expect(find.byKey(const ValueKey('title-field')), findsOneWidget); // vẫn ở trang thêm
    expect(await database.getDocuments(), isEmpty);
    await dongUngDung(tester);
  });

  testWidgets('Hỏi trước khi bỏ thay đổi chưa lưu', (tester) async {
    // Giả lập nút Back của hệ thống (Android) -> PopScope chặn và hỏi người dùng
    Future<void> back() async {
      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();
    }

    await moUngDung(tester);
    final nutThem = find.byKey(const ValueKey('add-document-button'));

    // Chưa nhập gì -> quay lại ngay, không hỏi
    await tester.tap(nutThem);
    await tester.pumpAndSettle();
    await back();
    expect(find.text('Bỏ các thay đổi?'), findsNothing);
    expect(find.byKey(const ValueKey('title-field')), findsNothing);

    // Đã nhập -> hỏi; chọn "Ở lại" thì giữ nguyên nội dung
    await tester.tap(nutThem);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('title-field')), 'Nháp');
    await back();
    expect(find.text('Bỏ các thay đổi?'), findsOneWidget);
    await tester.tap(find.text('Ở lại'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Nháp'), findsOneWidget);

    // Hỏi lần nữa và chọn "Bỏ thay đổi"
    await back();
    expect(find.text('Bỏ các thay đổi?'), findsOneWidget);
    await tester.tap(find.text('Bỏ thay đổi'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('title-field')), findsNothing);
    expect(await database.getDocuments(), isEmpty);
    await dongUngDung(tester);
  });

  testWidgets('Xoá môn học và chuyển tài liệu sang môn khác', (tester) async {
    final monCu = (await database.getAllSubjects()).single;
    await database.createOrUpdateSubject(
      monCu.copyWith(subjectPk: '-1', name: 'Đại số'),
      insert: true,
    );
    await database.createOrUpdateDocument(
      Document(
        documentPk: '-1',
        title: 'Đề cương',
        type: DocumentType.reference,
        subjectFk: monCu.subjectPk,
        pinned: false,
        searchText: '',
        sortTitle: '',
        dateCreated: DateTime.now(),
      ),
      insert: true,
    );

    await moUngDung(tester);
    await tester.tap(find.text('Môn học').last);
    await tester.pumpAndSettle();
    expect(find.text('1 tài liệu'), findsOneWidget);

    await tester.tap(find.byTooltip('Xoá môn học').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Xoá'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chuyển sang "Đại số"'));
    await tester.pumpAndSettle();

    expect(
        find.descendant(
            of: find.byType(ListTile), matching: find.text('Giải tích')),
        findsNothing);
    final docs = await database.getDocuments();
    expect(docs.single.subject.name, 'Đại số');
    await dongUngDung(tester);
  });

  testWidgets('Chưa có môn học: trang thêm tài liệu hướng dẫn tạo môn trước',
      (tester) async {
    await tester.runAsync(() => database.deleteEverything());
    await moUngDung(tester);
    await tester.tap(find.byKey(const ValueKey('add-document-button')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cần tạo ít nhất một môn học'), findsOneWidget);
    expect(find.byKey(const ValueKey('save-document-button')), findsNothing);

    await tester.tap(find.text('Thêm môn học'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('subject-name-field')), 'Vật lý');
    await tester.tap(find.byKey(const ValueKey('save-subject-button')));
    await tester.pumpAndSettle();

    // Quay về trang thêm tài liệu, form đã hiện vì Provider phát môn học mới
    expect(find.byKey(const ValueKey('title-field')), findsOneWidget);
    expect(find.text('Vật lý'), findsWidgets);
    await dongUngDung(tester);
  });
}
