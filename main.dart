import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const RoyalSpinApp());

class RoyalSpinApp extends StatelessWidget {
  const RoyalSpinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Royal Spin',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF3A0000),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double turns = 0;
  final Random _random = Random();
  String result = 'Tap SPIN to play';

  final prizes = const ['10', '25', '50', '100', '25', '75', '10', '200'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spin() {
    final extra = 5 + _random.nextInt(4);
    setState(() {
      turns += extra + _random.nextDouble();
      result = 'Spinning...';
    });
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        result = 'You landed on a demo reward!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👑 Royal Spin',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: const Color(0xFF7A0000),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.people_alt_outlined),
            tooltip: 'Players',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text('Welcome to Royal Spin',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Free-to-play demo • No real money or betting'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B0000), Color(0xFF4A0000)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFFFC107), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text('LUCKY WHEEL',
                      style: TextStyle(
                          color: Color(0xFFFFD54F),
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                    ),
                    child: Transform.rotate(
                      angle: turns,
                      child: CustomPaint(
                        size: const Size.square(280),
                        painter: WheelPainter(prizes),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: spin,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      foregroundColor: const Color(0xFF4A0000),
                      minimumSize: const Size.fromHeight(54),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    child: const Text('SPIN'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _card(Icons.public, 'Online Room', 'Demo')),
                const SizedBox(width: 12),
                Expanded(child: _card(Icons.emoji_events, 'Leaderboard', 'Coming soon')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5B0000),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFFC107), size: 32),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> labels;
  WheelPainter(this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final sweep = 2 * pi / labels.length;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < labels.length; i++) {
      paint.color = i.isEven
          ? const Color(0xFFFFC107)
          : const Color(0xFFB71C1C);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + i * sweep,
        sweep,
        true,
        paint,
      );

      final angle = -pi / 2 + (i + 0.5) * sweep;
      final pos = Offset(
        center.dx + cos(angle) * radius * 0.63,
        center.dy + sin(angle) * radius * 0.63,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: i.isEven ? const Color(0xFF4A0000) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }

    canvas.drawCircle(center, radius * 0.14,
        Paint()..color = const Color(0xFF7A0000));
    canvas.drawCircle(center, radius * 0.08,
        Paint()..color = const Color(0xFFFFD54F));

    final arrow = Path()
      ..moveTo(center.dx, 4)
      ..lineTo(center.dx - 13, 30)
      ..lineTo(center.dx + 13, 30)
      ..close();
    canvas.drawPath(arrow, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) => false;
}
