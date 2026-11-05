import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../screens/today_screen.dart' show confirmDelete;
import '../utils/date_utils.dart';

/// Một thẻ thói quen: biểu tượng, tên, tần suất, giờ nhắc, chuỗi ngày và
/// nút tròn để đánh dấu hoàn thành. Vuốt sang trái để xóa.
class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.done,
    required this.streak,
    this.enabled = true,
    this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Habit habit;
  final bool done;
  final int streak;
  final bool enabled;
  final VoidCallback? onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final h = habit;
    final card = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onEdit,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border(
                left: done
                    ? BorderSide(color: h.color, width: 6)
                    : BorderSide.none,
              ),
              color: done ? h.color.withValues(alpha: 0.08) : null,
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: h.color.withValues(alpha: 0.15),
                  child: Icon(h.icon, color: h.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: h.color,
                          color: done ? Colors.grey.shade700 : Colors.black87,
                        ),
                      ),
                      if (h.description.isNotEmpty)
                        Text(
                          h.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _Chip(Icons.repeat_rounded, h.frequencyText),
                          if (h.reminder != null)
                            _Chip(Icons.alarm_rounded, formatTime(h.reminder!)),
                          if (streak > 0)
                            _Chip(
                              Icons.local_fire_department_rounded,
                              '$streak ngày',
                              color: Colors.deepOrange,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (enabled)
                  _CheckButton(
                    key: ValueKey('check-${h.id}'),
                    label: done
                        ? 'Bỏ đánh dấu ${h.name}'
                        : 'Hoàn thành ${h.name}',
                    done: done,
                    color: h.color,
                    onTap: onToggle,
                  ),
                PopupMenuButton<String>(
                  key: ValueKey('menu-${h.id}'),
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (v) async {
                    if (v == 'edit') onEdit();
                    if (v == 'delete' && await confirmDelete(context, h)) {
                      onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_rounded),
                        title: Text('Sửa'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline_rounded),
                        title: Text('Xóa'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Dismissible(
      key: ValueKey('dismiss-${h.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => confirmDelete(context, h),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white),
            SizedBox(width: 6),
            Text(
              'Xóa',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      child: card,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.text, {this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: c)),
        ],
      ),
    );
  }
}

/// Nút tròn đánh dấu hoàn thành, có hiệu ứng phóng to khi bấm.
class _CheckButton extends StatelessWidget {
  const _CheckButton({
    super.key,
    required this.done,
    required this.color,
    required this.label,
    this.onTap,
  });

  final String label;
  final bool done;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: TweenAnimationBuilder<double>(
          key: ValueKey(done),
          tween: Tween(begin: 0.6, end: 1),
          duration: const Duration(milliseconds: 450),
          curve: Curves.elasticOut,
          builder: (_, s, child) => Transform.scale(scale: s, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? color : Colors.transparent,
              border: Border.all(color: color, width: 2.5),
            ),
            child: Icon(
              Icons.check_rounded,
              color: done ? Colors.white : color.withValues(alpha: 0.35),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
