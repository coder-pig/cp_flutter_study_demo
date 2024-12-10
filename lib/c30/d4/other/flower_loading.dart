import 'dart:math';

import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('小黄花Loading进度条')),
          body: const FlowerLoadingChart(),
        ),
      );
}

class FlowerLoadingChart extends StatefulWidget {
  const FlowerLoadingChart({super.key});

  @override
  State<StatefulWidget> createState() => _FlowerLoadingChartState();
}

class _FlowerLoadingChartState extends State<FlowerLoadingChart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IntrinsicHeight(
            child: Column(
      children: [
        SizedBox(height: 300, child: Paper(painter: FlowerLoadingPainter(_animation))),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              _controller.forward(from: 0.0);
            },
            child: const Text("重新开始"))
      ],
    )));
  }
}

class FlowerLoadingPainter extends CustomPainter {
  final Animation<double> _animation;

  FlowerLoadingPainter(this._animation) : super(repaint: _animation);

  double width = 0.0;
  double height = 0.0;

  double barBgWidth = 250.0; // 进度条背景宽度
  double barBgHeight = 50.0; // 进度条背景高度
  double barPgWidth = 240.0; // 内部进度条宽度
  double barPgHeight = 40.0; // 内部进度条宽度
  double barPgRadius = 25.0; // 内部进度条圆角

  // 画笔
  Paint barBgPaint = Paint()..color = const Color(0xFFFDE49A);
  Paint barPgPaint = Paint()..color = const Color(0xFFFDA900);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    // 画布裁剪，黄色线性渐变背景
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader =
              const LinearGradient(colors: [Color(0xFFFDC640), Color(0xFFFDC542)]).createShader(Offset.zero & size));
    canvas.save();
    canvas.translate(width / 2, height / 2);
    // 绘制Loading文字
    final textPainter = TextPainter(
        text: const TextSpan(
            text: 'Loading...', style: TextStyle(color: Color(0xFFDCA52B), fontSize: 20, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr)
      ..layout();
    textPainter.paint(canvas, Offset((-textPainter.width) / 2, (-textPainter.height) / 2 - 50));
    // 绘制背景
    canvas.drawRRect(
        RRect.fromLTRBR(-barBgWidth / 2, -barBgHeight / 2, barBgWidth / 2, barBgHeight / 2, const Radius.circular(25)),
        barBgPaint);
    // 计算当前进度对应的宽度，然后绘制进度条
    final barPgCurrentWidth = barPgWidth * _animation.value / 100;
    // 裁剪出一个圆角矩形
    final clipRRect = RRect.fromLTRBR(
        -barBgWidth / 2 + 5, -barPgHeight / 2, barPgWidth / 2, barPgHeight / 2, Radius.circular(barPgHeight / 2));
    canvas.save();
    canvas.clipRRect(clipRRect);
    canvas.drawRect(Rect.fromLTWH(-barPgWidth / 2, -barPgHeight / 2, barPgCurrentWidth, barPgHeight), barPgPaint);
    canvas.restore();
    // 绘制右侧小花朵
    if (_animation.value < 100) {
      paintFlower(canvas);
    } else {
      paintFinishText(canvas);
    }
    canvas.restore();

  }

  paintFlower(Canvas canvas) {
    canvas.save();
    final flowerCenter = Offset(barBgWidth / 2 - 20, 0);
    // 跟随动画值变化，沿着Z轴旋转画布，每超过20%转一圈
    final Matrix4 matrix4 = Matrix4.identity()
      ..translate(flowerCenter.dx, flowerCenter.dy)
      ..rotateZ(-_animation.value / 20 * 2 * pi)
      ..translate(-flowerCenter.dx, -flowerCenter.dy);
    canvas.transform(matrix4.storage);

    final radius = barBgHeight / 2;
    canvas.drawCircle(flowerCenter, radius, Paint()..color = Colors.white);
    canvas.drawCircle(flowerCenter, radius - 3, Paint()..color = const Color(0xFFFDC640));
    canvas.drawCircle(flowerCenter, 2, Paint()..color = Colors.white);
    // 上下左右依次绘制雪糕形状的花瓣(下面三角形，上面是圆弧)
    Path topLeafPath = Path();
    topLeafPath.moveTo(flowerCenter.dx, flowerCenter.dy - 5);
    topLeafPath.lineTo(flowerCenter.dx + 5, flowerCenter.dy - 15);
    topLeafPath.arcToPoint(Offset(flowerCenter.dx - 5, flowerCenter.dy - 15),
        radius: const Radius.circular(2), clockwise: false);
    topLeafPath.close();
    canvas.drawPath(topLeafPath, Paint()..color = Colors.white);
    Path bottomLeafPath = Path();
    bottomLeafPath.moveTo(flowerCenter.dx, flowerCenter.dy + 5);
    bottomLeafPath.lineTo(flowerCenter.dx + 5, flowerCenter.dy + 15);
    bottomLeafPath.arcToPoint(Offset(flowerCenter.dx - 5, flowerCenter.dy + 15),
        radius: const Radius.circular(2), clockwise: true);
    bottomLeafPath.close();
    canvas.drawPath(bottomLeafPath, Paint()..color = Colors.white);
    Path leftLeafPath = Path();
    leftLeafPath.moveTo(flowerCenter.dx - 5, flowerCenter.dy);
    leftLeafPath.lineTo(flowerCenter.dx - 15, flowerCenter.dy + 5);
    leftLeafPath.arcToPoint(Offset(flowerCenter.dx - 15, flowerCenter.dy - 5),
        radius: const Radius.circular(2), clockwise: true);
    leftLeafPath.close();
    canvas.drawPath(leftLeafPath, Paint()..color = Colors.white);
    Path rightLeafPath = Path();
    rightLeafPath.moveTo(flowerCenter.dx + 5, flowerCenter.dy);
    rightLeafPath.lineTo(flowerCenter.dx + 15, flowerCenter.dy + 5);
    rightLeafPath.arcToPoint(Offset(flowerCenter.dx + 15, flowerCenter.dy - 5),
        radius: const Radius.circular(2), clockwise: false);
    rightLeafPath.close();
    canvas.drawPath(rightLeafPath, Paint()..color = Colors.white);
    canvas.restore();
  }

  paintFinishText(Canvas canvas) {
    final radius = barBgHeight / 2;
    final textCenter = Offset(barBgWidth / 2 - 20, 0);
    canvas.drawCircle(textCenter, radius, Paint()..color = Colors.white);
    canvas.drawCircle(textCenter, radius - 3, Paint()..color = const Color(0xFFFDC640));
    final textPainter = TextPainter(
        text: const TextSpan(
            text: '100%', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr)
      ..layout();
    textPainter.paint(canvas, Offset(textCenter.dx - textPainter.width / 2, textCenter.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
