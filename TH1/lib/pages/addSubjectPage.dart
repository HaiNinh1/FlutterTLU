import 'package:flutter/material.dart';

import '../colors.dart';
import '../database/tables.dart';
import '../functions.dart';
import '../struct/databaseGlobal.dart';
import '../struct/documentTypes.dart';
import '../widgets/framework/pageFramework.dart';
import '../widgets/openPopup.dart';
import '../widgets/openSnackbar.dart';
import '../widgets/selectColour.dart';
import 'editSubjectsPage.dart';

// Thêm / sửa môn học (giống AddCategoryPage của Cashew)
class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key, this.subject});

  final Subject? subject;

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.subject?.name ?? '');
  late String _colour = widget.subject?.colour ?? selectableColours.first;
  String? _nameError;
  bool _saving = false;

  bool get _isEditing => widget.subject != null;

  bool get _hasChanges {
    final original = widget.subject;
    if (original == null) return _nameController.text.trim().isNotEmpty;
    return _nameController.text.trim() != original.name ||
        _colour != original.colour;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return; // chặn bấm "Thêm" hai lần
    _saving = true;
    final original = widget.subject;
    final subject = Subject(
      subjectPk: original?.subjectPk ?? '-1',
      name: _nameController.text,
      colour: _colour,
      order: original?.order ?? 0,
      dateCreated: original?.dateCreated ?? DateTime.now(),
      dateTimeModified: original?.dateTimeModified,
    );
    try {
      await database.createOrUpdateSubject(subject, insert: !_isEditing);
      if (!mounted) return;
      popRoute(context);
      openSnackbar(
        title: _isEditing ? 'Đã lưu môn học' : 'Đã thêm môn học',
        description: _nameController.text.trim(),
        icon: Icons.check_circle_rounded,
      );
    } on DocumentValidationException catch (e) {
      _saving = false;
      if (mounted) setState(() => _nameError = validationMessage(e.code));
    } catch (e) {
      _saving = false;
      openSnackbar(
          title: 'Không lưu được môn học',
          description: '$e',
          icon: Icons.error_outline_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFramework(
      title: _isEditing ? 'Sửa môn học' : 'Thêm môn học',
      showBackButton: true,
      onBackButton: () async {
        if (!_hasChanges || await discardChangesPopup(context)) {
          if (context.mounted) popRoute(context);
        }
      },
      actions: [
        if (_isEditing)
          IconButton(
            tooltip: 'Xoá môn học',
            icon: const Icon(Icons.delete_rounded),
            onPressed: () => deleteSubjectPopup(
              context,
              subject: widget.subject!,
              routesToPopAfterDelete: RoutesToPopAfterDelete.one,
            ),
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('save-subject-button'),
        heroTag: 'save-subject',
        onPressed: _save,
        icon: const Icon(Icons.check_rounded),
        label: Text(_isEditing ? 'Lưu thay đổi' : 'Thêm'),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.list(
            children: [
              TextField(
                key: const ValueKey('subject-name-field'),
                controller: _nameController,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Tên môn học *',
                  errorText: _nameError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Màu', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              SelectColour(
                selected: _colour,
                onSelected: (colour) => setState(() => _colour = colour),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
