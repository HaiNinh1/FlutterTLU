import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

/// Dải 7 ngày gần nhất; mỗi ngày có vòng tròn thể hiện tỷ lệ hoàn thành.
/// Chạm vào một ngày để xem / đánh dấu bù cho ngày đó.
class DayStrip extends StatelessWidget {
  const DayStrip({
    super.key,
    required this.selected,
    required this.rateOf,
    required this.onSelect,
  });

  final DateTime selected;
  final double? Function(DateTime day) rateOf;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = today();
    final days = [for (var i = 6; i >= 0; i--) addDays(t, -i)];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          for (final d in days)
            Expanded(
              child: Semantics(
                button: true,
                label: 'Ngày ${formatDate(d)}',
                excludeSemantics: true,
                child: GestureDetector(
                  key: ValueKey('day-${dateKey(d)}'),
                  onTap: () => onSelect(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSameDay(d, selected)
                          ? scheme.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isSameDay(d, t) ? 'Nay' : weekdayShort(d.weekday),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSameDay(d, selected)
                                ? Colors.white70
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _Ring(
                          rate: rateOf(d),
                          label: '${d.day}',
                          selected: isSameDay(d, selected),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.rate,
    required this.label,
    required this.selected,
  });

  final double? rate;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? Colors.white : scheme.primary;
    return SizedBox(
      width: 34,
      height: 34,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: rate ?? 0),
            duration: const Duration(milliseconds: 500),
            builder: (_, v, _) => CircularProgressIndicator(
              value: v,
              strokeWidth: 3.5,
              backgroundColor: selected ? Colors.white24 : Colors.grey.shade200,
              color: fg,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
