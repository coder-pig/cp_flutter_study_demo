import 'dart:async';
import 'dart:math';

import 'package:cp_flutter_study_demo/c30/d3/bezier_calculate_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('球型水波纹进度条')),
          body: const BallWaveProgress(),
        ),
      );
}

class BallWaveProgress extends StatefulWidget {
  const BallWaveProgress({super.key});

  @override
  State<StatefulWidget> createState() => _BallWaveProgressState();
}

class _BallWaveProgressState extends State<BallWaveProgress> with TickerProviderStateMixin {
  final ValueNotifier _progress = ValueNotifier<double>(0.0); // 进度值
  late AnimationController _controller;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _controller.repeat();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.ease,
    );
    _progressController.addListener(() {
      _progress.value = curvedAnimation.value;
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _controller.dispose();
    _progress.dispose();
    super.dispose();
  }

  _startProgress() {
    _progressController.reset();
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _progress.value = 0.0;
                  },
                  child: const Text("重置")),
              ElevatedButton(
                  onPressed: () {
                    _progress.value = Random().nextDouble();
                  },
                  child: const Text("随机进度")),
              ElevatedButton(
                  onPressed: () {
                    _startProgress();
                  },
                  child: const Text("从0到100%")),
            ],
          ),
          Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) =>
                      CustomPaint(painter: BallWaveProgressPainter(_progress, _controller), size: constraints.biggest)))
        ],
      ),
    );
  }
}

class BallWaveProgressPainter extends CustomPainter {
  // 外部传入参数
  ValueNotifier progress = ValueNotifier<double>(0.0); // 进度值
  final Animation<double> animation;
  double circleRadius = 100.0; // 圆半径
  Color circleProgressColor = Colors.blue; // 圆进度条色
  Color circleBgColor = Colors.grey; // 圆进度条背景色
  double circleStrokeWidth = 5.0; // 圆进度条宽度
  double progressTextSize = 20.0; // 进度文字大小
  Color progressTextColor = Colors.black; // 进度文字颜色
  Color waveColor = Colors.purple; // 波浪颜色

  // 内部维护属性
  double width = 0.0;
  double height = 0.0;
  Offset center = Offset.zero;

  BallWaveProgressPainter(this.progress, this.animation) : super(repaint: Listenable.merge([progress, animation]));

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    center = Offset(width / 2, height / 2);
    // 裁剪绘制区域避免溢出，绘制浅灰色背景便于观察
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    canvas.save();
    // 将画板坐标系移动到中心
    canvas.translate(center.dx, center.dy);
    drawCircleProgress(canvas);
    // drawWaveFirst(canvas);
    // drawWaveSecond(canvas);
    drawWaveThird(canvas);
    drawProgressText(canvas);
    canvas.restore();
  }

  // 绘制圆圈进度条，先画圆形背景，再画进度条
  drawCircleProgress(Canvas canvas) {
    Paint circleProgressPaint = Paint()
      ..color = circleBgColor
      ..strokeWidth = circleStrokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawCircle(Offset.zero, circleRadius, circleProgressPaint);
    circleProgressPaint
      ..color = circleProgressColor
      ..strokeCap = StrokeCap.round; // 设置线帽类型为圆形，看起来更圆润一些
    // 从-90°开始顺时针绘制, 2 * pi 为一个圆
    canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: circleRadius), -0.5 * pi, 2 * pi * progress.value,
        false, circleProgressPaint);
  }

  // 绘制中间的进度文字
  drawProgressText(Canvas canvas) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: "${(progress.value * 100).toInt()}%",
            style: TextStyle(color: progressTextColor, fontSize: progressTextSize)),
        textDirection: TextDirection.ltr)
      ..layout();
    textPainter.paint(canvas, Offset(0 - textPainter.width / 2, 0 - textPainter.height / 2));
  }

  // 绘制水波纹-贝塞尔曲线
  drawWaveFirst(Canvas canvas) {
    canvas.save();
    double waveHeight = 25.0; // 波浪高度
    double waveMaxWidth = circleRadius * 3; // 绘制最大宽度
    double waveMaxHeight = circleRadius * 2 + waveHeight / 2; // 绘制最大高度
    // 裁剪圆形
    canvas
        .clipPath(Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: circleRadius - circleStrokeWidth / 2)));
    // 画板根据动画值移动x轴，根据进度值移动y轴 (-波纹整体高度*进度值 + 初始偏移)
    canvas.translate(
        circleRadius * 2 * animation.value, -(circleRadius * 2 + waveHeight / 2) * progress.value + circleRadius);

    // 绘制后面的波纹
    Paint behindWavePaint = Paint()
      ..color = waveColor.withAlpha(100)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    Path behindWavePath = Path();
    behindWavePath.relativeMoveTo(-waveMaxWidth + circleRadius / 2, waveMaxHeight);
    behindWavePath.relativeLineTo(0, -waveMaxHeight);
    behindWavePath.relativeConicTo(circleRadius / 2, -waveHeight, circleRadius, 0, 1);
    behindWavePath.relativeConicTo(circleRadius / 2, waveHeight, circleRadius, 0, 1);
    behindWavePath.relativeConicTo(circleRadius / 2, -waveHeight, circleRadius, 0, 1);
    behindWavePath.relativeConicTo(circleRadius / 2, waveHeight, circleRadius, 0, 1);
    behindWavePath.relativeLineTo(0, waveMaxHeight);
    behindWavePath.relativeLineTo(-waveMaxWidth, 0);
    behindWavePath.close();
    canvas.drawPath(behindWavePath, behindWavePaint);

    // 绘制前面的波纹
    Paint frontWavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    Path frontWavePath = Path();
    frontWavePath.relativeMoveTo(-waveMaxWidth, waveMaxHeight);
    frontWavePath.relativeLineTo(0, -waveMaxHeight);
    frontWavePath.relativeConicTo(circleRadius / 2, -waveHeight, circleRadius, 0, 1);
    frontWavePath.relativeConicTo(circleRadius / 2, waveHeight, circleRadius, 0, 1);
    frontWavePath.relativeConicTo(circleRadius / 2, -waveHeight, circleRadius, 0, 1);
    frontWavePath.relativeConicTo(circleRadius / 2, waveHeight, circleRadius, 0, 1);
    frontWavePath.relativeLineTo(0, waveMaxHeight);
    frontWavePath.relativeLineTo(-waveMaxWidth, 0);
    frontWavePath.close();
    canvas.drawPath(frontWavePath, frontWavePaint);
    canvas.restore();
  }

  drawWaveSecond(Canvas canvas) {
    canvas.save();
    canvas
        .clipPath(Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: circleRadius - circleStrokeWidth / 2)));
    drawSinLine(canvas, waveColor.withAlpha(100), xDistance: circleRadius / 2);
    drawSinLine(canvas, waveColor);
    canvas.restore();
  }

  // 绘制正弦曲线
  void drawSinLine(Canvas canvas, Color waveColor, {double xDistance = 0.0}) {
    // x、y 的取值范围
    double startX = -circleRadius;
    double endX = circleRadius;
    double startY = circleRadius;
    double endY = -circleRadius;

    // 曲线方程相关参数
    double amplitude = 15.0; // 振幅
    double angularVelocity = pi / circleRadius; // 角速度
    double offsetX = circleRadius * 2 * animation.value; // x轴偏移
    double offsetY = startY + (endY - startY - amplitude) * progress.value; // y轴偏移
    // 画笔和Path
    Paint sinePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..isAntiAlias = true;
    Path path = Path();
    // 循环计算出正弦曲线上的点，第一个点需要 moveTo，后面的直接 lineTo
    for (double x = startX; x <= endX; x++) {
      double y = amplitude * sin(angularVelocity * (x + offsetX + xDistance)) + offsetY;
      x == startX ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    // 依次连接右下角和左下角的点，然后闭合路径
    path.lineTo(endX, startY);
    path.lineTo(startX, startY);
    path.close();
    canvas.drawPath(path, sinePaint);
  }

  drawWaveThird(Canvas canvas) {
    canvas.save();
    canvas
        .clipPath(Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: circleRadius - circleStrokeWidth / 2)));
    drawRRectWave(canvas, waveColor.withAlpha(100), xDistance: circleRadius / 2);
    drawRRectWave(canvas, waveColor);
    canvas.restore();
  }

  drawRRectWave(Canvas canvas, Color color, {double xDistance = 0.0}) {
    double waveHeight = circleRadius; // 波浪高度为半径
    double offsetY = -circleRadius * 2 * (1 - progress.value) + circleRadius; // 相对于原点的偏移
    double rectWidth = circleRadius * 2; // 正方形宽度
    double centerX = xDistance; // 中心点x坐标
    double centerY = -offsetY + rectWidth / 2;  // 中心点y坐标

    Paint rectPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 从左上角开始绘制圆角矩形
    Path rectPath = Path();
    rectPath.moveTo(-circleRadius + waveHeight + xDistance, -offsetY);
    rectPath.relativeLineTo(2 * (circleRadius - waveHeight), 0);
    rectPath.relativeConicTo(waveHeight, 0, waveHeight, waveHeight, 1);
    rectPath.relativeLineTo(0, 2 * (circleRadius - waveHeight));
    rectPath.relativeConicTo(0, waveHeight, -waveHeight, waveHeight, 1);
    rectPath.relativeLineTo(-2 * (circleRadius - waveHeight), 0);
    rectPath.relativeConicTo(-waveHeight, 0, -waveHeight, -waveHeight, 1);
    rectPath.relativeLineTo(0, -2 * (circleRadius - waveHeight));
    rectPath.relativeConicTo(0, -waveHeight, waveHeight, -waveHeight, 1);
    rectPath.close();

    // 组合变换矩阵，平移旋转中心到原点，旋转，再平移回去
    final Matrix4 matrix4 = Matrix4.identity()
      ..translate(centerX, centerY)
      ..rotateZ(2 * pi * animation.value)
      ..translate(-centerX, -centerY);

    // 绘制时顺带应用矩阵变换
    canvas.drawPath(rectPath.transform(matrix4.storage), rectPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
