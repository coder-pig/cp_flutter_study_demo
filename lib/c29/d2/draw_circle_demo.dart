import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('画一个圆')),
          // 使用 CustomPaint 组件绘制自定义图形
          body: CustomPaint(painter: MyPainter()),
        ),
      );
}

class MyPainter extends CustomPainter {
  // 💡 指定自定义的绘制逻辑，参数：canvas → 画布，size → 绘制区域的大小
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(0, 0), 10, Paint());
  }

  // 💡 是否需要重新绘制
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
