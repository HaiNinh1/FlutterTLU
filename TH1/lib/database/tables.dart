import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'searchNormalize.dart';

part 'tables.g.dart';

// ============================================================================
// TẦNG DATABASE (giống budget/lib/database/tables.dart của Cashew)
// - Khai báo bảng bằng drift, sinh mã vào tables.g.dart (dart run build_runner build)
// - Toàn bộ truy vấn + quy tắc nghiệp vụ dữ liệu nằm trong lớp StudyDatabase
// - Không import Flutter UI, struct/, widgets/ hay pages/ -> có thể kiểm thử độc lập
// ============================================================================

int schemaVersionGlobal = 1;

const int NAME_LIMIT = 100;
const int TITLE_LIMIT = 200;

const uuid = Uuid();

enum DocumentType { lecture, assignment, reference }

enum DocumentSort { newest, oldest, titleAZ, dueDate }

// Lỗi nghiệp vụ do tầng database ném ra; tầng giao diện chỉ việc hiển thị.
// Cashew dùng chuỗi lỗi (ví dụ "category-no-longer-exists"); ở đây gói vào một lớp.
class DocumentValidationException implements Exception {
  const DocumentValidationException(this.code);

  final String code;

  @override
  String toString() => 'DocumentValidationException($code)';
}

@DataClassName('Subject')
class Subjects extends Table {
  TextColumn get subjectPk => text().clientDefault(() => uuid.v4())();
  TextColumn get name => text().withLength(min: 1, max: NAME_LIMIT)();
  // Màu hiển thị dạng "0xff2e7d32"
  TextColumn get colour => text().nullable()();
  IntColumn get order => integer()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(currentDateAndTime).nullable()();

  @override
  Set<Column> get primaryKey => {subjectPk};
}

@DataClassName('Document')
class Documents extends Table {
  TextColumn get documentPk => text().clientDefault(() => uuid.v4())();
  TextColumn get title => text().withLength(min: 1, max: TITLE_LIMIT)();
  TextColumn get description => text().nullable()();
  IntColumn get type => intEnum<DocumentType>()();
  TextColumn get subjectFk => text().references(Subjects, #subjectPk)();
  // Đường dẫn tệp hoặc URL tới tài liệu
  TextColumn get link => text().nullable()();
  TextColumn get author => text().nullable()();
  // Hạn nộp: chỉ có ý nghĩa với bài tập
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  // Chuỗi đã chuẩn hoá (bỏ dấu, chữ thường) phục vụ tìm kiếm
  TextColumn get searchText => text().withDefault(const Constant(''))();
  // Tên đã chuẩn hoá, dùng để sắp xếp A -> Z đúng với tiếng Việt
  TextColumn get sortTitle => text().withDefault(const Constant(''))();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get dateTimeModified =>
      dateTime().withDefault(currentDateAndTime).nullable()();

  @override
  Set<Column> get primaryKey => {documentPk};
}

// Lớp "view" ghép dữ liệu, giống TransactionWithCategory của Cashew
class DocumentWithSubject {
  const DocumentWithSubject({required this.document, required this.subject});

  final Document document;
  final Subject subject;
}

class SubjectWithCount {
  const SubjectWithCount({required this.subject, required this.documentCount});

  final Subject subject;
  final int documentCount;
}

@DriftDatabase(tables: [Subjects, Documents])
class StudyDatabase extends _$StudyDatabase {
  StudyDatabase(super.e);

  @override
  int get schemaVersion => schemaVersionGlobal;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // --------------------------------------------------------------------------
  // MÔN HỌC (Subjects)
  // --------------------------------------------------------------------------

  Stream<List<Subject>> watchAllSubjects() {
    return (select(
      subjects,
    )..orderBy([(s) => OrderingTerm.asc(s.order)])).watch();
  }

  Future<List<Subject>> getAllSubjects() {
    return (select(
      subjects,
    )..orderBy([(s) => OrderingTerm.asc(s.order)])).get();
  }

  Future<Subject?> tryGetSubject(String subjectPk) {
    return (select(
      subjects,
    )..where((s) => s.subjectPk.equals(subjectPk))).getSingleOrNull();
  }

  Stream<List<SubjectWithCount>> watchAllSubjectsWithCount() {
    final count = documents.documentPk.count();
    final query =
        select(subjects).join([
            leftOuterJoin(
              documents,
              documents.subjectFk.equalsExp(subjects.subjectPk),
              useColumns: false,
            ),
          ])
          ..addColumns([count])
          ..groupBy([subjects.subjectPk])
          ..orderBy([OrderingTerm.asc(subjects.order)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => SubjectWithCount(
              subject: row.readTable(subjects),
              documentCount: row.read(count) ?? 0,
            ),
          )
          .toList(),
    );
  }

  // Thêm mới (insert = true) hoặc cập nhật môn học. Trả về khoá chính.
  Future<String> createOrUpdateSubject(
    Subject subject, {
    bool insert = false,
  }) async {
    final name = subject.name.trim();
    if (name.isEmpty) throw const DocumentValidationException('subject-empty');
    if (name.length > NAME_LIMIT) {
      throw const DocumentValidationException('subject-too-long');
    }

    return transaction(() async {
      final existing = await getAllSubjects();
      final duplicated = existing.any(
        (s) =>
            s.subjectPk != subject.subjectPk &&
            normalizeForSearch(s.name) == normalizeForSearch(name),
      );
      if (duplicated) {
        throw const DocumentValidationException('subject-duplicate');
      }

      final subjectPk = insert ? uuid.v4() : subject.subjectPk;
      final companion = subject
          .copyWith(
            subjectPk: subjectPk,
            name: name,
            order: insert ? existing.length : subject.order,
            dateCreated: insert ? DateTime.now() : subject.dateCreated,
            dateTimeModified: Value(DateTime.now()),
          )
          .toCompanion(false);
      await into(subjects).insertOnConflictUpdate(companion);
      return subjectPk;
    });
  }

  // Xoá môn học. Nếu truyền moveDocumentsToSubjectPk thì chuyển tài liệu sang
  // môn khác, ngược lại xoá luôn các tài liệu thuộc môn (giống deleteCategory của Cashew).
  Future<void> deleteSubject(
    String subjectPk, {
    String? moveDocumentsToSubjectPk,
  }) {
    return transaction(() async {
      if (moveDocumentsToSubjectPk != null) {
        if (moveDocumentsToSubjectPk == subjectPk ||
            await tryGetSubject(moveDocumentsToSubjectPk) == null) {
          throw const DocumentValidationException('subject-not-found');
        }
        await (update(
          documents,
        )..where((d) => d.subjectFk.equals(subjectPk))).write(
          DocumentsCompanion(
            subjectFk: Value(moveDocumentsToSubjectPk),
            dateTimeModified: Value(DateTime.now()),
          ),
        );
      } else {
        await (delete(
          documents,
        )..where((d) => d.subjectFk.equals(subjectPk))).go();
      }
      await (delete(
        subjects,
      )..where((s) => s.subjectPk.equals(subjectPk))).go();
      await _fixSubjectOrder();
    });
  }

  Future<void> _fixSubjectOrder() async {
    final all = await getAllSubjects();
    for (var i = 0; i < all.length; i++) {
      if (all[i].order != i) {
        await (update(subjects)
              ..where((s) => s.subjectPk.equals(all[i].subjectPk)))
            .write(SubjectsCompanion(order: Value(i)));
      }
    }
  }

  // --------------------------------------------------------------------------
  // TÀI LIỆU (Documents)
  // --------------------------------------------------------------------------

  // Điều kiện tìm kiếm tái sử dụng, giống onlyShowTransactionBasedOnSearchQuery
  Expression<bool> onlyShowBasedOnSearchQuery(String? searchFor) {
    final term = normalizeForSearch(searchFor ?? '');
    if (term.isEmpty) return const Constant(true);
    // Dùng instr() thay vì LIKE để ký tự % và _ người dùng gõ không thành ký tự đại diện
    return FunctionCallExpression<int>('instr', [
      documents.searchText,
      Variable.withString(term),
    ]).isBiggerThanValue(0);
  }

  Expression<bool> onlyShowBasedOnTypes(List<DocumentType>? types) {
    if (types == null || types.isEmpty) return const Constant(true);
    return documents.type.isIn(types.map((t) => t.index));
  }

  Expression<bool> onlyShowBasedOnSubjects(List<String>? subjectFks) {
    if (subjectFks == null || subjectFks.isEmpty) return const Constant(true);
    return documents.subjectFk.isIn(subjectFks);
  }

  JoinedSelectStatement<HasResultSet, dynamic> _documentsQuery({
    String? searchFor,
    List<DocumentType>? types,
    List<String>? subjectFks,
    bool onlyPinned = false,
    DocumentSort sort = DocumentSort.newest,
  }) {
    final OrderingTerm sortTerm = switch (sort) {
      DocumentSort.newest => OrderingTerm.desc(documents.dateCreated),
      DocumentSort.oldest => OrderingTerm.asc(documents.dateCreated),
      DocumentSort.titleAZ => OrderingTerm.asc(documents.sortTitle),
      // Tài liệu không có hạn nộp xếp cuối
      DocumentSort.dueDate => OrderingTerm(
        expression: documents.dueDate,
        nulls: NullsOrder.last,
      ),
    };
    return select(documents).join([
        innerJoin(subjects, subjects.subjectPk.equalsExp(documents.subjectFk)),
      ])
      ..where(
        onlyShowBasedOnSearchQuery(searchFor) &
            onlyShowBasedOnTypes(types) &
            onlyShowBasedOnSubjects(subjectFks) &
            (onlyPinned ? documents.pinned.equals(true) : const Constant(true)),
      )
      ..orderBy([
        OrderingTerm.desc(documents.pinned),
        sortTerm,
        OrderingTerm.desc(documents.dateCreated),
      ]);
  }

  List<DocumentWithSubject> _readDocumentRows(List<TypedResult> rows) {
    return rows
        .map(
          (row) => DocumentWithSubject(
            document: row.readTable(documents),
            subject: row.readTable(subjects),
          ),
        )
        .toList();
  }

  Stream<List<DocumentWithSubject>> watchDocuments({
    String? searchFor,
    List<DocumentType>? types,
    List<String>? subjectFks,
    bool onlyPinned = false,
    DocumentSort sort = DocumentSort.newest,
  }) {
    return _documentsQuery(
      searchFor: searchFor,
      types: types,
      subjectFks: subjectFks,
      onlyPinned: onlyPinned,
      sort: sort,
    ).watch().map(_readDocumentRows);
  }

  Future<List<DocumentWithSubject>> getDocuments({
    String? searchFor,
    List<DocumentType>? types,
    List<String>? subjectFks,
    bool onlyPinned = false,
    DocumentSort sort = DocumentSort.newest,
  }) async {
    final rows = await _documentsQuery(
      searchFor: searchFor,
      types: types,
      subjectFks: subjectFks,
      onlyPinned: onlyPinned,
      sort: sort,
    ).get();
    return _readDocumentRows(rows);
  }

  Future<Document?> tryGetDocument(String documentPk) {
    return (select(
      documents,
    )..where((d) => d.documentPk.equals(documentPk))).getSingleOrNull();
  }

  // Thống kê số tài liệu theo loại (cho phần thống kê nhanh ở trang chủ)
  Stream<Map<DocumentType, int>> watchCountByType() {
    final count = documents.documentPk.count();
    final query = selectOnly(documents)
      ..addColumns([documents.type, count])
      ..groupBy([documents.type]);
    return query.watch().map((rows) {
      final result = {for (final t in DocumentType.values) t: 0};
      for (final row in rows) {
        result[DocumentType.values[row.read(documents.type)!]] =
            row.read(count) ?? 0;
      }
      return result;
    });
  }

  // Thêm mới (insert = true) hoặc cập nhật tài liệu. Trả về khoá chính.
  // Mọi quy tắc nghiệp vụ được áp ở đây, giống createOrUpdateTransaction của Cashew.
  Future<String> createOrUpdateDocument(
    Document document, {
    bool insert = false,
  }) async {
    final title = document.title.trim();
    if (title.isEmpty) throw const DocumentValidationException('title-empty');
    if (title.length > TITLE_LIMIT) {
      throw const DocumentValidationException('title-too-long');
    }
    if (await tryGetSubject(document.subjectFk) == null) {
      throw const DocumentValidationException('subject-not-found');
    }

    final link = _emptyToNull(document.link);
    if (link != null && link.contains('://')) {
      final uri = Uri.tryParse(link);
      if (uri == null || uri.host.isEmpty) {
        throw const DocumentValidationException('link-invalid');
      }
    }
    final description = _emptyToNull(document.description);
    final author = _emptyToNull(document.author);
    // Chỉ bài tập mới có hạn nộp
    final dueDate = document.type == DocumentType.assignment
        ? document.dueDate
        : null;

    final documentPk = insert ? uuid.v4() : document.documentPk;
    final companion = document
        .copyWith(
          documentPk: documentPk,
          title: title,
          description: Value(description),
          link: Value(link),
          author: Value(author),
          dueDate: Value(dueDate),
          sortTitle: normalizeForSearch(title),
          searchText: normalizeForSearch(
            [title, description, author, link].whereType<String>().join(' '),
          ),
          dateCreated: insert ? DateTime.now() : document.dateCreated,
          dateTimeModified: Value(DateTime.now()),
        )
        // toCompanion(false): cột null được ghi là NULL. Với true, drift coi null là
        // "không đổi" và UPSERT sẽ giữ lại giá trị cũ (xoá mô tả khi sửa sẽ không có tác dụng).
        .toCompanion(false);
    await into(documents).insertOnConflictUpdate(companion);
    return documentPk;
  }

  Future<void> togglePinned(String documentPk) async {
    final document = await tryGetDocument(documentPk);
    if (document == null) return;
    await (update(documents)..where((d) => d.documentPk.equals(documentPk)))
        .write(DocumentsCompanion(pinned: Value(!document.pinned)));
  }

  Future<int> deleteDocument(String documentPk) {
    return (delete(
      documents,
    )..where((d) => d.documentPk.equals(documentPk))).go();
  }

  Future<int> deleteDocuments(List<String> documentPks) {
    return (delete(
      documents,
    )..where((d) => d.documentPk.isIn(documentPks))).go();
  }

  Future<void> deleteEverything() {
    return transaction(() async {
      await delete(documents).go();
      await delete(subjects).go();
    });
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
