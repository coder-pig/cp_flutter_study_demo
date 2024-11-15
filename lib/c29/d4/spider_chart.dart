import 'dart:math';

import 'package:flutter/material.dart';
import '../paper.dart';

class SpiderChartPage extends StatefulWidget {
  const SpiderChartPage({super.key});

  @override
  State<StatefulWidget> createState() => _SpiderChartPage();
}

class _SpiderChartPage extends State<SpiderChartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late List<Map<String, double>> _data;

  refreshData() {
    setState(() {
      _data = generateData();
      _controller.forward(from: 0);
    });
  }

  // 生成随机数据
  List<Map<String, double>> generateData() {
    List<String> subjects = ["语文", "数学", "英语", "历史", "地理", "生物", "物理", "化学", "政治", "体育"];
    Random random = Random();
    int dataCount = 3 + random.nextInt(8); // Generate a random number between 3 and 10
    List<Map<String, double>> data = [];
    for (int i = 0; i < dataCount; i++) {
      int index = random.nextInt(subjects.length);
      String subject = subjects.removeAt(index); // Remove the selected subject to avoid duplicates
      double value = (random.nextInt(201) / 2).toDouble(); // Generate a value that is either an integer or ends in .5
      data.add({subject: value});
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    _data = generateData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('饼图')),
        body: Column(children: [
          ElevatedButton(onPressed: refreshData, child: const Text("刷新数据")),
          const SizedBox(height: 10),
          SizedBox(
            height: 500,
            child: Paper(painter: SpiderChartPainter(_data, _controller)),
          )
        ]));
  }
}

class SpiderChartPainter extends CustomPainter {
  final List<Map<String, double>> data;
  final Animation<double> repaint;
  double width = 0.0;
  double height = 0.0;
  double halfWidth = 0.0;
  double halfHeight = 0.0;

  SpiderChartPainter(this.data, this.repaint) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    halfWidth = size.width / 2;
    halfHeight = size.height / 2;
    int side = data.length;
    if (side > 2) {
      // 裁剪动画
      canvas.save();
      Path clipPath = Path();
      // 起点挪到中心点
      clipPath.moveTo(halfWidth, halfHeight);
      clipPath.arcTo(
          Rect.fromCircle(center: Offset(halfWidth, halfHeight), radius: halfWidth), // 以中心点为圆心的圆
          -pi / 2, // 起始角度
          2 * pi * repaint.value, // 扫过角度
          false);
      clipPath.close();
      if (repaint.value != 1.0) {
        canvas.clipPath(clipPath);
      }
      double radius = halfWidth / 2;
      Paint bgPaint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      Path path = Path();
      // 绘制多边形背景
      for (int count = 0; count < 5; count++) {
        double r = radius / 5 * (count + 1);
        for (int i = 0; i < side; i++) {
          // 利用三角函数计算对应顶点的坐标
          double x = halfWidth + r * cos(2 * pi / side * i);
          double y = halfHeight + r * sin(2 * pi / side * i);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, bgPaint);
      }
      // 按照百分比计算每个点的坐标
      List<Offset> pointList = [];
      for (int i = 0; i < side; i++) {
        double percent = data[i].values.first / 100;
        double r = radius * percent;
        double x = halfWidth + r * cos(2 * pi / side * i);
        double y = halfHeight + r * sin(2 * pi / side * i);
        pointList.add(Offset(x, y));
      }
      // 画点 & 连线 & 写分数
      Paint pointPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      Paint linePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      for (int i = 0; i < side; i++) {
        canvas.drawCircle(pointList[i], 5, pointPaint);
        canvas.drawLine(pointList[i], pointList[(i + 1) % side], linePaint);
        TextPainter scorePainter = TextPainter(
          text: TextSpan(
            text: "${data[i].values.first}",
            style: const TextStyle(color: Colors.pink, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        scorePainter.layout();
        double offsetDistance = 20;
        double offsetX = pointList[i].dx < halfWidth ? -offsetDistance : offsetDistance;
        double offsetY = pointList[i].dy < halfHeight ? -offsetDistance : offsetDistance;
        scorePainter.paint(
            canvas,
            Offset(pointList[i].dx - scorePainter.width / 2 + offsetX,
                pointList[i].dy - scorePainter.height / 2 + offsetY));
        // 顶部文字
        double r = radius / 5 * 6;
        double x = halfWidth + r * cos(2 * pi / side * i);
        double y = halfHeight + r * sin(2 * pi / side * i);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: data[i].keys.first,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }
      // 绘制红色半透明
      Path fillPath = Path();
      for (int i = 0; i < side; i++) {
        if (i == 0) {
          fillPath.moveTo(pointList[i].dx, pointList[i].dy);
        } else {
          fillPath.lineTo(pointList[i].dx, pointList[i].dy);
        }
      }
      fillPath.close();
      Paint fillPaint = Paint()
        ..color = Colors.red.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawPath(fillPath, fillPaint);
    } else {
      // 绘制文字：数据量至少为3
      TextPainter textPainter = TextPainter(
        text: const TextSpan(
          text: "绘制蜘蛛图最少要有3类数据",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(halfWidth - textPainter.width / 2, halfHeight - textPainter.height / 2));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
