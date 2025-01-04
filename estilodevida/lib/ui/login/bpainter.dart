import 'package:flutter/material.dart';

class WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple, Colors.deepPurpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    // Start painting from the top left corner
    path.lineTo(0, size.height * 0.3);

    // First curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.15,
      size.width * 0.5,
      size.height * 0.3,
    );

    // Second curve
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.45,
      size.width,
      size.height * 0.3,
    );

    // Line to the bottom right corner
    path.lineTo(size.width, 0);

    path.close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);

    // Second wave
    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pink, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path2 = Path();

    path2.moveTo(0, size.height * 0.4);

    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.55,
      size.width * 0.5,
      size.height * 0.4,
    );

    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.25,
      size.width,
      size.height * 0.4,
    );

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);

    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
