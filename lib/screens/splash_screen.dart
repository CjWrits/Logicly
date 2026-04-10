import 'dart:math';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _exitController;
  late AnimationController _pulseController;
  late AnimationController _ringController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;
  late Animation<double> _pulse;
  late Animation<double> _ring;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _particleController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _exitController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
    _ringController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();

    _logoScale = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _logoOpacity = CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5))
        .drive(Tween(begin: 0.0, end: 1.0));

    _textOpacity = CurvedAnimation(parent: _textController, curve: const Interval(0.0, 0.6))
        .drive(Tween(begin: 0.0, end: 1.0));
    _textSlide = CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic)
        .drive(Tween(begin: const Offset(0, 0.4), end: Offset.zero));

    _taglineOpacity = CurvedAnimation(parent: _textController, curve: const Interval(0.3, 1.0))
        .drive(Tween(begin: 0.0, end: 1.0));
    _taglineSlide = CurvedAnimation(parent: _textController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic))
        .drive(Tween(begin: const Offset(0, 0.5), end: Offset.zero));

    _exitScale = CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic)
        .drive(Tween(begin: 1.0, end: 1.08));
    _exitOpacity = CurvedAnimation(parent: _exitController, curve: Curves.easeIn)
        .drive(Tween(begin: 1.0, end: 0.0));

    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
        .drive(Tween(begin: 1.0, end: 1.12));
    _ring = _ringController.drive(Tween(begin: 0.0, end: 1.0));

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1400));
    await _exitController.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _exitController.dispose();
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const primary = Color(0xFF5B4FE9);
    const secondary = Color(0xFF9B8FFF);
    const bg = Color(0xFF0A0A12);

    return Scaffold(
      backgroundColor: bg,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController, _particleController, _textController,
          _exitController, _pulseController, _ringController,
        ]),
        builder: (context, _) {
          return FadeTransition(
            opacity: _exitOpacity,
            child: ScaleTransition(
              scale: _exitScale,
              child: Stack(
                children: [
                  // Particle field
                  CustomPaint(
                    size: size,
                    painter: _ParticlePainter(
                      progress: _particleController.value,
                      primary: primary,
                      secondary: secondary,
                    ),
                  ),

                  // Radial glow behind logo
                  Center(
                    child: Container(
                      width: size.width * 0.85,
                      height: size.width * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primary.withOpacity(0.18 * _logoOpacity.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Expanding rings
                  Center(
                    child: CustomPaint(
                      size: Size(size.width, size.width),
                      painter: _RingPainter(
                        progress: _ring.value,
                        opacity: _logoOpacity.value,
                        color: primary,
                      ),
                    ),
                  ),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo with pulse
                        ScaleTransition(
                          scale: _logoScale,
                          child: FadeTransition(
                            opacity: _logoOpacity,
                            child: ScaleTransition(
                              scale: _pulse,
                              child: _LogoMark(size: 100, primary: primary, secondary: secondary),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // App name
                        SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textOpacity,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFFFFFF), Color(0xFFB8B0FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                'Logicly',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.5,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Tagline
                        SlideTransition(
                          position: _taglineSlide,
                          child: FadeTransition(
                            opacity: _taglineOpacity,
                            child: Text(
                              'DSA. Simplified.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.45),
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom powered-by text
                  Positioned(
                    bottom: 48,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      opacity: _taglineOpacity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Powered by Groq · llama-3.3-70b',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.25),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Logo mark ────────────────────────────────────────────────────────────────
class _LogoMark extends StatelessWidget {
  final double size;
  final Color primary;
  final Color secondary;

  const _LogoMark({required this.size, required this.primary, required this.secondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(color: primary.withOpacity(0.6), blurRadius: 40, spreadRadius: 4),
          BoxShadow(color: secondary.withOpacity(0.3), blurRadius: 80, spreadRadius: 8),
        ],
      ),
      child: CustomPaint(painter: _BoltPainter(size: size)),
    );
  }
}

class _BoltPainter extends CustomPainter {
  final double size;
  const _BoltPainter({required this.size});

  @override
  void paint(Canvas canvas, Size s) {
    final stroke = Paint()
      ..color = Colors.white
      ..strokeWidth = size * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = s.width / 2;
    final cy = s.height / 2;
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
      fill,
    );
  }

  @override
  bool shouldRepaint(_BoltPainter old) => old.size != size;
}

// ── Expanding rings ───────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final double opacity;
  final Color color;

  const _RingPainter({required this.progress, required this.opacity, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final p = ((progress + i / 3) % 1.0);
      final radius = size.width * 0.18 + p * size.width * 0.32;
      final ringOpacity = (1.0 - p) * 0.18 * opacity;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withOpacity(ringOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.opacity != opacity;
}

// ── Floating particles ────────────────────────────────────────────────────────
class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double angle;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color primary;
  final Color secondary;

  static final _rng = Random(42);
  static final List<_Particle> _particles = List.generate(55, (i) {
    return _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      size: _rng.nextDouble() * 2.5 + 0.8,
      speed: _rng.nextDouble() * 0.18 + 0.06,
      angle: _rng.nextDouble() * pi * 2,
      opacity: _rng.nextDouble() * 0.5 + 0.1,
    );
  });

  const _ParticlePainter({required this.progress, required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress * p.speed + p.x) % 1.0;
      final x = (p.x + cos(p.angle) * t * 0.3) % 1.0;
      final y = (p.y - t * 0.25) % 1.0;

      final color = Color.lerp(primary, secondary, p.x)!.withOpacity(p.opacity * (1 - (t - 0.5).abs() * 1.5).clamp(0, 1));

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
