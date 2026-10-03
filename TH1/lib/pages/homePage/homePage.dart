import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/tables.dart';
import '../../functions.dart';
import '../../struct/databaseGlobal.dart';
import '../../struct/documentTypes.dart';
import '../../struct/settings.dart';
import '../../widgets/documentEntry.dart';
import '../../widgets/framework/pageFramework.dart';
import '../../widgets/noResults.dart';
import '../../widgets/openPopup.dart';
import '../addDocumentPage.dart';
import 'homePageFilters.dart';
import 'homePageStats.dart';

// Trang danh sách tài liệu: tìm kiếm + lọc + danh sách.
// Đọc dữ liệu bằng StreamBuilder trên database.watchDocuments(...) nên mọi
// thao tác thêm/sửa/xoá ở trang khác tự phản ánh về đây, không cần làm mới tay.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  final Set<DocumentType> _selectedTypes = {};
  final Set<String> _selectedSubjects = {};

  Stream<List<DocumentWithSubject>>? _stream;
  String? _streamKey;

  // Chỉ tạo stream mới khi điều kiện lọc thay đổi
  Stream<List<DocumentWithSubject>> _documentsStream(
      List<String> subjectFks, DocumentSort sort) {
    final types = _selectedTypes.map((t) => t.index).toList()..sort();
    final key = '$_searchValue|$types|${[...subjectFks]..sort()}|${sort.name}';
    if (key != _streamKey || _stream == null) {
      _streamKey = key;
      _stream = database.watchDocuments(
        searchFor: _searchValue,
        types: _selectedTypes.toList(),
        subjectFks: subjectFks,
        sort: sort,
      );
    }
    return _stream!;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<List<Subject>>();
    // Bỏ các môn đã bị xoá khỏi bộ lọc
    final activeSubjectFks = _selectedSubjects
        .where((pk) => subjects.any((s) => s.subjectPk == pk))
        .toList();

    return PageFramework(
      title: 'Tài liệu học tập',
      actions: [
        ValueListenableBuilder<int>(
          valueListenable: settingsVersion,
          builder: (context, _, _) => PopupMenuButton<DocumentSort>(
            tooltip: 'Sắp xếp',
            icon: const Icon(Icons.sort_rounded),
            initialValue: getDocumentSort(),
            onSelected: (sort) => updateSettings('documentSort', sort.name,
                updateGlobalState: false),
            itemBuilder: (context) => [
              for (final sort in DocumentSort.values)
                PopupMenuItem(value: sort, child: Text(sort.label)),
            ],
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add-document-button'),
        heroTag: 'add-document',
        onPressed: () => pushRoute(context, const AddDocumentPage()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm tài liệu'),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              key: const ValueKey('search-field'),
              controller: _searchController,
              onChanged: (value) => setState(() => _searchValue = value),
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, mô tả, tác giả, đường dẫn...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
                suffixIcon: _searchValue.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Xoá tìm kiếm',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() {
                          _searchController.clear();
                          _searchValue = '';
                        }),
                      ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HomePageStats(
            selectedTypes: _selectedTypes,
            onToggleType: (type) => setState(() {
              if (!_selectedTypes.remove(type)) _selectedTypes.add(type);
            }),
          ),
        ),
        SliverToBoxAdapter(
          child: HomePageFilters(
            subjects: subjects,
            selectedSubjectFks: activeSubjectFks.toSet(),
            onToggleSubject: (pk) => setState(() {
              if (!_selectedSubjects.remove(pk)) _selectedSubjects.add(pk);
            }),
          ),
        ),
        // Cài đặt sắp xếp / hiện mô tả đổi -> vẽ lại danh sách
        ValueListenableBuilder<int>(
          valueListenable: settingsVersion,
          builder: (context, _, _) => StreamBuilder<List<DocumentWithSubject>>(
            stream: _documentsStream(activeSubjectFks, getDocumentSort()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              final items = snapshot.data!;
              if (items.isEmpty) {
                final filtering = _searchValue.isNotEmpty ||
                    _selectedTypes.isNotEmpty ||
                    activeSubjectFks.isNotEmpty;
                return SliverToBoxAdapter(
                  child: NoResults(
                    icon: filtering ? null : Icons.folder_open_rounded,
                    message: filtering
                        ? 'Không tìm thấy tài liệu phù hợp'
                        : 'Chưa có tài liệu nào.\nBấm "Thêm tài liệu" để bắt đầu.',
                  ),
                );
              }
              final showDescription =
                  appStateSettings['showDescriptionInList'] == true;
              return SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return DocumentEntry(
                    key: ValueKey(item.document.documentPk),
                    item: item,
                    showDescription: showDescription,
                    onTap: () => pushRoute(
                        context, AddDocumentPage(document: item.document)),
                    onTogglePinned: () =>
                        database.togglePinned(item.document.documentPk),
                    onDelete: () => deleteDocumentPopup(
                      context,
                      document: item.document,
                      routesToPopAfterDelete: RoutesToPopAfterDelete.none,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
