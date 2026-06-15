import 'package:flutter/material.dart';

class ParticleBackground extends StatelessWidget {
  const ParticleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(),
      child: Container(),
    );
  }
}

class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1);

    for (int i = 0; i < 40; i++) {
      canvas.drawCircle(
        Offset(
          (i * 30) % size.width,
          (i * 50) % size.height,
        ),
        4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}