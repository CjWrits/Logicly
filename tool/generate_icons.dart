import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Run with: flutter run -t tool/generate_icons.dart -d flutter-tester

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  for (final entry in sizes.entries) {
    final size = entry.value.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    _drawIcon(canvas, size);
    final picture = recorder.endRecording();
    final image = await picture.toImage(entry.value, entry.value);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final path = 'android/app/src/main/res/${entry.key}/ic_launcher.png';
    await File(path).writeAsBytes(bytes!.buffer.asUint8List());
    print('Generated $path');
  }
  exit(0);
}

void _drawIcon(Canvas canvas, double size) {
  const primary = Color(0xFF5B4FE9);
  const secondary = Color(0xFF9B8FFF);

  final bgPaint = Paint()
    ..shader = const LinearGradient(
      colors: [primary, secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size, size));

  canvas.drawRRect(
    RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size, size), Radius.circular(size * 0.22)),
    bgPaint,
  );

  final stroke = Paint()
    ..color = Colors.white
    ..strokeWidth = size * 0.07
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;

  final cx = size / 2;
  final cy = size / 2;
  final u = size * 0.09;

  canvas.drawPath(
    Path()
      ..moveTo(cx - u * 1.8, cy - u * 2)
      ..lineTo(cx - u * 3.2, cy)
      ..lineTo(cx - u * 1.8, cy + u * 2),
    stroke,
  );
  canvas.drawPath(
    Path()
      ..moveTo(cx + u * 1.8, cy - u * 2)
      ..lineTo(cx + u * 3.2, cy)
      ..lineTo(cx + u * 1.8, cy + u * 2),
    stroke,
  );

  canvas.drawPath(
    Path()
      ..moveTo(cx + u * 0.6, cy - u * 2.2)
      ..lineTo(cx - u * 0.8, cy - u * 0.1)
      ..lineTo(cx + u * 0.3, cy - u * 0.1)
      ..lineTo(cx - u * 0.6, cy + u * 2.2)
      ..lineTo(cx + u * 0.8, cy + u * 0.1)
      ..lineTo(cx - u * 0.3, cy + u * 0.1)
      ..close(),
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill,
  );
}
