import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../services/stats_service.dart';
import '../utils/date_utils.dart';

enum StatsPeriod { day, week, month }

/// Màn hình thống kê tỷ lệ hoàn thành theo ngày, tuần và tháng.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatsPeriod _period = StatsPeriod.week;
  DateTime _anchor = today();

  (DateTime, DateTime) get _range => switch (_period) {
    StatsPeriod.day => (_anchor, _anchor),
    StatsPeriod.week => (
      startOfWeek(_anchor),
      addDays(startOfWeek(_anchor), 6),
    ),
    StatsPeriod.month => (startOfMonth(_anchor), endOfMonth(_anchor)),
  };

  String get _label {
    final (s, e) = _range;
    return switch (_period) {
      StatsPeriod.day =>
        isSameDay(s, today())
            ? 'Hôm nay, ${formatDayMonth(s)}'
            : '${weekdayLong(s.weekday)}, ${formatDayMonth(s)}',
      StatsPeriod.week => 'Tuần ${formatDayMonth(s)} – ${formatDayMonth(e)}',
      StatsPeriod.month => 'Tháng ${s.month}/${s.year}',
    };
  }

  void _shift(int dir) {
    setState(() {
      _anchor = switch (_period) {
        StatsPeriod.day => addDays(_anchor, dir),
        StatsPeriod.week => addDays(_anchor, 7 * dir),
        StatsPeriod.month => DateTime(_anchor.year, _anchor.month + dir, 1),
      };
      if (_anchor.isAfter(today())) _anchor = today();
    });
  }

  bool get _canNext => _range.$2.isBefore(today());

  @override
  Widget build(BuildContext context) {
    final p = context.watch<HabitProvider>();
    final stats = p.stats;
    final (start, end) = _range;
    final total = stats.range(start, end);

    return SafeArea(
      child: ListView(
        key: const ValueKey('stats-list'),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          Text(
            'Thống kê tiến độ',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          SegmentedButton<StatsPeriod>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: StatsPeriod.day,
                label: Text('Ngày', key: ValueKey('period-day')),
              ),
              ButtonSegment(
                value: StatsPeriod.week,
                label: Text('Tuần', key: ValueKey('period-week')),
              ),
              ButtonSegment(
                value: StatsPeriod.month,
                label: Text('Tháng', key: ValueKey('period-month')),
              ),
            ],
            selected: {_period},
            onSelectionChanged: (s) => setState(() {
              _period = s.first;
              _anchor = today();
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                key: const ValueKey('btn-prev'),
                tooltip: 'Kỳ trước',
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  _label,
                  key: const ValueKey('period-label'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('btn-next'),
                tooltip: 'Kỳ sau',
                onPressed: _canNext ? () => _shift(1) : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (p.habits.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                'Chưa có dữ liệu. Hãy thêm thói quen trước.',
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            _SummaryCard(total: total, stats: stats, habits: p.habits),
            const SizedBox(height: 14),
            _ChartCard(
              title: switch (_period) {
                StatsPeriod.day => 'Tỷ lệ 7 ngày gần nhất',
                StatsPeriod.week => 'Tỷ lệ từng ngày trong tuần',
                StatsPeriod.month => 'Lịch hoàn thành trong tháng',
              },
              child: switch (_period) {
                StatsPeriod.day => _DailyBars(
                  stats: stats,
                  days: [for (var i = 6; i >= 0; i--) addDays(_anchor, -i)],
                  highlight: _anchor,
                  labelOf: (d) => formatDayMonth(d),
                ),
                StatsPeriod.week => _DailyBars(
                  stats: stats,
                  days: [for (var i = 0; i < 7; i++) addDays(start, i)],
                  highlight: today(),
                  labelOf: (d) => weekdayShort(d.weekday),
                ),
                StatsPeriod.month => _MonthHeatmap(stats: stats, month: start),
              },
            ),
            const SizedBox(height: 14),
            _ChartCard(
              title: _period == StatsPeriod.day
                  ? 'Chi tiết trong ngày'
                  : 'Tỷ lệ theo từng thói quen',
              child: Column(
                children: [
                  for (final h in p.habits)
                    _period == StatsPeriod.day
                        ? _HabitDayRow(habit: h, stats: stats, day: start)
                        : _HabitRateRow(
                            habit: h,
                            s: stats.habitRange(h, start, end),
                          ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ widgets

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.stats,
    required this.habits,
  });

  final PeriodStats total;
  final StatsService stats;
  final List<Habit> habits;

  @override
  Widget build(BuildContext context) {
    final rate = total.rate;
    var bestName = '-';
    var best = 0;
    for (final h in habits) {
      final b = stats.bestStreak(h);
      if (b > best) {
        best = b;
        bestName = h.name;
      }
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: rate ?? 0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (_, v, _) => Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: v,
                      strokeWidth: 11,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.grey.shade200,
                      color: _rateColor(rate),
                    ),
                    Center(
                      child: Text(
                        rate == null ? '–' : '${(v * 100).round()}%',
                        key: const ValueKey('summary-rate'),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tỷ lệ hoàn thành',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${total.done} / ${total.scheduled} lượt',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Chuỗi kỷ lục: $best ngày',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    bestName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _rateColor(double? r) {
  if (r == null) return Colors.grey;
  if (r >= 0.8) return const Color(0xFF2E7D32);
  if (r >= 0.5) return const Color(0xFF26A69A);
  if (r >= 0.3) return const Color(0xFFF9A825);
  return const Color(0xFFE53935);
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

/// Biểu đồ cột tỷ lệ hoàn thành từng ngày.
class _DailyBars extends StatelessWidget {
  const _DailyBars({
    required this.stats,
    required this.days,
    required this.highlight,
    required this.labelOf,
  });

  final StatsService stats;
  final List<DateTime> days;
  final DateTime highlight;
  final String Function(DateTime) labelOf;

  @override
  Widget build(BuildContext context) {
    final rates = [for (final d in days) stats.day(d).rate];
    return SizedBox(
      height: 190,
      child: BarChart(
        BarChartData(
          maxY: 100,
          minY: 0,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          ),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                interval: 25,
                getTitlesWidget: (v, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    '${v.toInt()}%',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  final r = rates[i];
                  return SideTitleWidget(
                    meta: meta,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          labelOf(days[i]),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSameDay(days[i], highlight)
                                ? FontWeight.w800
                                : FontWeight.w400,
                          ),
                        ),
                        Text(
                          r == null ? '' : '${(r * 100).round()}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < days.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: (rates[i] ?? 0) * 100,
                    width: 22,
                    color: isSameDay(days[i], highlight)
                        ? const Color(0xFFEF6C00)
                        : _rateColor(rates[i]),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
          ],
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}

/// Lịch nhiệt (heatmap) của tháng: ô càng đậm, tỷ lệ hoàn thành càng cao.
class _MonthHeatmap extends StatelessWidget {
  const _MonthHeatmap({required this.stats, required this.month});

  final StatsService stats;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final first = startOfMonth(month);
    final last = endOfMonth(month);
    final lead = first.weekday - 1;
    final cells = <DateTime?>[
      for (var i = 0; i < lead; i++) null,
      for (var d = first; !d.isAfter(last); d = addDays(d, 1)) d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    const base = Color(0xFF26A69A);
    return Column(
      children: [
        Row(
          children: [
            for (var wd = 1; wd <= 7; wd++)
              Expanded(
                child: Center(
                  child: Text(
                    weekdayShort(wd),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var r = 0; r < cells.length / 7; r++)
          Row(
            children: [
              for (final d in cells.skip(r * 7).take(7))
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: d == null
                        ? const SizedBox()
                        : _HeatCell(
                            day: d,
                            rate: stats.day(d).rate,
                            base: base,
                          ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Ít',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            for (final a in [0.15, 0.4, 0.65, 1.0])
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: base.withValues(alpha: a),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            Text(
              'Nhiều',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeatCell extends StatelessWidget {
  const _HeatCell({required this.day, required this.rate, required this.base});

  final DateTime day;
  final double? rate;
  final Color base;

  @override
  Widget build(BuildContext context) {
    final future = day.isAfter(today());
    final r = rate;
    final color = future || r == null
        ? Colors.grey.shade100
        : base.withValues(alpha: 0.12 + 0.88 * r);
    final isToday = isSameDay(day, today());
    return Container(
      margin: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: const Color(0xFFEF6C00), width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: (r ?? 0) > 0.55 && !future ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}

class _HabitRateRow extends StatelessWidget {
  const _HabitRateRow({required this.habit, required this.s});

  final Habit habit;
  final PeriodStats s;

  @override
  Widget build(BuildContext context) {
    final r = s.rate;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: habit.color.withValues(alpha: 0.15),
            child: Icon(habit.icon, size: 18, color: habit.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        habit.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      r == null ? '–' : '${(r * 100).round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: habit.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: r ?? 0),
                    duration: const Duration(milliseconds: 600),
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      color: habit.color,
                      backgroundColor: habit.color.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${s.done}/${s.scheduled} lượt',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitDayRow extends StatelessWidget {
  const _HabitDayRow({
    required this.habit,
    required this.stats,
    required this.day,
  });

  final Habit habit;
  final StatsService stats;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final scheduled = habit.isScheduledOn(day);
    final done = stats.isDone(habit, day);
    final (icon, color, text) = !scheduled
        ? (Icons.remove_circle_outline, Colors.grey, 'Không có lịch')
        : done
        ? (Icons.check_circle_rounded, const Color(0xFF2E7D32), 'Hoàn thành')
        : (Icons.cancel_outlined, const Color(0xFFE53935), 'Chưa làm');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: habit.color.withValues(alpha: 0.15),
            child: Icon(habit.icon, size: 18, color: habit.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              habit.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
