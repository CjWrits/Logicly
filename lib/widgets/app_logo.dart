import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({super.key, this.size = 48, this.showText = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? const Color(0xFF7C6FFF) : const Color(0xFF5B4FE9);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, Color.lerp(primary, Colors.purpleAccent, 0.45)!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.4),
                blurRadius: size * 0.4,
                offset: Offset(0, size * 0.12),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _LogoPainter(size: size),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Logicly',
                style: TextStyle(
                  fontSize: size * 0.32,
                  fontWeight: FontWeight.w900,
                  color: primary,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double size;
  const _LogoPainter({required this.size});

  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final cx = s.width / 2;
    final cy = s.height / 2;
    final u = size * 0.09; // unit

    // Left bracket  <
    final bracketPath = Path()
      ..moveTo(cx - u * 1.8, cy - u * 2)
      ..lineTo(cx - u * 3.2, cy)
      ..lineTo(cx - u * 1.8, cy + u * 2);
    canvas.drawPath(bracketPath, paint);

    // Right bracket  >
    final bracketPath2 = Path()
      ..moveTo(cx + u * 1.8, cy - u * 2)
      ..lineTo(cx + u * 3.2, cy)
      ..lineTo(cx + u * 1.8, cy + u * 2);
    canvas.drawPath(bracketPath2, paint);

    // Lightning bolt in center
    final boltPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bolt = Path()
      ..moveTo(cx + u * 0.6, cy - u * 2.2)
      ..lineTo(cx - u * 0.8, cy - u * 0.1)
      ..lineTo(cx + u * 0.3, cy - u * 0.1)
      ..lineTo(cx - u * 0.6, cy + u * 2.2)
      ..lineTo(cx + u * 0.8, cy + u * 0.1)
      ..lineTo(cx - u * 0.3, cy + u * 0.1)
      ..close();
    canvas.drawPath(bolt, boltPaint);
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.size != size;
}
