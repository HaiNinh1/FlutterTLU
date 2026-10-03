import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/tables.dart';
import '../functions.dart';
import '../struct/databaseGlobal.dart';
import '../struct/documentTypes.dart';
import '../widgets/framework/pageFramework.dart';
import '../widgets/noResults.dart';
import '../widgets/openPopup.dart';
import '../widgets/openSnackbar.dart';
import 'addSubjectPage.dart';

// Trang THÊM và SỬA tài liệu dùng chung một widget (giống AddTransactionPage):
// - document == null  -> thêm mới
// - document != null  -> sửa tài liệu đó
// Trang chỉ thu thập dữ liệu nhập; kiểm tra hợp lệ và lưu do tầng database đảm nhận.
class AddDocumentPage extends StatefulWidget {
  const AddDocumentPage({super.key, this.document});

  final Document? document;

  @override
  State<AddDocumentPage> createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocumentPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _linkController;
  late final TextEditingController _authorController;
  late DocumentType _type;
  String? _subjectFk;
  DateTime? _dueDate;
  late bool _pinned;
  String? _titleError;
  bool _saving = false;

  bool get _isEditing => widget.document != null;

  @override
  void initState() {
    super.initState();
    final document = widget.document;
    _titleController = TextEditingController(text: document?.title ?? '');
    _descriptionController =
        TextEditingController(text: document?.description ?? '');
    _linkController = TextEditingController(text: document?.link ?? '');
    _authorController = TextEditingController(text: document?.author ?? '');
    _type = document?.type ?? DocumentType.lecture;
    _subjectFk = document?.subjectFk;
    _dueDate = document?.dueDate;
    _pinned = document?.pinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  // Dựng đối tượng Document từ trạng thái form (giống createTransaction() của Cashew)
  Document _createDocument() {
    final original = widget.document;
    return Document(
      documentPk: original?.documentPk ?? '-1',
      title: _titleController.text,
      description: _descriptionController.text,
      type: _type,
      subjectFk: _subjectFk ?? '',
      link: _linkController.text,
      author: _authorController.text,
      dueDate: _type == DocumentType.assignment ? _dueDate : null,
      pinned: _pinned,
      searchText: original?.searchText ?? '',
      sortTitle: original?.sortTitle ?? '',
      dateCreated: original?.dateCreated ?? DateTime.now(),
      dateTimeModified: original?.dateTimeModified,
    );
  }

  bool get _hasChanges {
    final original = widget.document;
    if (original == null) {
      return _titleController.text.trim().isNotEmpty ||
          _descriptionController.text.trim().isNotEmpty ||
          _linkController.text.trim().isNotEmpty ||
          _authorController.text.trim().isNotEmpty;
    }
    final current = _createDocument();
    return current.title.trim() != original.title ||
        current.description!.trim() != (original.description ?? '') ||
        current.link!.trim() != (original.link ?? '') ||
        current.author!.trim() != (original.author ?? '') ||
        current.type != original.type ||
        current.subjectFk != original.subjectFk ||
        current.dueDate != original.dueDate ||
        current.pinned != original.pinned;
  }

  Future<void> _onBack() async {
    if (!_hasChanges || await discardChangesPopup(context)) {
      if (mounted) popRoute(context);
    }
  }

  Future<void> _save() async {
    if (_saving) return; // chặn bấm "Thêm" hai lần
    setState(() {
      _saving = true;
      _titleError = null;
    });
    try {
      await database.createOrUpdateDocument(_createDocument(),
          insert: !_isEditing);
      if (!mounted) return;
      popRoute(context);
      openSnackbar(
        title: _isEditing ? 'Đã lưu thay đổi' : 'Đã thêm tài liệu',
        description: _titleController.text.trim(),
        icon: Icons.check_circle_rounded,
      );
    } on DocumentValidationException catch (e) {
      final message = validationMessage(e.code);
      if (mounted && e.code.startsWith('title')) {
        setState(() => _titleError = message);
      }
      openSnackbar(title: message, icon: Icons.error_outline_rounded);
      if (mounted) setState(() => _saving = false);
    } catch (e) {
      openSnackbar(
          title: 'Không lưu được tài liệu',
          description: '$e',
          icon: Icons.error_outline_rounded);
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<List<Subject>>();
    // Chưa chọn môn, hoặc môn đang chọn vừa bị xoá -> chọn môn đầu tiên
    if (!subjects.any((s) => s.subjectPk == _subjectFk)) {
      _subjectFk = subjects.isEmpty ? null : subjects.first.subjectPk;
    }

    return PageFramework(
      title: _isEditing ? 'Sửa tài liệu' : 'Thêm tài liệu',
      showBackButton: true,
      onBackButton: _onBack,
      actions: [
        if (_isEditing)
          IconButton(
            key: const ValueKey('delete-document-button'),
            tooltip: 'Xoá tài liệu',
            icon: const Icon(Icons.delete_rounded),
            onPressed: () => deleteDocumentPopup(
              context,
              document: widget.document!,
              routesToPopAfterDelete: RoutesToPopAfterDelete.one,
            ),
          ),
      ],
      floatingActionButton: subjects.isEmpty
          ? null
          : FloatingActionButton.extended(
              key: const ValueKey('save-document-button'),
              heroTag: 'save-document',
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check_rounded),
              label: Text(_isEditing ? 'Lưu thay đổi' : 'Thêm'),
            ),
      slivers: [
        if (subjects.isEmpty)
          SliverToBoxAdapter(
            child: NoResults(
              icon: Icons.school_outlined,
              message: 'Cần tạo ít nhất một môn học trước khi thêm tài liệu.',
              action: FilledButton.icon(
                onPressed: () => pushRoute(context, const AddSubjectPage()),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Thêm môn học'),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.list(
              children: [
                TextField(
                  key: const ValueKey('title-field'),
                  controller: _titleController,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Tên tài liệu *',
                    errorText: _titleError,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Loại tài liệu',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                SegmentedButton<DocumentType>(
                  segments: [
                    for (final type in DocumentType.values)
                      ButtonSegment(
                        value: type,
                        icon: Icon(type.icon),
                        label: Text(type.label),
                      ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (value) =>
                      setState(() => _type = value.first),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  // Chỉ dựng lại ô chọn khi danh sách môn thay đổi
                  key: ValueKey(subjects.map((s) => s.subjectPk).join()),
                  initialValue: _subjectFk,
                  decoration: const InputDecoration(
                    labelText: 'Môn học',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final subject in subjects)
                      DropdownMenuItem(
                        value: subject.subjectPk,
                        child: Text(subject.name),
                      ),
                  ],
                  onChanged: (value) => setState(() => _subjectFk = value),
                ),
                if (_type == DocumentType.assignment) ...[
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_rounded),
                    title: const Text('Hạn nộp'),
                    subtitle: Text(_dueDate == null
                        ? 'Chưa đặt'
                        : '${formatDate(_dueDate!)} · ${describeDueDate(_dueDate!)}'),
                    onTap: _pickDueDate,
                    trailing: _dueDate == null
                        ? const Icon(Icons.chevron_right_rounded)
                        : IconButton(
                            tooltip: 'Bỏ hạn nộp',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(() => _dueDate = null),
                          ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('description-field'),
                  controller: _descriptionController,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả / ghi chú',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('link-field'),
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Đường dẫn tệp hoặc URL',
                    prefixIcon: Icon(Icons.link_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('author-field'),
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Tác giả / giảng viên',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ghim lên đầu danh sách'),
                  value: _pinned,
                  onChanged: (value) => setState(() => _pinned = value),
                ),
                if (_isEditing)
                  Text(
                    'Tạo lúc ${formatDateTime(widget.document!.dateCreated)}'
                    '${widget.document!.dateTimeModified == null ? '' : ' · Sửa lúc ${formatDateTime(widget.document!.dateTimeModified!)}'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// Hộp thoại xác nhận xoá tài liệu, đặt cạnh trang của thực thể giống
// deleteTransactionPopup của Cashew. Có nút "Hoàn tác" trên snackbar.
Future<DeletePopupAction?> deleteDocumentPopup(
  BuildContext context, {
  required Document document,
  required RoutesToPopAfterDelete routesToPopAfterDelete,
}) async {
  final action = await openDeletePopup(
    context,
    title: 'Xoá tài liệu?',
    subtitle: document.title,
  );
  if (action != DeletePopupAction.delete) return action;
  if (routesToPopAfterDelete == RoutesToPopAfterDelete.one && context.mounted) {
    popRoute(context);
  }
  await database.deleteDocument(document.documentPk);
  openSnackbar(
    title: 'Đã xoá tài liệu',
    description: document.title,
    icon: Icons.delete_rounded,
    actionLabel: 'Hoàn tác',
    onAction: () async {
      try {
        await database.createOrUpdateDocument(document);
      } on DocumentValidationException catch (e) {
        openSnackbar(title: validationMessage(e.code));
      }
    },
  );
  return action;
}
