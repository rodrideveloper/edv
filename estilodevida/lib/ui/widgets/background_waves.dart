import 'dart:math';

import 'package:flutter/material.dart';

class DancingWavesBackground extends StatefulWidget {
  @override
  _DancingWavesBackgroundState createState() => _DancingWavesBackgroundState();
}

class _DancingWavesBackgroundState extends State<DancingWavesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Ciclos reducidos para disminuir la velocidad
  final List<int> wavePhaseCycles = [1, 1, 2, 2, 3];
  final List<int> waveAmplitudeCycles = [1, 1, 1, 1, 1];

  @override
  void initState() {
    super.initState();

    // Aumentamos la duración para ralentizar la animación
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: DancingWavesPainter(
              animationValue: _animation.value,
              wavePhaseCycles: wavePhaseCycles,
              waveAmplitudeCycles: waveAmplitudeCycles,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

class DancingWavesPainter extends CustomPainter {
  final double animationValue;
  final List<int> wavePhaseCycles;
  final List<int> waveAmplitudeCycles;

  DancingWavesPainter({
    required this.animationValue,
    required this.wavePhaseCycles,
    required this.waveAmplitudeCycles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo degradado
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    LinearGradient gradient = LinearGradient(
      colors: [Color(0xFFAC41BE), Color(0xFF4F86CD)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Lista de colores para las ondas
    List<Color> waveColors = [
      Color(0xFFB768D6).withOpacity(0.6),
      Color(0xFF9449BD).withOpacity(0.6),
      Color(0xFF7A34B3).withOpacity(0.6),
      Color(0xFF5E1E9C).withOpacity(0.6),
      Color(0xFF3B0A7A).withOpacity(0.6),
    ];

    // Dibujar cada onda
    for (int i = 0; i < wavePhaseCycles.length; i++) {
      double yOffsetFactor = 0.4 + (i * 0.1); // Posición vertical de cada onda
      double baseAmplitude = 50 + (i * 10); // Amplitud base de cada onda
      double phaseOffset = (i * pi) / 2; // Desfase para cada onda

      Paint wavePaint = Paint()
        ..color = waveColors[i % waveColors.length]
        ..style = PaintingStyle.fill;

      drawDancingWave(
        canvas,
        size,
        wavePaint,
        wavePhaseCycles[i],
        waveAmplitudeCycles[i],
        animationValue,
        yOffsetFactor,
        baseAmplitude,
        phaseOffset,
      );
    }
  }

  void drawDancingWave(
      Canvas canvas,
      Size size,
      Paint paint,
      int phaseCycles,
      int amplitudeCycles,
      double animationValue,
      double yOffsetFactor,
      double baseAmplitude,
      double phaseOffset) {
    Path path = Path();
    double yOffset = size.height * yOffsetFactor;
    double wavelength = size.width;
    double frequency = 2 * pi / wavelength;

    // Ajuste para que la fase complete ciclos enteros
    double phaseShift = animationValue * 2 * pi * phaseCycles;

    path.moveTo(0, yOffset);

    int totalPoints = 100;
    for (int i = 0; i <= totalPoints; i++) {
      double x = (i / totalPoints) * size.width;

      // Variación de amplitud sincronizada
      double amplitude = baseAmplitude +
          sin(animationValue * 2 * pi * amplitudeCycles +
                  (x / wavelength) * 2 * pi) *
              10;

      // Posición Y calculada con funciones seno
      double y =
          yOffset + sin((x * frequency) + phaseShift + phaseOffset) * amplitude;

      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DancingWavesPainter oldDelegate) => true;
}
