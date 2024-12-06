import 'dart:math';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('带手势的曲线图')),
          body: const LineChart(),
        ),
      );
}

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  State<StatefulWidget> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _localPosition = ValueNotifier(Offset.zero);
  late LineChartModel _model;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IntrinsicHeight(
            child: Column(
      children: [
        GestureDetector(
          onScaleUpdate: (details) {
            // 只有一个触点时才更新
            if(details.pointerCount == 1) _localPosition.value = details.localFocalPoint;
          },
          child: SizedBox(height: 300, child: Paper(painter: LinePainter(_localPosition, _model))),
        ),
        ElevatedButton(onPressed: refreshData, child: const Text("刷新数据"))
      ],
    )));
  }

  refreshData() {
    // 生成随机数据
    List<LineChartPoint> points = [];
    for (int i = 0; i < 10; i++) {
      points.add(LineChartPoint(Random().nextDouble() * 100, Random().nextDouble() * 100));
    }
    // 按照x轴递增顺序排序
    points.sort((a, b) => a.x.compareTo(b.x));
    setState(() {
      _localPosition.value = Offset.zero;
      _model = LineChartModel(100, 0, 100, 0, points);
    });
  }
}

class LinePainter extends CustomPainter {
  final ValueNotifier<Offset> _localPosition;
  final LineChartModel _model;

  LinePainter(this._localPosition, this._model) : super(repaint: _localPosition);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = Colors.grey.withAlpha(20));
    canvas.save();

    // 计算并移动坐标系到中心点
    const padding = 40.0; // 坐标轴距离边缘的距离
    final centerPoint = Offset(width / 2 + padding, height - padding);
    canvas.translate(padding, centerPoint.dy);
    // 绘制坐标轴
    Paint layerPaint = Paint()
      ..color = Colors.grey.withAlpha(100)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    double yLength = height - padding * 2;
    // 绘制y轴
    canvas.drawLine(Offset.zero, Offset(0, -yLength), layerPaint);
    // 绘制x轴刻度
    for (int i = 1; i <= 8; i++) {
      double x = (width - padding * 2) / 8 * i;
      canvas.drawLine(Offset(x, 0), Offset(x, -yLength), layerPaint);
      TextPainter textPainter =
          fastTextPainter("${_model.maxX / 8 * i}", style: CPTextStyle.s12.normal.c(const Color(0xFFAAAAAA)));
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, padding / 2 - 10));
    }
    // x轴长度
    double xLength = width - padding * 2;
    // 绘制x轴，y轴长度分成8分，循环绘制线的同时绘制y轴刻度
    for (int i = 0; i <= 8; i++) {
      double y = -yLength / 8 * i;
      canvas.drawLine(Offset(0, y), Offset(xLength, y), layerPaint);
      TextPainter textPainter =
          fastTextPainter("${_model.maxY / 8 * i}", style: CPTextStyle.s12.normal.c(const Color(0xFFAAAAAA)));
      textPainter.layout();
      textPainter.paint(canvas, Offset(-padding + (padding - textPainter.width) / 2, y - 5));
    }

    // 按比例对原始点进行换算得到当前坐标系的真实坐标
    List<Offset> points =
        _model.points.map((e) => Offset(e.x / _model.maxX * xLength, -e.y / _model.maxY * yLength)).toList();

    // 绘制曲线
    Path linePath = Path();
    for (int i = 0; i < points.length; i++) {
      // 当前点
      Offset point = points[i];
      // 如果是第一个点要先挪动到起点
      if (i == 0) linePath.moveTo(point.dx, point.dy);
      // 如果是最后一个点就不再绘制
      if (i == points.length - 1) break;
      // 下一个点的x,y坐标
      double nextX = points[i + 1].dx;
      double nextY = points[i + 1].dy;
      // 前后两点的x轴和y轴距离
      double distanceX = nextX - point.dx;
      // 计算控制点
      Offset firstControlPoint = Offset(point.dx + distanceX / 3, 0);
      Offset secondControlPoint = point.dy.abs() < nextY.abs()
          ? Offset(point.dx + distanceX / 3 * 2, nextY)
          : Offset(point.dx + distanceX / 3 * 2, point.dy);
      // 绘制三阶贝塞尔曲线
      linePath.cubicTo(
          firstControlPoint.dx, firstControlPoint.dy, secondControlPoint.dx, secondControlPoint.dy, nextX, nextY);
    }
    Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);

    // 复制曲线Path，绘制线性渐变
    Path gradientPath = Path.from(linePath);
    // 连点,形成闭合区域
    gradientPath.lineTo(points.last.dx, 0);
    gradientPath.lineTo(points.first.dx, 0);
    gradientPath.lineTo(points.first.dx, points.first.dy);
    // 线性渐变画笔
    Paint gradientPaint = Paint()
      ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4E98FF), Color(0x1A4E98FF), Color(0x004E98FF)])
          .createShader(Rect.fromPoints(Offset.zero, Offset(0, -yLength)))
      ..style = PaintingStyle.fill;
    canvas.drawPath(gradientPath, gradientPaint);


    // 对原始手势点进行换算得到当前坐标系的真实坐标
    Offset localPosition = _localPosition.value;
    Offset realPosition = Offset(localPosition.dx - padding, localPosition.dy - centerPoint.dy);

    // 判断手势是否点在某个点上 (x轴方向上的距离小于5)
    for (int i = 0; i < points.length; i++) {
      Offset point = points[i];
      if ((point.dx - realPosition.dx).abs() < 5) {
        // 绘制点击的蓝白圆圈
        canvas.drawCircle(point, 5, Paint()..color = Colors.white);
        canvas.drawCircle(point, 3, Paint()..color = Colors.blue);

        // 先计算文本的宽高，计算提示框的宽高要用到
        TextPainter firstTextPainter =
            fastTextPainter("x轴${_model.points[i].x.toInt()}", style: CPTextStyle.s12.normal.c(Colors.grey));
        firstTextPainter.layout();
        double firstTextWidth = firstTextPainter.width;
        double firstTexHeight = firstTextPainter.height;
        TextPainter secondTextPainter =
            fastTextPainter("y轴${_model.points[i].y.toInt()}", style: CPTextStyle.s14.normal.c(Colors.black));
        secondTextPainter.layout();
        double secondTextWidth = secondTextPainter.width;
        double secondTextHeight = secondTextPainter.height;

        // 计算 & 绘制提示框
        double textVerticalSpace = 2; // 两行文字的间距
        double horizontalPadding = 16; // 水平内边距
        double verticalPadding = 8; // 垂直内边距
        double radius = 10; // 圆角
        double anchorWidth = 10; // 锚点宽度
        double anchorHeight = 10; // 锚点高度
        double anchorSpace = 10; // 锚点与提示框的间距
        double tipWidth = secondTextWidth + horizontalPadding * 2; // 提示框的宽度
        double tipHeight = verticalPadding * 2 + firstTexHeight + secondTextHeight + textVerticalSpace; // 提示框的高度，不包含锚点

        // 提示框的Path (圆角矩形+锚点)
        Path tipPath = Path();
        tipPath.moveTo(point.dx - tipWidth / 2 + radius, point.dy - tipHeight - anchorHeight - anchorSpace);
        tipPath.relativeLineTo(tipWidth - radius * 2, 0);
        tipPath.relativeConicTo(radius, 0, radius, radius, 1);
        tipPath.relativeLineTo(0, tipHeight - radius * 2);
        tipPath.relativeConicTo(0, radius, -radius, radius, 1);
        tipPath.relativeLineTo(-(tipWidth / 2 - radius - anchorWidth / 2), 0);
        tipPath.relativeLineTo(-anchorWidth / 2, anchorHeight);
        tipPath.relativeLineTo(-anchorWidth / 2, -anchorHeight);
        tipPath.relativeLineTo(-(tipWidth / 2 - radius - anchorWidth / 2), 0);
        tipPath.relativeConicTo(-radius, 0, -radius, -radius, 1);
        tipPath.relativeLineTo(0, -tipHeight + radius * 2);
        tipPath.relativeConicTo(0, -radius, radius, -radius, 1);
        tipPath.close();
        // 先绘制阴影再绘制图形
        canvas.drawShadow(tipPath, Colors.blue.withAlpha(100), 5, true);
        canvas.drawPath(tipPath, Paint()..color = Colors.white);

        // 将文字绘制在中间
        double secondTextY = point.dy - anchorSpace - anchorHeight - verticalPadding - secondTextHeight;
        secondTextPainter.paint(canvas, Offset(point.dx - secondTextWidth / 2, secondTextY));
        firstTextPainter.paint(
            canvas, Offset(point.dx - firstTextWidth / 2, secondTextY - firstTexHeight - textVerticalSpace));

        // 只绘制一个, 所以直接跳出
        break;
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartModel {
  final double maxY; // Y轴最大值
  final double minY; // Y轴最小值
  final double maxX; // X轴最大值
  final double minX; // X轴最小值
  final List<LineChartPoint> points; // 数据点
  LineChartModel(this.maxY, this.minY, this.maxX, this.minX, this.points);
}

class LineChartPoint {
  final double x;
  final double y;

  LineChartPoint(this.x, this.y);

  String get str => "x: $x, y: $y";
}
