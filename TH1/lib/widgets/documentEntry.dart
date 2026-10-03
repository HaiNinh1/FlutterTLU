import 'package:flutter/material.dart';

import '../colors.dart';
import '../database/tables.dart';
import '../functions.dart';
import '../struct/documentTypes.dart';

// Một dòng tài liệu trong danh sách (giống widgets/transactionEntry của Cashew).
// Widget KHÔNG import pages/: hành động mở/xoá được truyền vào qua callback,
// nên widget tái sử dụng được ở bất kỳ trang nào.
class DocumentEntry extends StatelessWidget {
  const DocumentEntry({
    super.key,
    required this.item,
    required this.onTap,
    this.onTogglePinned,
    this.onDelete,
    this.showDescription = true,
  });

  final DocumentWithSubject item;
  final VoidCallback onTap;
  final VoidCallback? onTogglePinned;
  final VoidCallback? onDelete;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final document = item.document;
    final colors = Theme.of(context).colorScheme;
    final subjectColour = colorFromString(item.subject.colour);
    final dueDate = document.dueDate;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: document.type.color.withValues(alpha: 0.15),
                foregroundColor: document.type.color,
                child: Icon(document.type.icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _Tag(label: item.subject.name, colour: subjectColour),
                        _Tag(
                            label: document.type.label,
                            colour: document.type.color),
                        if (dueDate != null)
                          _Tag(
                            label: describeDueDate(dueDate),
                            colour:
                                isOverdue(dueDate) ? colors.error : Colors.teal,
                            icon: Icons.event_rounded,
                          ),
                      ],
                    ),
                    if (showDescription && document.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        document.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                    if (document.link != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        document.link!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.primary, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTogglePinned != null)
                IconButton(
                  tooltip: document.pinned ? 'Bỏ ghim' : 'Ghim',
                  onPressed: onTogglePinned,
                  icon: Icon(
                    document.pinned
                        ? Icons.push_pin_rounded
                        : Icons.push_pin_outlined,
                    color: document.pinned ? colors.primary : null,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'Xoá',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.colour, this.icon});

  final String label;
  final Color colour;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: colour),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(color: colour, fontSize: 12)),
        ],
      ),
    );
  }
}
