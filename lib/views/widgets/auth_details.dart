import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/auth_theme.dart';

class ProfilePhotoPlaceholder extends StatelessWidget {
  const ProfilePhotoPlaceholder({super.key, required this.hasPhoto});
  final bool hasPhoto;
  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: const _PhotoBorder(),
    child: Container(
      width: 76,
      height: 76,
      decoration: const BoxDecoration(
        color: AuthTheme.soft,
        shape: BoxShape.circle,
      ),
      child: Icon(
        hasPhoto ? Icons.person : Icons.camera_alt_outlined,
        size: 24,
        color: AuthTheme.muted,
      ),
    ),
  );
}

class _PhotoBorder extends CustomPainter {
  const _PhotoBorder();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8FA7A3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final rect = (Offset.zero & size).deflate(.8);
    for (double angle = 0; angle < math.pi * 2; angle += .2) {
      canvas.drawArc(rect, angle, .11, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Mint rounded badge with an envelope, shown above "Check your email".
class MailBadge extends StatelessWidget {
  const MailBadge({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AuthTheme.mint,
      borderRadius: BorderRadius.circular(size * .28),
    ),
    child: Icon(Icons.mail_outline, size: size * .45, color: AuthTheme.teal),
  );
}

class NovaSysMark extends StatelessWidget {
  const NovaSysMark({super.key, this.size = 22});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: const CustomPaint(painter: _MarkPainter()),
  );
}

/// Draws the mark on a 22x22 reference canvas and scales to the given size.
class _MarkPainter extends CustomPainter {
  const _MarkPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 22, size.height / 22);
    final paint = Paint()
      ..color = AuthTheme.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(3, 19)
        ..lineTo(3, 3)
        ..lineTo(19, 19)
        ..lineTo(19, 3),
      paint,
    );
    canvas.drawCircle(
      const Offset(19, 3),
      3.2,
      Paint()..color = const Color(0xFFFF7A59),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
