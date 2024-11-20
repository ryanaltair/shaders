import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Pyramid extends StatefulWidget {
  const Pyramid({super.key});

  @override
  State<Pyramid> createState() => _PyramidState();
}

class _PyramidState extends State<Pyramid> {
  ui.FragmentShader? _shader;
  ui.Image? _image;
  ui.Image? _noise;
  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  static Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    late ImageStreamListener listener;
    ImageStream stream = provider.resolve(config); //获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
//监听
      final ui.Image image = frame.image;
      completer.complete(image); //完成
      stream.removeListener(listener); //移除监听
    });
    stream.addListener(listener); //添加监听
    return completer.future; //返回
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    final image = _image;
    final noise = _noise;
    if (shader == null || image == null || noise == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: CustomPaint(
        size: const Size(500 * 0.8, 658 * 0.8),
        painter: ShaderPainter(
            shader: shader,
            image: image,
            value: 0.5,
            burn: 0.5,
            dissolve: noise),
      ),
    );
  }

  void _loadShader() async {
    String path = 'shaders/shader.glsl';
    ui.FragmentProgram program = await ui.FragmentProgram.fromAsset(path);
    _shader = program.fragmentShader();
    _image = await loadImageByProvider(AssetImage('assets/test.jpeg'));
    _noise = await loadImageByProvider(AssetImage('assets/noise.png'));
    setState(() {});
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    required this.shader,
    required this.image,
    required this.dissolve,
    required this.value,
    required this.burn,
  });
  final double value;
  final double burn;
  ui.FragmentShader shader;
  ui.Image image;
  ui.Image dissolve;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setImageSampler(0, image);
    shader.setImageSampler(1, dissolve); // the dissolve_texture
    shader.setFloat(2, value);
    shader.setFloat(3, burn);
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
