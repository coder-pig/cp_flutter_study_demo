import 'dart:ui';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 横屏+全屏
  Future.any([
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]),
  ]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: Scaffold(body: BezierAnimate()));
}

class BezierAnimate extends StatefulWidget {
  const BezierAnimate({super.key});

  @override
  State<StatefulWidget> createState() => BezierAnimateState();
}

class BezierAnimateState extends State<BezierAnimate> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                fastText("不同阶贝塞尔曲线效果预览", CPTextStyle.s18.bold.c(Colors.redAccent)),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      _controller.reset();
                      _controller.forward();
                    },
                    child: const Text("播放动画"))
              ],
            ),
            Expanded(
                child: LayoutBuilder(
                    builder: (context, constraints) =>
                        CustomPaint(painter: BezierAnimatePainter(_controller), size: constraints.biggest)))
          ],
        ));
  }
}

class BezierAnimatePainter extends CustomPainter {
  final AnimationController animation;
  double width = 0;
  double height = 0;
  double areaWidth = 0;
  double space = 20;
  double borderCircleRadius = 5;

  // 点
  Offset p0 = Offset.zero;
  Offset p1 = Offset.zero;
  Offset p2 = Offset.zero;
  Offset p3 = Offset.zero;
  Offset p4 = Offset.zero;

  // 控制点连线上的点
  Offset q0 = Offset.zero; // p0-p1
  Offset q1 = Offset.zero; // p1-p2
  Offset q2 = Offset.zero; // p2-p3
  Offset q3 = Offset.zero; // p3-p4
  Offset r0 = Offset.zero; // q0-q1
  Offset r1 = Offset.zero; // q1-q2
  Offset r2 = Offset.zero; // q2-q3
  Offset s0 = Offset.zero; // r0-r1
  Offset s1 = Offset.zero; // r1-r2


  // 画笔
  Paint grayLinePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  Paint redLinePaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  Paint blueLinePaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  Paint redCirclePaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;
  Paint blueCirclePaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

  BezierAnimatePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    areaWidth = width / 4;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    // 控制点初始化
    p1 = Offset(areaWidth - 2 * space, (-height + space * 2) / 3);
    p2 = Offset((areaWidth - 2 * space) / 2, (-height + space * 2) / 3 * 2);
    // 绘制三条垂直分割线
    Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(areaWidth * i, 0), Offset(areaWidth * i, height), linePaint);
    }
    drawFirstOrder(canvas);
    drawSecondOrder(canvas);
    drawThirdOrder(canvas);
    drawForthOrder(canvas);
  }

  // 绘制一阶贝塞尔曲线
  void drawFirstOrder(Canvas canvas) {
    canvas.save();
    canvas.translate(space, height - space);
    Offset b = Offset((1 - animation.value) * p0.dx + animation.value * p1.dx,
        (1 - animation.value) * p0.dy + animation.value * p1.dy);
    Path p0p1 = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy);
    canvas.drawPath(p0p1, grayLinePaint);
    Path linePath = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(b.dx, b.dy);
    canvas.drawPath(linePath, redLinePaint);
    canvas.drawCircle(b, 5, redCirclePaint);
    // 最后再画点，避免被遮住
    drawBorderCircle(canvas, p0);
    TextPainter p0TextPainter = fastTextPainter("P0")..layout();
    p0TextPainter.paint(canvas, Offset(p0.dx - p0TextPainter.width / 2, p0.dy - p0TextPainter.height - 10));
    drawBorderCircle(canvas, p1);
    TextPainter p1TextPainter = fastTextPainter("P1")..layout();
    p1TextPainter.paint(canvas, Offset(p1.dx - p1TextPainter.width / 2, p1.dy + 10));
    canvas.restore();
  }

  // 绘制二阶贝塞尔曲线
  void drawSecondOrder(Canvas canvas) {
    canvas.save();
    canvas.translate(space + areaWidth, height - space);
    q0 = Offset.lerp(p0, p1, animation.value)!;
    q1 = Offset.lerp(p1, p2, animation.value)!;
    // b0：q0 到 q1 的连线，二阶贝塞尔曲线
    Offset b0 = Offset.lerp(q0, q1, animation.value)!;
    // 控制点连线
    Path p0p1 = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy);
    canvas.drawPath(p0p1, grayLinePaint);
    Path p1p2 = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);
    canvas.drawPath(p1p2, grayLinePaint);
    // 控制点连线上的点
    canvas.drawCircle(q0, 5, blueCirclePaint);
    canvas.drawCircle(q1, 5, blueCirclePaint);
    canvas.drawLine(q0, q1, blueCirclePaint);
    // 套公式，渐进绘制二阶贝塞尔曲线公式
    Path bezierPath = Path()..moveTo(p0.dx, p0.dy);
    for (double t = 0; t <= animation.value; t += 0.01) {
      double x = (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
      double y = (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
      bezierPath.lineTo(x, y);
    }
    canvas.drawPath(bezierPath, redLinePaint);
    canvas.drawCircle(b0, 5, redCirclePaint);

    // 最后再画点，避免被遮住
    drawBorderCircle(canvas, p0);
    TextPainter p0TextPainter = fastTextPainter("P0")..layout();
    p0TextPainter.paint(canvas, Offset(p0.dx - p0TextPainter.width / 2, p0.dy - p0TextPainter.height - 10));
    drawBorderCircle(canvas, p1);
    TextPainter p1TextPainter = fastTextPainter("P1")..layout();
    p1TextPainter.paint(canvas, Offset(p1.dx - p1TextPainter.width / 2, p1.dy + 10));
    drawBorderCircle(canvas, p2);
    TextPainter p2TextPainter = fastTextPainter("P2")..layout();
    p2TextPainter.paint(canvas, Offset(p2.dx - p2TextPainter.width / 2, p2.dy + 10));
    canvas.restore();
  }

  // 绘制三阶贝塞尔曲线
  void drawThirdOrder(Canvas canvas) {
    canvas.save();
    canvas.translate(space + areaWidth * 2, height - space);
    // 控制点初始化
    p1 = Offset(areaWidth - 2 * space, (-height + space * 2) / 3);
    p2 = Offset((areaWidth - 2 * space) / 2, (-height + space * 2) / 3 * 2);
    p3 = Offset((areaWidth - 2 * space) / 2 - 50, (-height + space * 2) / 3 * 2 + 50);
    // 控制点连线
    Path p0p1 = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy);
    canvas.drawPath(p0p1, grayLinePaint);
    Path p1p2 = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);
    canvas.drawPath(p1p2, grayLinePaint);
    Path p2p3 = Path()
      ..moveTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);
    canvas.drawPath(p2p3, grayLinePaint);
    // 控制点连线上的点
    q0 = Offset.lerp(p0, p1, animation.value)!;
    q1 = Offset.lerp(p1, p2, animation.value)!;
    q2 = Offset.lerp(p2, p3, animation.value)!;
    canvas.drawCircle(q0, 5, blueCirclePaint);
    canvas.drawCircle(q1, 5, blueCirclePaint);
    canvas.drawCircle(q2, 5, blueCirclePaint);
    canvas.drawLine(q0, q1, blueCirclePaint);
    canvas.drawLine(q1, q2, blueCirclePaint);
    r0 = Offset.lerp(q0, q1, animation.value)!;
    r1 = Offset.lerp(q1, q2, animation.value)!;
    canvas.drawCircle(r0, 5, blueCirclePaint);
    canvas.drawCircle(r1, 5, blueCirclePaint);
    canvas.drawLine(r0, r1, blueCirclePaint);
    Offset b0 = Offset.lerp(r0, r1, animation.value)!;
    Path bezierPath = Path()..moveTo(p0.dx, p0.dy);
    for (double t = 0; t <= animation.value; t += 0.01) {
      double x = (1 - t) * (1 - t) * (1 - t) * p0.dx +
          3 * (1 - t) * (1 - t) * t * p1.dx +
          3 * (1 - t) * t * t * p2.dx +
          t * t * t * p3.dx;
      double y = (1 - t) * (1 - t) * (1 - t) * p0.dy +
          3 * (1 - t) * (1 - t) * t * p1.dy +
          3 * (1 - t) * t * t * p2.dy +
          t * t * t * p3.dy;
      bezierPath.lineTo(x, y);
    }
    canvas.drawPath(bezierPath, redLinePaint);
    canvas.drawCircle(b0, 5, redCirclePaint);

    // 最后再画点，避免被遮住
    drawBorderCircle(canvas, p0);
    TextPainter p0TextPainter = fastTextPainter("P0")..layout();
    p0TextPainter.paint(canvas, Offset(p0.dx - p0TextPainter.width / 2, p0.dy - p0TextPainter.height - 10));
    drawBorderCircle(canvas, p1);
    TextPainter p1TextPainter = fastTextPainter("P1")..layout();
    p1TextPainter.paint(canvas, Offset(p1.dx - p1TextPainter.width / 2, p1.dy + 10));
    drawBorderCircle(canvas, p2);
    TextPainter p2TextPainter = fastTextPainter("P2")..layout();
    p2TextPainter.paint(canvas, Offset(p2.dx - p2TextPainter.width / 2, p2.dy + 10));
    drawBorderCircle(canvas, p3);
    TextPainter p3TextPainter = fastTextPainter("P3")..layout();
    p3TextPainter.paint(canvas, Offset(p3.dx - p3TextPainter.width / 2, p3.dy + 10));
    canvas.restore();
  }

  // 绘制四阶贝塞尔曲线
  void drawForthOrder(Canvas canvas) {
    canvas.save();
    canvas.translate(space + areaWidth * 3, height - space);
    // 控制点初始化
    p1 = Offset(areaWidth - 2 * space, (-height + space * 2) / 3);
    p2 = Offset((areaWidth - 2 * space) / 2, (-height + space * 2) / 3 * 2);
    p3 = Offset((areaWidth - 2 * space) / 2 - 50, (-height + space * 2) / 3 * 2 + 50);
    p4 = Offset((areaWidth - 2 * space) / 2 - 20, (-height + space * 2) / 3 * 2 + 100);
    // 控制点连线
    Path p0p1 = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy);
    canvas.drawPath(p0p1, grayLinePaint);
    Path p1p2 = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);
    canvas.drawPath(p1p2, grayLinePaint);
    Path p2p3 = Path()
      ..moveTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);
    canvas.drawPath(p2p3, grayLinePaint);
    Path p3p4 = Path()
      ..moveTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy);
    canvas.drawPath(p3p4, grayLinePaint);

    // 控制点连线上的点
    q0 = Offset.lerp(p0, p1, animation.value)!;
    q1 = Offset.lerp(p1, p2, animation.value)!;
    q2 = Offset.lerp(p2, p3, animation.value)!;
    q3 = Offset.lerp(p3, p4, animation.value)!;
    canvas.drawCircle(q0, 5, blueCirclePaint);
    canvas.drawCircle(q1, 5, blueCirclePaint);
    canvas.drawCircle(q2, 5, blueCirclePaint);
    canvas.drawCircle(q3, 5, blueCirclePaint);
    canvas.drawLine(q0, q1, blueCirclePaint);
    canvas.drawLine(q1, q2, blueCirclePaint);
    canvas.drawLine(q2, q3, blueCirclePaint);
    r0 = Offset.lerp(q0, q1, animation.value)!;
    r1 = Offset.lerp(q1, q2, animation.value)!;
    r2 = Offset.lerp(q2, q3, animation.value)!;
    canvas.drawCircle(r0, 5, blueCirclePaint);
    canvas.drawCircle(r1, 5, blueCirclePaint);
    canvas.drawCircle(r2, 5, blueCirclePaint);
    canvas.drawLine(r0, r1, blueCirclePaint);
    canvas.drawLine(r1, r2, blueCirclePaint);
    s0 = Offset.lerp(r0, r1, animation.value)!;
    s1 = Offset.lerp(r1, r2, animation.value)!;
    canvas.drawCircle(s0, 5, blueCirclePaint);
    canvas.drawCircle(s1, 5, blueCirclePaint);
    canvas.drawLine(s0, s1, blueCirclePaint);
    // 四阶贝塞尔曲线的点，套公式绘制路径
    Offset b0 = Offset.lerp(s0, s1, animation.value)!;
    Path bezierPath = Path()..moveTo(p0.dx, p0.dy);
    for (double t = 0; t <= animation.value; t += 0.01) {
      double x = (1 - t) * (1 - t) * (1 - t) * (1 - t) * p0.dx +
          4 * (1 - t) * (1 - t) * (1 - t) * t * p1.dx +
          6 * (1 - t) * (1 - t) * t * t * p2.dx +
          4 * (1 - t) * t * t * t * p3.dx +
          t * t * t * t * p4.dx;
      double y = (1 - t) * (1 - t) * (1 - t) * (1 - t) * p0.dy +
          4 * (1 - t) * (1 - t) * (1 - t) * t * p1.dy +
          6 * (1 - t) * (1 - t) * t * t * p2.dy +
          4 * (1 - t) * t * t * t * p3.dy +
          t * t * t * t * p4.dy;
      bezierPath.lineTo(x, y);
    }
    canvas.drawPath(bezierPath, redLinePaint);
    canvas.drawCircle(b0, 5, redCirclePaint);

    // 最后再画点，避免被遮住
    drawBorderCircle(canvas, p0);
    TextPainter p0TextPainter = fastTextPainter("P0")..layout();
    p0TextPainter.paint(canvas, Offset(p0.dx - p0TextPainter.width / 2, p0.dy - p0TextPainter.height - 10));
    drawBorderCircle(canvas, p1);
    TextPainter p1TextPainter = fastTextPainter("P1")..layout();
    p1TextPainter.paint(canvas, Offset(p1.dx - p1TextPainter.width / 2, p1.dy + 10));
    drawBorderCircle(canvas, p2);
    TextPainter p2TextPainter = fastTextPainter("P2")..layout();
    p2TextPainter.paint(canvas, Offset(p2.dx - p2TextPainter.width / 2, p2.dy + 10));
    drawBorderCircle(canvas, p3);
    TextPainter p3TextPainter = fastTextPainter("P3")..layout();
    p3TextPainter.paint(canvas, Offset(p3.dx - p3TextPainter.width / 2, p3.dy + 10));
    drawBorderCircle(canvas, p4);
    TextPainter p4TextPainter = fastTextPainter("P4")..layout();
    p4TextPainter.paint(canvas, Offset(p4.dx - p4TextPainter.width / 2, p4.dy + 10));
    canvas.restore();
  }

  // 绘制黑色边框填充灰色的圆
  drawBorderCircle(Canvas canvas, Offset center, {double radius = 5}) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, paint);
    paint
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

