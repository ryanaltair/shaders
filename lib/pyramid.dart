import 'dart:ui';

import 'package:flutter/material.dart';

class Pyramid extends StatefulWidget {
  const Pyramid({super.key});

  @override
  State<Pyramid> createState() => _PyramidState();
}

class _PyramidState extends State<Pyramid> {
  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  @override
  Widget build(BuildContext context) {
    final shader=_shader;
    if (shader == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: CustomPaint(
        size: const Size(500 * 0.8, 658 * 0.8),
        painter: ShaderPainter(  shader: shader  ),
      ),
    );
  }

  void _loadShader() async {
    String path = 'shaders/shader.glsl';
    FragmentProgram program = await FragmentProgram.fromAsset(path);
    _shader = program.fragmentShader();
    setState(() {});
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});

  FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}