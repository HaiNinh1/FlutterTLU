import 'package:flutter/material.dart';

import '../database/initializeDefaultDatabase.dart';
import '../database/tables.dart';
import '../struct/databaseGlobal.dart';
import '../struct/documentTypes.dart';
import '../struct/settings.dart';
import '../widgets/framework/pageFramework.dart';
import '../widgets/openPopup.dart';
import '../widgets/openSnackbar.dart';
import '../widgets/selectColour.dart';

// Trang cài đặt: mọi thay đổi đi qua updateSettings() của tầng struct
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: settingsVersion,
      builder: (context, _, _) => PageFramework(
        title: 'Cài đặt',
        slivers: [
          SliverList.list(
            children: [
              const _SectionHeader('Giao diện'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: 'system',
                        icon: Icon(Icons.brightness_auto_rounded),
                        label: Text('Hệ thống')),
                    ButtonSegment(
                        value: 'light',
                        icon: Icon(Icons.light_mode_rounded),
                        label: Text('Sáng')),
                    ButtonSegment(
                        value: 'dark',
                        icon: Icon(Icons.dark_mode_rounded),
                        label: Text('Tối')),
                  ],
                  selected: {getThemeMode().name},
                  onSelectionChanged: (value) => updateSettings(
                      'theme', value.first,
                      updateGlobalState: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SelectColour(
                  selected: appStateSettings['accentColor'] as String?,
                  onSelected: (colour) => updateSettings('accentColor', colour,
                      updateGlobalState: true),
                ),
              ),
              const _SectionHeader('Danh sách tài liệu'),
              ListTile(
                leading: const Icon(Icons.sort_rounded),
                title: const Text('Sắp xếp'),
                trailing: DropdownButton<DocumentSort>(
                  value: getDocumentSort(),
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final sort in DocumentSort.values)
                      DropdownMenuItem(value: sort, child: Text(sort.label)),
                  ],
                  onChanged: (sort) {
                    if (sort != null) {
                      updateSettings('documentSort', sort.name,
                          updateGlobalState: false);
                    }
                  },
                ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.notes_rounded),
                title: const Text('Hiện mô tả trong danh sách'),
                value: appStateSettings['showDescriptionInList'] == true,
                onChanged: (value) => updateSettings(
                    'showDescriptionInList', value,
                    updateGlobalState: false),
              ),
              const _SectionHeader('Dữ liệu'),
              ListTile(
                leading: const Icon(Icons.auto_awesome_rounded),
                title: const Text('Tạo dữ liệu mẫu'),
                subtitle: const Text('Chỉ tạo khi chưa có môn học nào'),
                onTap: () async {
                  await initializeDefaultDatabase(database);
                  openSnackbar(
                      title: 'Đã kiểm tra dữ liệu mẫu',
                      icon: Icons.auto_awesome_rounded);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever_rounded,
                    color: Theme.of(context).colorScheme.error),
                title: const Text('Xoá toàn bộ dữ liệu'),
                onTap: () async {
                  final action = await openDeletePopup(
                    context,
                    title: 'Xoá toàn bộ dữ liệu?',
                    description:
                        'Tất cả môn học và tài liệu sẽ bị xoá vĩnh viễn.',
                  );
                  if (action == DeletePopupAction.delete) {
                    await database.deleteEverything();
                    openSnackbar(
                        title: 'Đã xoá toàn bộ dữ liệu',
                        icon: Icons.delete_rounded);
                  }
                },
              ),
              const _SectionHeader('Giới thiệu'),
              const ListTile(
                leading: Icon(Icons.account_tree_rounded),
                title: Text('Kiến trúc Cashew'),
                subtitle: Text(
                    'database/ → struct/ → widgets/ → pages/\n'
                    'Dữ liệu SQLite (drift), cài đặt SharedPreferences, '
                    'giao diện đọc dữ liệu qua Stream.'),
                isThreeLine: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
