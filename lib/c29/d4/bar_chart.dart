import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:flutter/material.dart';

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<StatefulWidget> createState() => _BarChartPage();
}

class _BarChartPage extends State<BarChartPage> with SingleTickerProviderStateMixin {
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
        appBar: AppBar(title: const Text('柱形/直方图')),
        body: SizedBox(
            height: 300,
            child: Paper(
                painter: BarChartPainter(
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
                    _controller))));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// 柱形/直方图绘制
class BarChartPainter extends CustomPainter {
  final int yMin;
  final int yMax;
  final int yStep;
  final List<Map<int, int>> data;
  final Animation<double> repaint;

  BarChartPainter(this.yMin, this.yMax, this.yStep, this.data, this.repaint) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制一个浅灰色背景标识画布区域
    final width = size.width;
    final height = size.height;
    final maxWidth = width - 40; // 最大绘制宽度
    final maxHeight = height - 80; // 最大绘制高度
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    final barPaint = Paint()..color = Colors.blue;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF0F0F0));
    // 先保存画布状态
    canvas.save();
    // 移动画布原点到底部，x轴30，y轴60
    canvas.translate(30, size.height - 60);
    // 绘制原点
    canvas.drawCircle(const Offset(0, 0), 2, Paint()..color = Colors.red);
    // 画Y轴线
    canvas.drawLine(const Offset(0, 0), Offset(0, -maxHeight), linePaint);
    // 画Y轴刻度，先求要绘制的点数量，然后算偏移
    final yCount = (yMax - yMin) ~/ yStep;
    for (int i = 0; i <= yCount; i++) {
      final y = i * yStep;
      final yPosition = -maxHeight * y / (yMax - yMin);
      canvas.drawLine(Offset(0, yPosition), Offset(5, yPosition), linePaint);
      final textPainter = TextPainter(
        text: TextSpan(text: y.toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-20, yPosition - 5));
    }
    // 画X轴线
    canvas.drawLine(const Offset(0, 0), Offset(maxWidth, 0), linePaint);
    // 画X轴年的刻度 & 柱子 & 数字
    const startX = 20; // x轴起始绘制位置
    double distanceX = 10; // x轴每个刻度的间距
    double widthX = (maxWidth - startX) / data.length - distanceX; // x轴绘制宽度
    for (int i = 0; i < data.length; i++) {
      final x = data[i].keys.first;
      final y = data[i].values.first;
      final xPosition = startX + (distanceX + widthX) * i;
      final yPosition = -maxHeight * y / (yMax - yMin) * repaint.value;
      // 底部年份
      TextPainter(
          text: TextSpan(text: x.toString(), style: const TextStyle(color: Colors.grey, fontSize: 8)),
          textDirection: TextDirection.ltr)
        ..layout()
        ..paint(canvas, Offset(xPosition - 10, 5));
      // 柱子
      canvas.drawRect(Rect.fromLTWH(xPosition - 10, yPosition, 20, -(yPosition)), barPaint);
      // 柱子顶部数字
      TextPainter textPainter = TextPainter(
          text: TextSpan(text: y.toString(), style: const TextStyle(color: Colors.grey, fontSize: 8)),
          textDirection: TextDirection.ltr)
        ..layout();
      textPainter.paint(canvas, Offset(xPosition - textPainter.width / 2, yPosition - 10));
    }
    // 底部描述信息
    canvas.restore();
    canvas.save();
    canvas.translate(width / 2, height - 20);
    canvas.drawRect(Rect.fromCircle(center: const Offset(-10, 3), radius: 6), barPaint);
    final goalTextPainter = TextPainter(
        text: const TextSpan(text: "金牌", style: TextStyle(color: Colors.grey, fontSize: 10)),
        textDirection: TextDirection.ltr)
      ..layout();
    goalTextPainter.paint(canvas, Offset(2, -goalTextPainter.height / 2 + 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
