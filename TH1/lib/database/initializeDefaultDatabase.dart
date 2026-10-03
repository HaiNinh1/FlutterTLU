import 'tables.dart';

// Tạo dữ liệu mẫu cho lần chạy đầu, giống initializeDefaultDatabase của Cashew.
// Chỉ chạy khi chưa có môn học nào.
// Chạy trong một transaction: lỗi giữa chừng thì không để lại dữ liệu mẫu dở dang.
Future<void> initializeDefaultDatabase(StudyDatabase db) {
  return db.transaction(() async {
    if ((await db.getAllSubjects()).isNotEmpty) return;

    Subject newSubject(String name, String colour) => Subject(
      subjectPk: '-1',
      name: name,
      colour: colour,
      order: 0,
      dateCreated: DateTime.now(),
    );

    final mobile = await db.createOrUpdateSubject(
      newSubject('Lập trình di động', '0xff2e7d32'),
      insert: true,
    );
    final databaseSubject = await db.createOrUpdateSubject(
      newSubject('Cơ sở dữ liệu', '0xff1565c0'),
      insert: true,
    );
    await db.createOrUpdateSubject(
      newSubject('Toán rời rạc', '0xffef6c00'),
      insert: true,
    );

    Document newDocument(
      String title,
      DocumentType type,
      String subjectFk, {
      String? description,
      String? link,
      String? author,
      DateTime? dueDate,
      bool pinned = false,
    }) => Document(
      documentPk: '-1',
      title: title,
      description: description,
      type: type,
      subjectFk: subjectFk,
      link: link,
      author: author,
      dueDate: dueDate,
      pinned: pinned,
      searchText: '',
      sortTitle: '',
      dateCreated: DateTime.now(),
    );

    await db.createOrUpdateDocument(
      newDocument(
        'Bài giảng 1 - Tổng quan Flutter',
        DocumentType.lecture,
        mobile,
        description: 'Widget, cây widget, StatelessWidget và StatefulWidget',
        link: 'https://docs.flutter.dev/get-started',
        author: 'Khoa CNTT',
        pinned: true,
      ),
      insert: true,
    );
    await db.createOrUpdateDocument(
      newDocument(
        'TH1 - Ứng dụng quản lý tài liệu',
        DocumentType.assignment,
        mobile,
        description:
            'Áp dụng kiến trúc Cashew: database / struct / widgets / pages',
        dueDate: DateTime.now().add(const Duration(days: 7)),
      ),
      insert: true,
    );
    await db.createOrUpdateDocument(
      newDocument(
        'Drift documentation',
        DocumentType.reference,
        databaseSubject,
        description: 'Thư viện SQLite cho Dart/Flutter',
        link: 'https://drift.simonbinder.eu/',
      ),
      insert: true,
    );
    await db.createOrUpdateDocument(
      newDocument(
        'Giáo trình Cơ sở dữ liệu - Chương 3: SQL',
        DocumentType.lecture,
        databaseSubject,
        author: 'Bộ môn HTTT',
      ),
      insert: true,
    );
  });
}
