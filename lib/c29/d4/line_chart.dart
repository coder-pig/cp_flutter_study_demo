import 'dart:math';
import 'dart:ui';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';
import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'dart:ui' as ui;

class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});

  @override
  State<StatefulWidget> createState() => _LineChartPage();
}

class _LineChartPage extends State<LineChartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('折线图')),
        body: SingleChildScrollView(
            child: Column(
          children: [
            fastText('三阶贝塞尔曲线的两个控制点计算', CPTextStyle.s16.bold.c(Colors.red)),
            Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                color: const Color(0xFFF0F0F0),
                child: Paper(painter: CubicCalculatePainter())),
            const SizedBox(height: 20),
            fastText('折线图绘制', CPTextStyle.s16.bold.c(Colors.red)),
            SizedBox(
                height: 300,
                child: Paper(
                    painter: LineChartPainter(
                        0,
                        60,
                        10,
                        [
                          {1984: 15},
                          {1988: 5},
                          {1992: 16},
                          {1996: 16},
                          {2000: 28},
                          {2004: 32},
                          {2008: 48},
                          {2012: 38},
                          {2016: 26},
                          {2020: 38},
                        ],
                        _controller)))
          ],
        )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CubicCalculatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final segW = width / 6;
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final upControlPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    final downControlPaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2;
    final upFirstControlPoint = Offset(segW, height);
    final upSecondControlPoint = Offset(width / 2 - segW, 0);
    final downFirstControlPoint = Offset(width / 2 + segW, 0);
    final downSecondControlPoint = Offset(width - segW, height);
    Path linePath = Path();
    linePath.moveTo(0, height);
    // 绘制上升曲线
    linePath.cubicTo(
        upFirstControlPoint.dx, upFirstControlPoint.dy, upSecondControlPoint.dx, upSecondControlPoint.dy, width / 2, 0);
    // 绘制下降曲线
    linePath.cubicTo(downFirstControlPoint.dx, downFirstControlPoint.dy, downSecondControlPoint.dx,
        downSecondControlPoint.dy, width, height);
    canvas.drawPath(linePath, paint);
    // 绘制上升的两个控制点
    canvas.drawCircle(Offset(0, height), 5, upControlPaint);
    canvas.drawCircle(upFirstControlPoint, 5, upControlPaint);
    canvas.drawLine(Offset(0, height), upFirstControlPoint, upControlPaint);
    canvas.drawCircle(Offset(width / 2, 0), 5, upControlPaint);
    canvas.drawCircle(upSecondControlPoint, 5, upControlPaint);
    canvas.drawLine(Offset(width / 2, 0), upSecondControlPoint, upControlPaint);
    // 绘制下降的两个控制点
    canvas.drawCircle(Offset(width / 2, 0), 5, downControlPaint);
    canvas.drawCircle(downFirstControlPoint, 5, downControlPaint);
    canvas.drawLine(Offset(width / 2, 0), downFirstControlPoint, downControlPaint);
    canvas.drawCircle(Offset(width, height), 5, downControlPaint);
    canvas.drawCircle(downSecondControlPoint, 5, downControlPaint);
    canvas.drawLine(Offset(width, height), downSecondControlPoint, downControlPaint);
    // 绘制宽度六等分虚线
    for (int i = 1; i < 6; i++) {
      drawDashLineA(canvas, Offset(segW * i, height), Offset(segW * i, 0), dashWidth: 3, isVertical: true);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  final int yMin;
  final int yMax;
  final int yStep;
  final List<Map<int, int>> data;
  final Animation<double> _repaint;

  // 画板配置相关
  double width = 0.0;
  double height = 0.0;
  double maxWidth = 0.0; // 最大绘制宽度
  double maxHeight = 0.0; // 最大绘制高度
  List<Offset> pointList = []; // 绘制点坐标列表
  double distanceX = 0.0; // 绘制点间的水平距离
  double distanceY = 0.0; // 绘制点间的垂直距离
  double maxPointY = 0.0; // 最大点的Y坐标

  // 画笔配置相关
  final Paint linePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1;

  final Paint blueLinePaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  LineChartPainter(this.yMin, this.yMax, this.yStep, this.data, this._repaint) : super(repaint: _repaint);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    maxWidth = width - 40;
    maxHeight = height - 40;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF0F0F0));
    canvas.save();
    canvas.translate(30, height - 40);
    drawAxis(canvas, size);
    calculatePoints();
    drawLinesD(canvas);
    canvas.restore();
  }

  // 绘制坐标系
  void drawAxis(Canvas canvas, Size size) {
    final endY = -maxHeight + 20;
    final endX = maxWidth;
    // 绘制Y轴 & 箭头
    canvas.drawLine(Offset.zero, Offset(0, endY), linePaint);
    canvas.drawLine(Offset(0, endY), Offset(-5, endY + 5), linePaint);
    canvas.drawLine(Offset(0, endY), Offset(5, endY + 5), linePaint);
    // 绘制X轴 & 箭头
    canvas.drawLine(Offset.zero, Offset(maxWidth, 0), linePaint);
    canvas.drawLine(Offset(endX, 0), Offset(endX - 5, -5), linePaint);
    canvas.drawLine(Offset(endX, 0), Offset(endX - 5, 5), linePaint);
    // 绘制Y轴刻度
    final countY = (yMax - yMin) ~/ yStep;
    final distanceY = (maxHeight - 20) / countY;
    for (int i = 0; i <= countY; i++) {
      // 绘制水平虚线
      drawDashLineA(canvas, Offset(0, -i * distanceY), Offset(endX - 5, -i * distanceY), dashWidth: 3);
      TextPainter(
        text: TextSpan(text: (i * yStep).toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, Offset(-20, -i * distanceY));
    }
    // 绘制X轴刻度
    final countX = data.length;
    final distanceX = (maxWidth - 20) / countX;
    for (int i = 0; i < countX; i++) {
      drawDashLineA(canvas, Offset((i + 1) * distanceX, 0), Offset((i + 1) * distanceX, endY),
          dashWidth: 3, isVertical: true);
      TextPainter(
        text: TextSpan(text: data[i].keys.first.toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, Offset((i + 1) * distanceX - 10, 5));
    }
  }

  void calculatePoints() {
    // 计算出x轴和y轴的单位长度
    final countX = data.length;
    distanceX = (maxWidth - 20) / countX;
    final countY = (yMax - yMin) ~/ yStep;
    distanceY = (maxHeight - 20) / countY;
    for (int i = 0; i < countX; i++) {
      final x = (i + 1) * distanceX;
      final y = -data[i].values.first * distanceY / yStep;
      if (maxPointY < y) maxPointY = y;
      pointList.add(Offset(x, y));
    }
  }

  // drawLine() 划线
  void drawLinesA(Canvas canvas) {
    for (int i = 0; i < pointList.length - 1; i++) {
      // 如果是第一个要连接原点
      if (i == 0) canvas.drawLine(const Offset(0, 0), pointList[i], blueLinePaint);
      // 划线
      canvas.drawLine(pointList[i], pointList[i + 1], blueLinePaint);
      // 画点
      canvas.drawCircle(pointList[i], 2, blueLinePaint);
      // 如果是最后一个要补一个点
      if (i == pointList.length - 2) canvas.drawCircle(pointList[i + 1], 2, blueLinePaint);
    }
  }

  // drawPath() 划线
  void drawLinesB(Canvas canvas) {
    final path = Path();
    for (int i = 0; i < pointList.length - 1; i++) {
      if (i == 0) path.moveTo(0, 0);
      path.lineTo(pointList[i].dx, pointList[i].dy);
      canvas.drawCircle(pointList[i], 2, linePaint);
      if (i == pointList.length - 2) canvas.drawCircle(pointList[i + 1], 2, linePaint);
    }
    path.lineTo(pointList.last.dx, pointList.last.dy);
    canvas.drawPath(path, blueLinePaint);
  }

  // drawPoints() 划线
  void drawLinesC(Canvas canvas) {
    canvas.drawPoints(PointMode.polygon, [const Offset(0, 0), ...pointList], blueLinePaint);
    for (int i = 0; i < pointList.length; i++) {
      canvas.drawCircle(pointList[i], 2, linePaint);
    }
  }

  // 三阶贝塞尔曲线
  void drawLinesD(Canvas canvas) {
    print("调用了");
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final controlPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1;
    final path = Path();
    // 需要把原点加进去
    List<Offset> tempPointList = List.from(pointList)..insert(0, Offset.zero);
    for (int i = 0; i < pointList.length; i++) {
      double currentY = tempPointList[i].dy;
      double currentX = tempPointList[i].dx;
      double nextY = tempPointList[i + 1].dy;
      // 将每个点的间距划分为三等分，计算出两个控制点
      Offset firstControlPoint = currentY > nextY ? Offset(distanceX / 3, 0) : Offset(distanceX / 3, 0);
      Offset secondControlPoint = currentY > nextY
          ? Offset(distanceX / 3 * 2, -(currentY - nextY))
          : Offset(distanceX / 3 * 2, nextY - currentY);
      path.relativeCubicTo(firstControlPoint.dx, firstControlPoint.dy, secondControlPoint.dx, secondControlPoint.dy,
          distanceX, -(currentY - nextY));
      // 曲线的绘制控制点，帮助理解
      // canvas.drawCircle(Offset(currentX + firstControlPoint.dx, currentY + firstControlPoint.dy), 2, controlPaint);
      // canvas.drawCircle(Offset(currentX + secondControlPoint.dx, currentY + secondControlPoint.dy), 2, controlPaint);
      // canvas.drawCircle(pointList[i], 2, paint);
      // if (i == tempPointList.length - 2) canvas.drawCircle(tempPointList[i + 1], 2, linePaint);
    }
    blueLinePaint.style = PaintingStyle.fill;
    blueLinePaint.shader = ui.Gradient.linear(
        Offset.zero,
        Offset(tempPointList.last.dx, maxPointY),
        [
          Colors.blue.withOpacity(1),
          Colors.white.withOpacity(1),
        ],
        [0.0, 1],
        TileMode.clamp,
        // 旋转90度，让渐变从上往下
        Matrix4.rotationZ(pi / 2).storage);
    path.relativeLineTo(0, -tempPointList.last.dy);
    path.relativeLineTo(-tempPointList.last.dx, 0);
    print(-tempPointList.last.dy);
    canvas.drawPath(path, blueLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 绘制虚线
// 思路：根据起点和终点坐标，计算虚线的数量和最后一段虚线的长度，然后绘制
// 参数：[start] 起点坐标，[end] 终点坐标，[dashWidth] 虚线宽度，[spaceWidth] 虚线间隔
// [isVertical] 是否垂直方向
void drawDashLineA(Canvas canvas, Offset start, Offset end,
    {double dashWidth = 2.0, double spaceWidth = 2.0, bool isVertical = false}) {
  final path = Path();
  double startDx = start.dx;
  double endDx = end.dx;
  double startDy = start.dy;
  double endDy = end.dy;
  int dashCount = 0; // 虚线数量
  int lastDashWidth = 0; // 最后一段虚线的长度
  // 移动到起点
  path.moveTo(startDx, startDy);
  if (isVertical) {
    // Y 轴向上是负的，这里需要用obs()取下绝对值
    dashCount = ((endDy - startDy) ~/ (dashWidth + spaceWidth)).abs();
    lastDashWidth = ((endDy - startDy) % (dashWidth + spaceWidth)).toInt();
    for (int y = 0; y < dashCount; y++) {
      path.relativeLineTo(0, -dashWidth);
      path.relativeMoveTo(0, -spaceWidth);
    }
    if (lastDashWidth > 0) path.relativeLineTo(0, lastDashWidth.toDouble());
  } else {
    dashCount = (endDx - startDx) ~/ (dashWidth + spaceWidth);
    lastDashWidth = ((endDy - startDy) % (dashWidth + spaceWidth)).toInt();
    for (int x = 0; x < dashCount; x++) {
      path.relativeLineTo(dashWidth, 0);
      path.relativeMoveTo(spaceWidth, 0);
    }
    if (lastDashWidth > 0) path.relativeLineTo(lastDashWidth.toDouble(), 0);
  }
  canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = Colors.grey);
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
