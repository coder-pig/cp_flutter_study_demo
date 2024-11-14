import 'package:flutter/material.dart';

/// 画板封装Widget
class Paper extends StatelessWidget {
  final CustomPainter painter;

  const Paper({super.key, required this.painter});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Container(
          width: constraints.hasBoundedWidth ? constraints.maxWidth : 300,
          height: constraints.hasBoundedHeight ? constraints.maxHeight : 300,
          color: Colors.white,
          child: CustomPaint(painter: painter)));
}
