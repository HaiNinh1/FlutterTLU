import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/date_utils.dart';
import '../utils/sample_data.dart';
import '../widgets/day_strip.dart';
import '../widgets/habit_tile.dart';
import '../widgets/progress_header.dart';
import 'habit_form_screen.dart';

/// Màn hình danh sách thói quen + đánh dấu hoàn thành theo ngày.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<HabitProvider>();
    final day = p.selectedDay;
    final isToday = isSameDay(day, today());
    final scheduled = p.scheduledOn(day);
    final others = p.notScheduledOn(day);
    final stats = p.stats;
    final dayStats = stats.day(day);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kỷ luật mỗi ngày',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          formatLongDate(today()),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    key: const ValueKey('menu-more'),
                    onSelected: (v) {
                      if (v == 'sample') p.addSample(buildSampleData());
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'sample',
                        child: Text('Thêm dữ liệu mẫu'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DayStrip(
              selected: day,
              rateOf: (d) => stats.day(d).rate,
              onSelect: p.selectDay,
            ),
          ),
          if (p.habits.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: ProgressHeader(
                  title: isToday
                      ? 'Tiến độ hôm nay'
                      : 'Tiến độ ${formatDate(day)}',
                  done: dayStats.done,
                  total: dayStats.scheduled,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: scheduled.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final h = scheduled[i];
                  return HabitTile(
                    key: ValueKey('tile-${h.id}'),
                    habit: h,
                    done: p.isDone(h, day),
                    streak: stats.currentStreak(h),
                    onToggle: () => p.toggle(h, day),
                    onEdit: () => HabitFormScreen.open(context, habit: h),
                    onDelete: () => p.deleteHabit(h),
                  );
                },
              ),
            ),
            if (others.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Text(
                    'Không có lịch ${isToday ? 'hôm nay' : 'ngày này'}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: others.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final h = others[i];
                    return HabitTile(
                      key: ValueKey('tile-${h.id}'),
                      habit: h,
                      done: false,
                      enabled: false,
                      streak: stats.currentStreak(h),
                      onEdit: () => HabitFormScreen.open(context, habit: h),
                      onDelete: () => p.deleteHabit(h),
                    );
                  },
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: scheme.primaryContainer,
            child: Icon(Icons.flag_rounded, size: 48, color: scheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'Chưa có thói quen nào',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Bắt đầu rèn luyện kỷ luật bằng một thói quen nhỏ mỗi ngày.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            key: const ValueKey('btn-sample'),
            onPressed: () =>
                context.read<HabitProvider>().addSample(buildSampleData()),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Dùng dữ liệu mẫu'),
          ),
        ],
      ),
    );
  }
}

/// Hộp thoại xác nhận xóa, dùng chung cho danh sách và màn hình sửa.
Future<bool> confirmDelete(BuildContext context, Habit h) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.delete_outline_rounded),
      title: const Text('Xóa thói quen?'),
      content: Text(
        '"${h.name}" và toàn bộ lịch sử hoàn thành sẽ bị xóa khỏi thiết bị.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          key: const ValueKey('confirm-delete'),
          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Xóa'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
