import 'package:flutter/material.dart';

import '../../database/tables.dart';
import '../../struct/databaseGlobal.dart';
import '../../struct/documentTypes.dart';

// Thống kê nhanh số tài liệu theo loại; bấm vào thẻ để lọc theo loại đó.
// (Giống cách Cashew tách mỗi khối trang chủ thành một file homePage*.dart)
class HomePageStats extends StatefulWidget {
  const HomePageStats({
    super.key,
    required this.selectedTypes,
    required this.onToggleType,
  });

  final Set<DocumentType> selectedTypes;
  final ValueChanged<DocumentType> onToggleType;

  @override
  State<HomePageStats> createState() => _HomePageStatsState();
}

class _HomePageStatsState extends State<HomePageStats> {
  late final Stream<Map<DocumentType, int>> _stream =
      database.watchCountByType();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<DocumentType, int>>(
      stream: _stream,
      builder: (context, snapshot) {
        final counts = snapshot.data ?? const {};
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final type in DocumentType.values)
                Expanded(
                  child: _StatCard(
                    type: type,
                    count: counts[type] ?? 0,
                    selected: widget.selectedTypes.contains(type),
                    onTap: () => widget.onToggleType(type),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.type,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final DocumentType type;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey('stat-${type.name}'),
      color: selected ? type.color.withValues(alpha: 0.18) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? type.color : Colors.transparent,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(type.icon, color: type.color),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(type.label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
