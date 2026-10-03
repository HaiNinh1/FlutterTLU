// Kiểm thử TẦNG DATABASE một cách độc lập: không cần giao diện, không cần
// SharedPreferences. Dùng SQLite trong bộ nhớ (NativeDatabase.memory()).
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_tai_lieu/database/searchNormalize.dart';
import 'package:quan_ly_tai_lieu/database/tables.dart';

Subject taoMonHoc(String ten) => Subject(
      subjectPk: '-1',
      name: ten,
      order: 0,
      dateCreated: DateTime.now(),
    );

Document taoTaiLieu(
  String tieuDe,
  String subjectFk, {
  DocumentType type = DocumentType.lecture,
  String? description,
  String? link,
  String? author,
  DateTime? dueDate,
}) =>
    Document(
      documentPk: '-1',
      title: tieuDe,
      description: description,
      type: type,
      subjectFk: subjectFk,
      link: link,
      author: author,
      dueDate: dueDate,
      pinned: false,
      searchText: '',
      sortTitle: '',
      dateCreated: DateTime.now(),
    );

void main() {
  late StudyDatabase db;
  late String monDiDong;
  late String monCSDL;

  setUp(() async {
    db = StudyDatabase(NativeDatabase.memory());
    monDiDong = await db.createOrUpdateSubject(taoMonHoc('Lập trình di động'),
        insert: true);
    monCSDL =
        await db.createOrUpdateSubject(taoMonHoc('Cơ sở dữ liệu'), insert: true);
  });

  tearDown(() => db.close());

  group('Chuẩn hoá tìm kiếm', () {
    test('bỏ dấu tiếng Việt và chữ hoa', () {
      expect(normalizeForSearch('  Giải TÍCH   Đại Số '), 'giai tich dai so');
      expect(normalizeForSearch('Lập trình DI ĐỘNG'), 'lap trinh di dong');
    });
  });

  group('Thêm tài liệu', () {
    test('thêm mới sinh khoá chính và chuẩn hoá dữ liệu', () async {
      final pk = await db.createOrUpdateDocument(
        taoTaiLieu('  Bài giảng 1  ', monDiDong,
            description: '   ', author: ' Thầy A '),
        insert: true,
      );
      final saved = (await db.tryGetDocument(pk))!;
      expect(pk, isNot('-1'));
      expect(saved.title, 'Bài giảng 1');
      expect(saved.description, isNull);
      expect(saved.author, 'Thầy A');
      expect(saved.searchText, 'bai giang 1 thay a');
    });

    test('từ chối tiêu đề rỗng', () {
      expect(
        db.createOrUpdateDocument(taoTaiLieu('   ', monDiDong), insert: true),
        throwsA(isA<DocumentValidationException>()
            .having((e) => e.code, 'code', 'title-empty')),
      );
    });

    test('từ chối môn học không tồn tại', () {
      expect(
        db.createOrUpdateDocument(taoTaiLieu('A', 'khong-co'), insert: true),
        throwsA(isA<DocumentValidationException>()
            .having((e) => e.code, 'code', 'subject-not-found')),
      );
    });

    test('từ chối URL sai định dạng', () {
      expect(
        db.createOrUpdateDocument(taoTaiLieu('A', monDiDong, link: 'http://'),
            insert: true),
        throwsA(isA<DocumentValidationException>()
            .having((e) => e.code, 'code', 'link-invalid')),
      );
    });

    test('chỉ bài tập mới giữ hạn nộp', () async {
      final han = DateTime(2026, 12, 1);
      final baiGiang = await db.createOrUpdateDocument(
          taoTaiLieu('Bài giảng', monDiDong, dueDate: han),
          insert: true);
      final baiTap = await db.createOrUpdateDocument(
          taoTaiLieu('Bài tập', monDiDong,
              type: DocumentType.assignment, dueDate: han),
          insert: true);
      expect((await db.tryGetDocument(baiGiang))!.dueDate, isNull);
      expect((await db.tryGetDocument(baiTap))!.dueDate, han);
    });
  });

  group('Sửa và xoá tài liệu', () {
    test('sửa giữ nguyên khoá chính và ngày tạo', () async {
      final pk = await db.createOrUpdateDocument(taoTaiLieu('Cũ', monDiDong),
          insert: true);
      final original = (await db.tryGetDocument(pk))!;
      await db.createOrUpdateDocument(
          original.copyWith(title: 'Mới', subjectFk: monCSDL));

      final all = await db.getDocuments();
      expect(all, hasLength(1));
      expect(all.single.document.documentPk, pk);
      expect(all.single.document.title, 'Mới');
      expect(all.single.document.dateCreated, original.dateCreated);
      expect(all.single.subject.name, 'Cơ sở dữ liệu');
    });

    test('xoá một và nhiều tài liệu', () async {
      final a = await db.createOrUpdateDocument(taoTaiLieu('A', monDiDong),
          insert: true);
      final b = await db.createOrUpdateDocument(taoTaiLieu('B', monDiDong),
          insert: true);
      final c = await db.createOrUpdateDocument(taoTaiLieu('C', monDiDong),
          insert: true);
      expect(await db.deleteDocument(a), 1);
      expect(await db.deleteDocuments([b, c]), 2);
      expect(await db.getDocuments(), isEmpty);
    });

    test('ghim tài liệu đưa nó lên đầu danh sách', () async {
      await db.createOrUpdateDocument(taoTaiLieu('A', monDiDong), insert: true);
      final b = await db.createOrUpdateDocument(taoTaiLieu('B', monDiDong),
          insert: true);
      await db.togglePinned(b);
      final list = await db.getDocuments(sort: DocumentSort.titleAZ);
      expect(list.map((e) => e.document.title), ['B', 'A']);
    });
  });

  group('Tìm kiếm và lọc', () {
    setUp(() async {
      await db.createOrUpdateDocument(
          taoTaiLieu('Giải tích 1', monCSDL, author: 'Nguyễn Văn Đức'),
          insert: true);
      await db.createOrUpdateDocument(
          taoTaiLieu('Bài tập Flutter', monDiDong,
              type: DocumentType.assignment,
              description: 'Xây dựng giao diện'),
          insert: true);
      await db.createOrUpdateDocument(
          taoTaiLieu('Drift docs', monCSDL,
              type: DocumentType.reference,
              link: 'https://drift.simonbinder.eu'),
          insert: true);
    });

    test('tìm không dấu vẫn khớp có dấu', () async {
      final r = await db.getDocuments(searchFor: 'GIAI TICH');
      expect(r.map((e) => e.document.title), ['Giải tích 1']);
    });

    test('tìm theo tác giả, mô tả và đường dẫn', () async {
      expect(await db.getDocuments(searchFor: 'duc'), hasLength(1));
      expect(await db.getDocuments(searchFor: 'giao dien'), hasLength(1));
      expect(await db.getDocuments(searchFor: 'simonbinder'), hasLength(1));
      expect(await db.getDocuments(searchFor: 'khong ton tai'), isEmpty);
    });

    test('lọc theo loại và môn học', () async {
      final baiTap = await db.getDocuments(types: [DocumentType.assignment]);
      expect(baiTap.single.document.title, 'Bài tập Flutter');

      final csdl = await db.getDocuments(subjectFks: [monCSDL]);
      expect(csdl, hasLength(2));

      final ketHop = await db.getDocuments(
          searchFor: 'drift',
          types: [DocumentType.reference],
          subjectFks: [monCSDL]);
      expect(ketHop.single.document.title, 'Drift docs');
    });

    test('sắp xếp theo tên A-Z (chỉ theo tên, không theo mô tả/tác giả)',
        () async {
      await db.createOrUpdateDocument(
          taoTaiLieu('Đề cương', monDiDong, author: 'Thầy An'),
          insert: true);
      await db.createOrUpdateDocument(taoTaiLieu('Đề cương ôn tập', monDiDong),
          insert: true);
      final r = await db.getDocuments(sort: DocumentSort.titleAZ);
      expect(r.map((e) => e.document.title), [
        'Bài tập Flutter',
        'Đề cương',
        'Đề cương ôn tập',
        'Drift docs',
        'Giải tích 1',
      ]);
    });

    test('luồng watchDocuments phát lại khi dữ liệu thay đổi', () async {
      final soLuong = db
          .watchDocuments(types: [DocumentType.lecture])
          .map((list) => list.length);
      final kiemTra = expectLater(soLuong, emitsInOrder([1, 2]));
      // Chờ lần phát đầu tiên rồi mới ghi để thứ tự [1, 2] luôn đúng
      await db.watchDocuments(types: [DocumentType.lecture]).first;
      await db.createOrUpdateDocument(taoTaiLieu('Bài giảng mới', monDiDong),
          insert: true);
      await kiemTra;
    });

    test('ký tự % và _ trong từ khoá được hiểu là chữ thường', () async {
      expect(await db.getDocuments(searchFor: '%'), isEmpty);
      expect(await db.getDocuments(searchFor: '_'), isEmpty);
      await db.createOrUpdateDocument(taoTaiLieu('Giảm 50% điểm', monDiDong),
          insert: true);
      expect((await db.getDocuments(searchFor: '50%')).single.document.title,
          'Giảm 50% điểm');
    });

    test('thống kê theo loại', () async {
      final counts = await db.watchCountByType().first;
      expect(counts, {
        DocumentType.lecture: 1,
        DocumentType.assignment: 1,
        DocumentType.reference: 1,
      });
    });
  });

  group('Môn học', () {
    test('không cho trùng tên (không phân biệt dấu/hoa thường)', () {
      expect(
        db.createOrUpdateSubject(taoMonHoc('LAP TRINH DI DONG'), insert: true),
        throwsA(isA<DocumentValidationException>()
            .having((e) => e.code, 'code', 'subject-duplicate')),
      );
    });

    test('đếm số tài liệu mỗi môn', () async {
      await db.createOrUpdateDocument(taoTaiLieu('A', monDiDong), insert: true);
      await db.createOrUpdateDocument(taoTaiLieu('B', monDiDong), insert: true);
      final counts = await db.watchAllSubjectsWithCount().first;
      expect(counts.map((s) => s.documentCount), [2, 0]);
    });

    test('xoá môn học kèm chuyển tài liệu sang môn khác', () async {
      await db.createOrUpdateDocument(taoTaiLieu('A', monDiDong), insert: true);
      await db.deleteSubject(monDiDong, moveDocumentsToSubjectPk: monCSDL);

      final subjects = await db.getAllSubjects();
      expect(subjects.single.subjectPk, monCSDL);
      expect(subjects.single.order, 0);
      expect((await db.getDocuments()).single.subject.subjectPk, monCSDL);
    });

    test('xoá môn học kèm xoá tài liệu của môn', () async {
      await db.createOrUpdateDocument(taoTaiLieu('A', monDiDong), insert: true);
      await db.createOrUpdateDocument(taoTaiLieu('B', monCSDL), insert: true);
      await db.deleteSubject(monDiDong);
      expect((await db.getDocuments()).single.document.title, 'B');
    });

    test('khoá ngoại được bật: không thể xoá môn còn tài liệu bằng SQL thô',
        () async {
      await db.createOrUpdateDocument(taoTaiLieu('A', monDiDong), insert: true);
      await expectLater(
        db.customStatement(
            'DELETE FROM subjects WHERE subject_pk = ?', [monDiDong]),
        throwsA(predicate((e) => '$e'.contains('FOREIGN KEY'))),
      );
    });
  });

  test('sửa: xoá trắng trường tuỳ chọn và đổi loại thì giá trị cũ bị xoá thật',
      () async {
    final pk = await db.createOrUpdateDocument(
      taoTaiLieu('Bài tập 1', monDiDong,
          type: DocumentType.assignment,
          description: 'Mô tả cũ',
          link: 'https://lms.tlu.edu.vn',
          author: 'Thầy A',
          dueDate: DateTime(2026, 12, 1)),
      insert: true,
    );
    final goc = (await db.tryGetDocument(pk))!;
    // Người dùng xoá trắng ô mô tả/đường dẫn/tác giả và đổi sang "Bài giảng"
    await db.createOrUpdateDocument(goc.copyWith(
      type: DocumentType.lecture,
      description: const Value(''),
      link: const Value(null),
      author: const Value('  '),
    ));

    final sau = (await db.tryGetDocument(pk))!;
    expect(sau.description, isNull);
    expect(sau.link, isNull);
    expect(sau.author, isNull);
    expect(sau.dueDate, isNull);
    expect(sau.searchText, 'bai tap 1');
    expect(await db.getDocuments(searchFor: 'mo ta cu'), isEmpty);
  });
}
