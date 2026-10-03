// Kiểm thử TÍNH ĐÚNG ĐẮN CỦA VIỆC PHÂN TÁCH LỚP.
// Đọc toàn bộ lệnh import trong lib/ và khẳng định chiều phụ thuộc:
//
//   pages/  ->  widgets/  ->  struct/  ->  database/
//
// Lớp dưới không bao giờ được import lớp trên. Nếu ai đó vô tình viết
// `import '../pages/...'` trong widgets/ thì test này sẽ đỏ.
//
// Vì mọi cạnh import đều đi xuống và thư mục gốc lib/ chỉ có các file được
// cho phép, phụ thuộc gián tiếp (A -> B -> C) cũng không thể đi ngược lên.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

final String libDir = p.normalize(p.absolute('lib'));

// Tên package đọc từ pubspec.yaml để test không âm thầm "pass" khi đổi tên
final String packagePrefix = 'package:${RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1)}/';

const Set<String> layers = {'database', 'struct', 'widgets', 'pages'};
const Set<String> rootFiles = {'main.dart', 'functions.dart', 'colors.dart'};

// "Tầng" của một file trong lib/: tên thư mục con đầu tiên, hoặc tên file nếu ở gốc
String layerOf(String filePath) =>
    p.split(p.relative(filePath, from: libDir)).first;

class ImportEdge {
  ImportEdge(this.from, this.uri, this.target);

  final String from; // đường dẫn tương đối của file nguồn
  final String uri; // chuỗi import gốc
  final String? target; // tầng đích nếu là file trong lib/, null nếu là package ngoài
}

List<File> dartFiles(String dir) => Directory(dir)
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
    .toList();

List<ImportEdge> collectImports() {
  final edges = <ImportEdge>[];
  // Lấy cả lệnh import nhiều dòng và import có điều kiện:
  // import 'a.dart' if (dart.library.io) 'b.dart';
  final directive =
      RegExp(r'^\s*(?:import|export)\s[^;]*;', multiLine: true);
  final quoted = RegExp(r'''['"]([^'"]+)['"]''');

  for (final file in dartFiles(libDir)) {
    final source = file.readAsStringSync();
    for (final match in directive.allMatches(source)) {
      for (final uriMatch in quoted.allMatches(match.group(0)!)) {
        final uri = uriMatch.group(1)!;
        String? target;
        if (uri.startsWith(packagePrefix)) {
          target = layerOf(p.join(libDir, uri.substring(packagePrefix.length)));
        } else if (!uri.startsWith('package:') && !uri.startsWith('dart:')) {
          target = layerOf(p.normalize(p.join(p.dirname(file.path), uri)));
        }
        edges.add(
            ImportEdge(p.relative(file.path, from: libDir), uri, target));
      }
    }
  }
  return edges;
}

void main() {
  final edges = collectImports();

  List<String> violations(bool Function(ImportEdge e) isViolation) => edges
      .where(isViolation)
      .map((e) => '${e.from} -> ${e.uri}')
      .toList();

  String layerOfEdge(ImportEdge e) => layerOf(p.join(libDir, e.from));

  test('đã đọc được các file của cả 4 tầng', () {
    final found = edges.map(layerOfEdge).toSet();
    expect(found, containsAll(layers));
    expect(edges.where((e) => e.target != null), isNotEmpty);
  });

  test('thư mục gốc lib/ chỉ chứa main.dart, functions.dart, colors.dart', () {
    final entries = Directory(libDir)
        .listSync()
        .map((e) => p.basename(e.path))
        .where((name) => !layers.contains(name))
        .toSet();
    expect(entries, rootFiles);
  });

  test('database/ không phụ thuộc tầng nào khác và không dùng Flutter UI', () {
    expect(
      violations((e) =>
          layerOfEdge(e) == 'database' &&
          ((e.target != null && e.target != 'database') ||
              e.uri.startsWith('package:flutter/'))),
      isEmpty,
    );
  });

  test('struct/ chỉ phụ thuộc database/', () {
    expect(
      violations((e) =>
          layerOfEdge(e) == 'struct' &&
          e.target != null &&
          !{'struct', 'database'}.contains(e.target)),
      isEmpty,
    );
  });

  test('widgets/ không import pages/ hay main.dart', () {
    expect(
      violations((e) =>
          layerOfEdge(e) == 'widgets' &&
          {'pages', 'main.dart'}.contains(e.target)),
      isEmpty,
    );
  });

  test('functions.dart và colors.dart là tiện ích thuần, không phụ thuộc tầng nào',
      () {
    expect(
      violations((e) =>
          {'functions.dart', 'colors.dart'}.contains(e.from) &&
          e.target != null),
      isEmpty,
    );
  });

  test('không file nào import ngược main.dart', () {
    expect(violations((e) => e.target == 'main.dart'), isEmpty);
  });

  test('giao diện (pages/, widgets/) không tự viết truy vấn SQL/drift', () {
    expect(
      violations((e) =>
          {'pages', 'widgets'}.contains(layerOfEdge(e)) &&
          e.uri.startsWith('package:drift')),
      isEmpty,
    );

    // StudyDatabase kế thừa select/delete/customStatement... của drift, nên giao
    // diện có thể gọi thẳng chúng mà không cần import drift -> quét cả lời gọi.
    final queryBuilder = RegExp(
        r'database\s*\.\s*(select|selectOnly|into|update|delete|customStatement|'
        r'customSelect|customUpdate|customInsert|transaction|batch)\s*\(');
    final rawSql = RegExp(
        r'\b(select\s.+\sfrom|insert\s+into|update\s+\w+\s+set|delete\s+from)\b',
        caseSensitive: false);
    final offenders = [
      ...dartFiles(p.join(libDir, 'pages')),
      ...dartFiles(p.join(libDir, 'widgets')),
    ].where((f) {
      final source = f.readAsStringSync();
      return queryBuilder.hasMatch(source) || rawSql.hasMatch(source);
    }).map((f) => p.relative(f.path, from: libDir)).toList();
    expect(offenders, isEmpty);
  });

  test('chỉ main.dart được biết cách mở kết nối CSDL thật', () {
    expect(
      violations((e) =>
          e.uri.endsWith('platform/connection.dart') &&
          e.from != 'main.dart'),
      isEmpty,
    );
  });
}
