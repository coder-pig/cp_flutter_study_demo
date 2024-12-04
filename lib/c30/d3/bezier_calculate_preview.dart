import 'dart:math';

import 'package:cp_flutter_study_demo/c29/d4/line_chart.dart';
import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';

import '../../c29/fast_widget_ext.dart';

class BezierCalculatePreview extends StatelessWidget {
  const BezierCalculatePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('贝塞尔曲线推导预览')),
        body: _PreviewContent(),
      ),
    );
  }
}

class _PreviewContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreviewContentState();
}

class _PreviewContentState extends State<_PreviewContent> with SingleTickerProviderStateMixin {
  final ValueNotifier _progress = ValueNotifier<double>(0.0); // 进度值
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            fastText("一阶贝塞尔曲线", CPTextStyle.s18.bold.c(Colors.redAccent)),
            Paper(painter: FirstOrderBezierPaint()),
            fastText("二阶贝塞尔曲线", CPTextStyle.s18.bold.c(Colors.redAccent)),
            Paper(painter: SecondOrderBezierPaint()),
            fastText("三阶贝塞尔曲线", CPTextStyle.s18.bold.c(Colors.redAccent)),
            Paper(painter: ThirdOrderBezierPaint()),
            fastText("球型水波纹进度条绘制原理", CPTextStyle.s18.bold.c(Colors.redAccent)),
            Paper(painter: BallWaveProgressBezierPaint(_progress, _controller)),
            fastText("正弦函数", CPTextStyle.s18.bold.c(Colors.redAccent)),
            Paper(painter: SinePaint()),
          ],
        ),
      ),
    );
  }
}

// 一阶贝塞尔曲线绘制
class FirstOrderBezierPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double percentWidth = width / 10;
    double percentHeight = height / 4;
    double t = 0.3;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    Offset p0 = Offset(percentWidth, height - percentHeight);
    Offset p1 = Offset(width - percentWidth, percentHeight);
    drawDashLineB(canvas, Offset(percentWidth, 0), Offset(percentWidth, height), isVertical: true);
    drawDashLineB(canvas, Offset(percentWidth, p1.dy), Offset(width - percentWidth, p1.dy));
    drawDashLineB(canvas, Offset(width - percentWidth, 0), Offset(width - percentWidth, height), isVertical: true);
    drawDashLineB(canvas, Offset(percentWidth, p0.dy), Offset(width - percentWidth, p0.dy));
    canvas.drawLine(p0, p1, Paint()..color = Colors.black);
    Offset b = Offset(p0.dx + (p1.dx - p0.dx) * t, p0.dy + (p1.dy - p0.dy) * t);
    drawDashLineB(canvas, Offset(b.dx, 0), Offset(b.dx, height), isVertical: true);
    drawBorderCircle(canvas, p0, fillColor: Colors.blue);
    drawBorderCircle(canvas, p1, fillColor: Colors.pink);
    drawBorderCircle(canvas, b, fillColor: Colors.green);
    TextPainter p0Painter = fastTextPainter("P0 (x0,y0)", style: CPTextStyle.s12.bold.c(Colors.blue));
    p0Painter.layout();
    p0Painter.paint(canvas, Offset(p0.dx - 30, p0.dy - 25));
    TextPainter p1Painter = fastTextPainter("P1 (x1,y1)", style: CPTextStyle.s12.bold.c(Colors.pink));
    p1Painter.layout();
    p1Painter.paint(canvas, Offset(p1.dx - 20, p1.dy - 25));
    TextPainter bPainter = fastTextPainter("B", style: CPTextStyle.s12.bold.c(Colors.green));
    bPainter.layout();
    bPainter.paint(canvas, Offset(b.dx - 10, b.dy + -20));
    TextPainter xPainter = fastTextPainter("bx = x0 + (x1-x0) * t \n= x0 + x1 * t - x0 * t \n= (1-t) * x0 + t * x1",
        style: CPTextStyle.s12.bold.c(Colors.green));
    xPainter.layout();
    xPainter.paint(canvas, Offset(b.dx + 10, b.dy));
    TextPainter yPainter = fastTextPainter("by = y0 + (y1-y0) * t \n= y0 + y1 * t - y0 * t \n= (1-t) * y0 + t * y1",
        style: CPTextStyle.s12.bold.c(Colors.green));
    yPainter.layout();
    yPainter.paint(canvas, Offset(b.dx + 10, b.dy - 100));
    // 绘制t相关标识
    TextPainter tLeftPainter = fastTextPainter("t", style: CPTextStyle.s18.bold.c(Colors.deepPurple));
    tLeftPainter.layout();
    tLeftPainter.paint(canvas, Offset(p0.dx + (b.dx - p0.dx - tLeftPainter.width) / 2, p0.dy + 10));
    TextPainter tRightPainter = fastTextPainter("1-t", style: CPTextStyle.s18.bold.c(Colors.deepPurple));
    tRightPainter.layout();
    tRightPainter.paint(canvas, Offset(b.dx + (p1.dx - b.dx - tRightPainter.width) / 2, p0.dy + 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SecondOrderBezierPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double percentWidth = width / 10;
    double percentHeight = height / 4;
    double t = 0.3;
    Paint grayLinePaint = Paint()
      ..color = Colors.grey.withAlpha(80)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    Offset p0 = Offset(percentWidth, height - percentHeight);
    Offset p2 = Offset(width - percentWidth, percentHeight);
    // 控制点
    Offset p1 = Offset(percentWidth * 5, percentHeight / 2);
    canvas.drawLine(p0, p1, grayLinePaint);
    canvas.drawLine(p1, p2, grayLinePaint);
    TextPainter p0Painter = fastTextPainter("P0", style: CPTextStyle.s12.bold.c(Colors.blue));
    p0Painter.layout();
    p0Painter.paint(canvas, Offset(p0.dx - 30, p0.dy - 25));
    TextPainter p1Painter = fastTextPainter("P1", style: CPTextStyle.s12.bold.c(Colors.purple));
    p1Painter.layout();
    p1Painter.paint(canvas, Offset(p1.dx - 20, p1.dy - 25));
    TextPainter p2Painter = fastTextPainter("P2", style: CPTextStyle.s12.bold.c(Colors.pink));
    p2Painter.layout();
    p2Painter.paint(canvas, Offset(p2.dx - 20, p2.dy - 25));
    drawBorderCircle(canvas, p0, fillColor: Colors.blue);
    drawBorderCircle(canvas, p2, fillColor: Colors.pink);
    drawBorderCircle(canvas, p1, fillColor: Colors.purple);
    // q0、q1
    Offset q0 = Offset.lerp(p0, p1, t)!;
    Offset q1 = Offset.lerp(p1, p2, t)!;
    canvas.drawLine(q0, q1, Paint()..color = Colors.black);
    TextPainter q0Painter = fastTextPainter("Q0", style: CPTextStyle.s12.bold.c(Colors.green));
    q0Painter.layout();
    q0Painter.paint(canvas, Offset(q0.dx - 20, q0.dy - 25));
    TextPainter q1Painter = fastTextPainter("Q1", style: CPTextStyle.s12.bold.c(Colors.green));
    q1Painter.layout();
    q1Painter.paint(canvas, Offset(q1.dx - 20, q1.dy - 25));
    drawBorderCircle(canvas, q0, fillColor: Colors.green);
    drawBorderCircle(canvas, q1, fillColor: Colors.green);
    // b点
    Offset b0 = Offset.lerp(q0, q1, t)!;
    drawBorderCircle(canvas, b0, fillColor: Colors.red);
    TextPainter b0Painter = fastTextPainter("B", style: CPTextStyle.s12.bold.c(Colors.deepOrange));
    b0Painter.layout();
    b0Painter.paint(canvas, Offset(b0.dx - 20, b0.dy - 25));
    drawBorderCircle(canvas, b0, fillColor: Colors.deepOrange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ThirdOrderBezierPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double percentWidth = width / 10;
    double percentHeight = height / 4;
    double t = 0.3;
    Paint grayLinePaint = Paint()
      ..color = Colors.grey.withAlpha(80)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    Offset p0 = Offset(percentWidth, height - percentHeight);
    Offset p3 = Offset(width - percentWidth, percentHeight);
    // 控制点
    Offset p1 = Offset(percentWidth * 3, percentHeight / 2 + 20);
    Offset p2 = Offset(percentWidth * 7, percentHeight / 2);
    canvas.drawLine(p0, p1, grayLinePaint);
    canvas.drawLine(p1, p2, grayLinePaint);
    canvas.drawLine(p2, p3, grayLinePaint);
    TextPainter p0Painter = fastTextPainter("P0", style: CPTextStyle.s12.bold.c(Colors.blue));
    p0Painter.layout();
    p0Painter.paint(canvas, Offset(p0.dx - 30, p0.dy - 25));
    TextPainter p1Painter = fastTextPainter("P1", style: CPTextStyle.s12.bold.c(Colors.purple));
    p1Painter.layout();
    p1Painter.paint(canvas, Offset(p1.dx - 20, p1.dy - 25));
    TextPainter p2Painter = fastTextPainter("P2", style: CPTextStyle.s12.bold.c(Colors.orange));
    p2Painter.layout();
    p2Painter.paint(canvas, Offset(p2.dx - 20, p2.dy - 25));
    TextPainter p3Painter = fastTextPainter("P3", style: CPTextStyle.s12.bold.c(Colors.pink));
    p3Painter.layout();
    p3Painter.paint(canvas, Offset(p3.dx - 20, p3.dy - 25));
    drawBorderCircle(canvas, p0, fillColor: Colors.blue);
    drawBorderCircle(canvas, p1, fillColor: Colors.purple);
    drawBorderCircle(canvas, p2, fillColor: Colors.orange);
    drawBorderCircle(canvas, p3, fillColor: Colors.pink);
    // q0、q1、q2
    Offset q0 = Offset.lerp(p0, p1, t)!;
    Offset q1 = Offset.lerp(p1, p2, t)!;
    Offset q2 = Offset.lerp(p2, p3, t)!;
    canvas.drawLine(q0, q1, Paint()..color = Colors.black);
    canvas.drawLine(q1, q2, Paint()..color = Colors.black);
    TextPainter q0Painter = fastTextPainter("Q0", style: CPTextStyle.s12.bold.c(Colors.green));
    q0Painter.layout();
    q0Painter.paint(canvas, Offset(q0.dx - 20, q0.dy - 25));
    TextPainter q1Painter = fastTextPainter("Q1", style: CPTextStyle.s12.bold.c(Colors.green));
    q1Painter.layout();
    q1Painter.paint(canvas, Offset(q1.dx - 20, q1.dy - 25));
    TextPainter q2Painter = fastTextPainter("Q2", style: CPTextStyle.s12.bold.c(Colors.green));
    q2Painter.layout();
    q2Painter.paint(canvas, Offset(q2.dx, q2.dy - 25));
    drawBorderCircle(canvas, q0, fillColor: Colors.green);
    drawBorderCircle(canvas, q1, fillColor: Colors.green);
    drawBorderCircle(canvas, q2, fillColor: Colors.green);
    // r0、r1
    Offset r0 = Offset.lerp(q0, q1, t)!;
    Offset r1 = Offset.lerp(q1, q2, t)!;
    canvas.drawLine(r0, r1, Paint()..color = Colors.black);
    TextPainter r0Painter = fastTextPainter("R0", style: CPTextStyle.s12.bold.c(Colors.deepOrange));
    r0Painter.layout();
    r0Painter.paint(canvas, Offset(r0.dx - 20, r0.dy - 25));
    TextPainter r1Painter = fastTextPainter("R1", style: CPTextStyle.s12.bold.c(Colors.deepOrange));
    r1Painter.layout();
    r1Painter.paint(canvas, Offset(r1.dx - 20, r1.dy - 25));
    drawBorderCircle(canvas, r0, fillColor: Colors.deepOrange);
    drawBorderCircle(canvas, r1, fillColor: Colors.deepOrange);
    // b点
    Offset b0 = Offset.lerp(r0, r1, t)!;
    drawBorderCircle(canvas, b0, fillColor: Colors.grey);
    TextPainter b0Painter = fastTextPainter("B", style: CPTextStyle.s12.bold.c(Colors.grey));
    b0Painter.layout();
    b0Painter.paint(canvas, Offset(b0.dx - 20, b0.dy - 25));
    drawBorderCircle(canvas, b0, fillColor: Colors.grey);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BallWaveProgressBezierPaint extends CustomPainter {
  ValueNotifier progress = ValueNotifier<double>(30.0); // 进度值
  final Animation<double> animation;

  BallWaveProgressBezierPaint(this.progress, this.animation) : super(repaint: Listenable.merge([progress, animation]));

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double circleRadius = 50.0;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    // 绘制圆圈
    canvas.save();
    canvas.translate(width * 0.75, height / 2 - circleRadius * 1.5);
    canvas.drawCircle(
        Offset.zero,
        circleRadius,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    // 裁剪绘制区域
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: circleRadius)));
    // 平移画布
    canvas.translate(animation.value * circleRadius * 2, circleRadius * 2 * progress.value);
    // 绘制曲线
    Paint bezierPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Path path = Path();
    path.relativeMoveTo(-circleRadius * 3, circleRadius * 2);
    path.relativeLineTo(0, -circleRadius * 2);
    path.relativeConicTo(circleRadius * 0.5, -circleRadius * 0.7, circleRadius, 0, 1);
    path.relativeConicTo(circleRadius * 0.5, circleRadius * 0.7, circleRadius, 0, 1);
    path.relativeConicTo(circleRadius * 0.5, -circleRadius * 0.7, circleRadius, 0, 1);
    path.relativeConicTo(circleRadius * 0.5, circleRadius * 0.7, circleRadius, 0, 1);
    path.relativeLineTo(0, circleRadius * 2);
    path.close();
    canvas.drawPath(path, bezierPaint);
    drawDashLineB(canvas, Offset(-circleRadius * 3, 0), Offset(circleRadius * 3, 0));
    drawDashLineB(canvas, Offset(-circleRadius * 3, -circleRadius / 2), Offset(circleRadius * 3, -circleRadius / 2));
    drawDashLineB(canvas, Offset(-circleRadius * 3, circleRadius / 2), Offset(circleRadius * 3, circleRadius / 2));
    drawDashLineB(canvas, Offset(0, -circleRadius * 2), Offset(0, circleRadius * 2), isVertical: true);
    drawDashLineB(canvas, Offset(-circleRadius / 2, -circleRadius * 2), Offset(-circleRadius / 2, circleRadius * 2),
        isVertical: true);
    drawDashLineB(canvas, Offset(circleRadius / 2, -circleRadius * 2), Offset(circleRadius / 2, circleRadius * 2),
        isVertical: true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SinePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    double amplitude = 20.0;  // 振幅 (中线到最高点/最低点的距离)
    double period = 2 * pi / 100; // 周期 (2π / 周期的长度)
    double xOffset = 10.0; // x轴偏移
    double yOffset = height / 2;  // y轴偏移
    Paint sinePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    Path path = Path();
    path.moveTo(0, yOffset);
    for (double x = 0; x < width; x++) {
      double y = amplitude * sin(period * (x + xOffset)) + yOffset;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, sinePaint);
    drawDashLineB(canvas, Offset(0, yOffset), Offset(width, yOffset));
    drawDashLineB(canvas, Offset(width / 2, 0), Offset(width / 2, height), isVertical: true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 绘制带边框圆点
drawBorderCircle(Canvas canvas, Offset center,
    {double radius = 5, Color borderColor = Colors.black, Color fillColor = Colors.grey}) {
  final paint = Paint()
    ..color = borderColor
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  canvas.drawCircle(center, radius, paint);
  paint
    ..color = fillColor
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, radius, paint);
}

// 绘制虚线
// 思路：PathMetrics + extractPath() 抠出原Path上某个范围的子路径
void drawDashLineB(Canvas canvas, Offset start, Offset end,
    {double dashWidth = 2.0, double spaceWidth = 2.0, bool isVertical = false}) {
  // 挪到起点，然后根据方向创建完整路径
  final path = Path()..moveTo(start.dx, start.dy);
  if (isVertical) {
    path.lineTo(start.dx, end.dy);
  } else {
    path.lineTo(end.dx, start.dy);
  }
  // 没有子路径，其实只返回一个PathMetrics
  final pathMetrics = path.computeMetrics();
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5
    ..color = Colors.grey;
  for (final metric in pathMetrics) {
    double distance = 0.0; // 子路径的起始点
    while (distance < metric.length) {
      final segment = metric.extractPath(distance, distance + dashWidth);
      canvas.drawPath(segment, paint);
      distance += dashWidth * spaceWidth; // dashWidth + spaceWidth
    }
  }
}
