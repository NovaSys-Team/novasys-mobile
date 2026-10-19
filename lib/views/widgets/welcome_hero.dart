import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 296,
    child: ClipRect(
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFF0B3938))),
          Positioned(
            right: -20,
            top: -100,
            child: Container(
              width: 200,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF0C5750),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            top: -70,
            child: Container(
              width: 120,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF0C5750),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned.fill(child: CustomPaint(painter: _RoutePainter())),
          Positioned(
            top: 98,
            left: 168,
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 51,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7856),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 22,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5E9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Row(
                    children: [_wheel(), const SizedBox(width: 32), _wheel()],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            bottom: 28,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: AppTheme.teal,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'NovaSys',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _wheel() => Container(
    width: 18,
    height: 18,
    decoration: const BoxDecoration(
      color: Color(0xFF102E2D),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFFAACBC4),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(12, 170)
      ..cubicTo(100, 140, 135, 210, 220, 165)
      ..cubicTo(280, 130, 300, 98, size.width + 10, 130);
    final paint = Paint()
      ..color = const Color(0xFF0DA394)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 25) {
        final p = metric.getTangentForOffset(d)!.position;
        canvas.drawLine(p, p + const Offset(2, 0), paint);
      }
    }
    canvas.drawCircle(const Offset(78, 152), 9, Paint()..color = Colors.white);
    canvas.drawCircle(
      const Offset(78, 152),
      4,
      Paint()..color = const Color(0xFF0B3938),
    );
    canvas.drawCircle(
      const Offset(300, 126),
      9,
      Paint()..color = const Color(0xFFFF7856),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
