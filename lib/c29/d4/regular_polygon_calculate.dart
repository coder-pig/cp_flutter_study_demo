import 'dart:math';

import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:flutter/material.dart';

class RegularPolygonCalculate extends StatefulWidget {
  const RegularPolygonCalculate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegularPolygonCalculateState();
}

class _RegularPolygonCalculateState extends State<RegularPolygonCalculate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('正多边形计算示意图')), body: Paper(painter: RegularPolygonCalculatePainter()));
  }
}

class RegularPolygonCalculatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double halfWidth = size.width / 2;
    canvas.translate(halfWidth, halfWidth);
    double radius = 100;
    Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 1;
    // 画坐标轴
    canvas.drawLine(Offset(-halfWidth + 50, 0), Offset(halfWidth - 50, 0), paint);
    canvas.drawLine(Offset(0, -halfWidth + 50), Offset(0, halfWidth - 50), paint);

    // 画圆
    paint.color = Colors.grey.withAlpha(80);
    canvas.drawCircle(const Offset(0, 0), radius, paint);

    // 绘制右上角点相关
    paint.color = Colors.red;
    double angle = pi / 4;
    Offset rightTopPoint = Offset(radius * cos(-angle), radius * sin(-angle));
    Path path = Path();
    path.lineTo(rightTopPoint.dx, rightTopPoint.dy);
    path.relativeLineTo(0, rightTopPoint.dx);
    path.close();
    canvas.drawPath(path, paint);

    // 画弧，45°，半径15，写字
    canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: 15), 0, -angle, true, paint);
    TextPainter textPainter = TextPainter(
        text: const TextSpan(
            text: '45°', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(-20, -20));
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(rightTopPoint, 4, paint);
    // 画直角，写字
    paint.style = PaintingStyle.stroke;
    path.reset();
    path.moveTo(rightTopPoint.dx - 10, 0);
    path.relativeLineTo(0, -10);
    path.relativeLineTo(10, 0);
    canvas.drawPath(path, paint);
    textPainter.text =
        const TextSpan(text: 'A', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, const Offset(-20, 10));
    textPainter.text =
        const TextSpan(text: 'C', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(rightTopPoint.dx, 10));
    textPainter.text =
        const TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(rightTopPoint.dx, rightTopPoint.dy - 30));
    // 写字
    textPainter.text =
        const TextSpan(text: '临边-b', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(rightTopPoint.dx / 2 - textPainter.width / 2, 10));
    textPainter.text =
        const TextSpan(text: '对边-a', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(rightTopPoint.dx + 10, rightTopPoint.dy / 2 - textPainter.height / 2));
    // 斜边-c
    canvas.save();
    canvas.translate(rightTopPoint.dx / 2 - 10, rightTopPoint.dy / 2 - 10);
    canvas.rotate(-pi / 4);
    textPainter.text =
        const TextSpan(text: '斜边-c(圆半径)', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();

    // 绘制正八边形
    paint.color = Colors.blue;
    path.reset();
    for (int i = 0; i < 8; i++) {
      double x = radius * cos(2 * pi / 8 * i);
      double y = radius * sin(2 * pi / 8 * i);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // 画公式文本
    textPainter.text = const TextSpan(
        text: 'sinA = 对/斜 =a/c\n\ncosA=临/斜=b/c', style: TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0 - textPainter.width / 2, halfWidth));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
