import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/date_utils.dart';
import 'today_screen.dart' show confirmDelete;

/// Màn hình thêm mới / sửa thói quen.
class HabitFormScreen extends StatefulWidget {
  const HabitFormScreen({super.key, this.habit});

  /// null = thêm mới, khác null = sửa.
  final Habit? habit;

  static Future<void> open(BuildContext context, {Habit? habit}) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => HabitFormScreen(habit: habit)));
  }

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _desc;
  late Frequency _frequency;
  late Set<int> _weekdays;
  TimeOfDay? _reminder;
  late int _color;
  late int _icon;
  String? _weekdayError;

  /// Sau lần bấm lưu đầu tiên, form tự kiểm tra lại mỗi khi người dùng nhập.
  bool _submitted = false;

  bool get _isEdit => widget.habit != null;

  @override
  void initState() {
    super.initState();
    final h = widget.habit;
    _name = TextEditingController(text: h?.name ?? '');
    _desc = TextEditingController(text: h?.description ?? '');
    _frequency = h?.frequency ?? Frequency.daily;
    _weekdays = {...?h?.weekdays};
    if (_weekdays.isEmpty) _weekdays = {1, 2, 3, 4, 5, 6, 7};
    _reminder = h?.reminder;
    _color = h?.colorIndex ?? 0;
    _icon = h?.iconIndex ?? 0;
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  Habit _buildHabit() {
    final base = widget.habit ?? Habit(name: '', createdAt: today());
    return base.copyWith(
      name: _name.text.trim(),
      description: _desc.text.trim(),
      frequency: _frequency,
      weekdays: _frequency == Frequency.weekly
          ? (_weekdays.toList()..sort())
          : const [],
      reminder: _reminder,
      clearReminder: _reminder == null,
      colorIndex: _color,
      iconIndex: _icon,
    );
  }

  Future<void> _save() async {
    final weekdaysOk = _frequency == Frequency.daily || _weekdays.isNotEmpty;
    setState(() {
      _submitted = true;
      _weekdayError = weekdaysOk ? null : 'Chọn ít nhất 1 ngày';
    });
    if (!_form.currentState!.validate() || !weekdaysOk) return;
    final p = context.read<HabitProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final habit = _buildHabit();
    if (_isEdit) {
      await p.updateHabit(habit);
    } else {
      await p.addHabit(habit);
    }
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          _isEdit
              ? 'Đã lưu thay đổi "${habit.name}"'
              : 'Đã thêm thói quen "${habit.name}"',
        ),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final h = widget.habit!;
    if (!await confirmDelete(context, h) || !mounted) return;
    final p = context.read<HabitProvider>();
    Navigator.pop(context);
    await p.deleteHabit(h);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _reminder ?? const TimeOfDay(hour: 20, minute: 0),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'Chọn giờ nhắc nhở',
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (t != null) setState(() => _reminder = t);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = habitColors[_color];
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Sửa thói quen' : 'Thói quen mới'),
        actions: [
          if (_isEdit)
            IconButton(
              key: const ValueKey('btn-delete'),
              tooltip: 'Xóa',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: Form(
        key: _form,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            // Xem trước
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(habitIcons[_icon], color: color, size: 38),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('field-name'),
              controller: _name,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Tên thói quen *',
                hintText: 'VD: Đọc sách 20 phút',
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên' : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              key: const ValueKey('field-desc'),
              controller: _desc,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                hintText: 'Mục tiêu, cách thực hiện...',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const _Section('Tần suất'),
            SegmentedButton<Frequency>(
              segments: const [
                ButtonSegment(
                  value: Frequency.daily,
                  label: Text('Hằng ngày', key: ValueKey('freq-daily')),
                  icon: Icon(Icons.today_rounded),
                ),
                ButtonSegment(
                  value: Frequency.weekly,
                  label: Text('Ngày cụ thể', key: ValueKey('freq-weekly')),
                  icon: Icon(Icons.date_range_rounded),
                ),
              ],
              selected: {_frequency},
              onSelectionChanged: (s) => setState(() => _frequency = s.first),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: _frequency == Frequency.weekly
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var wd = 1; wd <= 7; wd++)
                                _DayChip(
                                  key: ValueKey('weekday-$wd'),
                                  label: weekdayShort(wd),
                                  selected: _weekdays.contains(wd),
                                  color: scheme.primary,
                                  onTap: () => setState(() {
                                    _weekdays.contains(wd)
                                        ? _weekdays.remove(wd)
                                        : _weekdays.add(wd);
                                  }),
                                ),
                            ],
                          ),
                          if (_weekdayError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _weekdayError!,
                                style: TextStyle(color: scheme.error),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const _Section('Nhắc nhở'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    key: const ValueKey('reminder-switch'),
                    secondary: const Icon(Icons.alarm_rounded),
                    title: const Text('Bật nhắc nhở'),
                    subtitle: const Text('Thông báo khi đến giờ'),
                    value: _reminder != null,
                    onChanged: (on) => setState(
                      () => _reminder = on
                          ? const TimeOfDay(hour: 20, minute: 0)
                          : null,
                    ),
                  ),
                  if (_reminder != null) ...[
                    const Divider(height: 1),
                    Semantics(
                      container: true,
                      button: true,
                      label: 'Giờ nhắc ${formatTime(_reminder!)}',
                      excludeSemantics: true,
                      child: ListTile(
                        key: const ValueKey('reminder-time'),
                        leading: const Icon(Icons.schedule_rounded),
                        title: const Text('Giờ nhắc'),
                        trailing: Text(
                          formatTime(_reminder!),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                          ),
                        ),
                        onTap: _pickTime,
                      ),
                    ),
                    if (_isEdit)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            key: const ValueKey('btn-test-reminder'),
                            onPressed: () {
                              final p = context.read<HabitProvider>();
                              p.reminders?.notifyNow(_buildHabit());
                            },
                            icon: const Icon(
                              Icons.notifications_active_outlined,
                            ),
                            label: const Text('Gửi thử nhắc nhở'),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            const _Section('Màu sắc'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < habitColors.length; i++)
                  _TapTarget(
                    key: ValueKey('color-$i'),
                    label: 'Màu ${i + 1}',
                    onTap: () => setState(() => _color = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: habitColors[i],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == i ? Colors.black87 : Colors.white,
                          width: 3,
                        ),
                      ),
                      child: _color == i
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            const _Section('Biểu tượng'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var i = 0; i < habitIcons.length; i++)
                  _TapTarget(
                    key: ValueKey('icon-$i'),
                    label: 'Biểu tượng ${i + 1}',
                    onTap: () => setState(() => _icon = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _icon == i ? color : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        habitIcons[i],
                        color: _icon == i ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            key: const ValueKey('btn-save'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: _save,
            icon: const Icon(Icons.save_rounded),
            label: Text(_isEdit ? 'Lưu thay đổi' : 'Thêm thói quen'),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

/// Vùng chạm có nhãn semantics (trình đọc màn hình đọc được).
class _TapTarget extends StatelessWidget {
  const _TapTarget({
    super.key,
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: GestureDetector(onTap: onTap, child: child),
  );
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapTarget(
      label: label,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
