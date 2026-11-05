import 'package:flutter/material.dart';

/// Thẻ tiến độ trong ngày: số thói quen đã hoàn thành, phần trăm, lời động viên.
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.title,
    required this.done,
    required this.total,
  });

  final String title;
  final int done;
  final int total;

  String get _message {
    if (total == 0) return 'Không có thói quen nào cần làm.';
    if (done == total) return 'Tuyệt vời! Bạn đã hoàn thành tất cả 🎉';
    if (done == 0) return 'Bắt đầu từ việc nhỏ nhất nhé!';
    if (done / total >= 0.5) return 'Đã qua một nửa, cố lên! 💪';
    return 'Khởi đầu tốt, tiếp tục nào!';
  }

  @override
  Widget build(BuildContext context) {
    final rate = total == 0 ? 0.0 : done / total;
    final allDone = total > 0 && done == total;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: allDone
              ? const [Color(0xFFFFA726), Color(0xFFEF6C00)]
              : const [Color(0xFF26A69A), Color(0xFF00796B)],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: rate),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (_, v, _) => Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: v,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                  Center(
                    child: Text(
                      '${(v * 100).round()}%',
                      key: const ValueKey('progress-percent'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  '$done / $total thói quen',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _message,
                    key: ValueKey(_message),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
