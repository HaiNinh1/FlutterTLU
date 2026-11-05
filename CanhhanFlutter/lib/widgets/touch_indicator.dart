import 'package:flutter/material.dart';

/// Vẽ vòng tròn tại điểm chạm, giúp người xem video demo thấy thao tác.
/// Chỉ bật khi chạy kịch bản demo (xem `integration_test/demo_test.dart`).
class TouchIndicator extends StatefulWidget {
  const TouchIndicator({super.key, required this.child});

  final Widget child;

  @override
  State<TouchIndicator> createState() => _TouchIndicatorState();
}

class _TouchIndicatorState extends State<TouchIndicator>
    with SingleTickerProviderStateMixin {
  final _touches = <int, Offset>{};
  Offset? _last;
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  void _down(PointerEvent e) => setState(() {
    _touches[e.pointer] = e.localPosition;
    _last = e.localPosition;
    _fade.value = 1;
  });

  void _move(PointerEvent e) {
    if (!_touches.containsKey(e.pointer)) return;
    setState(() {
      _touches[e.pointer] = e.localPosition;
      _last = e.localPosition;
    });
  }

  void _up(PointerEvent e) {
    setState(() => _touches.remove(e.pointer));
    _fade.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _down,
      onPointerMove: _move,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: Stack(
        children: [
          widget.child,
          if (_last != null)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _fade,
                builder: (_, _) {
                  final pressed = _touches.isNotEmpty;
                  final o = pressed ? 1.0 : _fade.value;
                  final size = pressed ? 44.0 : 44 + (1 - _fade.value) * 24;
                  return Stack(
                    children: [
                      Positioned(
                        left: _last!.dx - size / 2,
                        top: _last!.dy - size / 2,
                        child: Opacity(
                          opacity: o,
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.18),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.9),
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
