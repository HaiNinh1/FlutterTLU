import 'package:flutter/material.dart';

import '../colors.dart';
import '../database/tables.dart';
import '../functions.dart';
import '../struct/databaseGlobal.dart';
import '../widgets/framework/pageFramework.dart';
import '../widgets/noResults.dart';
import '../widgets/openPopup.dart';
import '../widgets/openSnackbar.dart';
import 'addSubjectPage.dart';

// Danh sách môn học kèm số tài liệu (giống EditCategoriesPage của Cashew)
class EditSubjectsPage extends StatefulWidget {
  const EditSubjectsPage({super.key});

  @override
  State<EditSubjectsPage> createState() => _EditSubjectsPageState();
}

class _EditSubjectsPageState extends State<EditSubjectsPage> {
  late final Stream<List<SubjectWithCount>> _stream =
      database.watchAllSubjectsWithCount();

  @override
  Widget build(BuildContext context) {
    return PageFramework(
      title: 'Môn học',
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add-subject-button'),
        heroTag: 'add-subject',
        onPressed: () => pushRoute(context, const AddSubjectPage()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm môn học'),
      ),
      slivers: [
        StreamBuilder<List<SubjectWithCount>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            final items = snapshot.data!;
            if (items.isEmpty) {
              return const SliverToBoxAdapter(
                child: NoResults(
                  icon: Icons.school_outlined,
                  message: 'Chưa có môn học nào',
                ),
              );
            }
            return SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final subject = item.subject;
                return ListTile(
                  key: ValueKey(subject.subjectPk),
                  leading: CircleAvatar(
                    backgroundColor: colorFromString(subject.colour),
                    foregroundColor: Colors.white,
                    child: Text(subject.name.characters.first.toUpperCase()),
                  ),
                  title: Text(subject.name),
                  subtitle: Text('${item.documentCount} tài liệu'),
                  onTap: () =>
                      pushRoute(context, AddSubjectPage(subject: subject)),
                  trailing: IconButton(
                    tooltip: 'Xoá môn học',
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => deleteSubjectPopup(
                      context,
                      subject: subject,
                      routesToPopAfterDelete: RoutesToPopAfterDelete.none,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

const String _deleteAllDocuments = '__delete_all__';

// Xoá môn học. Nếu môn còn tài liệu thì hỏi tiếp: chuyển sang môn khác hay
// xoá luôn (giống deleteCategoryPopup/deleteWalletPopup của Cashew).
Future<bool> deleteSubjectPopup(
  BuildContext context, {
  required Subject subject,
  required RoutesToPopAfterDelete routesToPopAfterDelete,
}) async {
  final count =
      (await database.getDocuments(subjectFks: [subject.subjectPk])).length;
  if (!context.mounted) return false;
  final action = await openDeletePopup(
    context,
    title: 'Xoá môn học?',
    subtitle: subject.name,
    description: count == 0 ? null : 'Môn học đang có $count tài liệu.',
  );
  if (action != DeletePopupAction.delete || !context.mounted) return false;

  String? moveTo;
  if (count > 0) {
    final others = (await database.getAllSubjects())
        .where((s) => s.subjectPk != subject.subjectPk)
        .toList();
    if (!context.mounted) return false;
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Xử lý $count tài liệu của môn này'),
        children: [
          for (final other in others)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(other.subjectPk),
              child: Text('Chuyển sang "${other.name}"'),
            ),
          SimpleDialogOption(
            key: const ValueKey('delete-all-documents-option'),
            onPressed: () => Navigator.of(context).pop(_deleteAllDocuments),
            child: Text(
              'Xoá luôn $count tài liệu',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (choice == null) return false;
    moveTo = choice == _deleteAllDocuments ? null : choice;
  }

  if (routesToPopAfterDelete == RoutesToPopAfterDelete.one && context.mounted) {
    popRoute(context);
  }
  await database.deleteSubject(subject.subjectPk,
      moveDocumentsToSubjectPk: moveTo);
  openSnackbar(
    title: 'Đã xoá môn học',
    description: subject.name,
    icon: Icons.delete_rounded,
  );
  return true;
}
