import 'dart:math';
import 'package:flutter/material.dart';
import '../paper.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  State<StatefulWidget> createState() => _PieChartPage();
}

class _PieChartPage extends State<PieChartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late List<Map<String, double>> _data;
  final List<Color> _colors = [
    const Color(0xFF59C47E),
    const Color(0xFF8AD7AB),
    const Color(0xFFBAEDD8),
    const Color(0xFF62A1F5),
    const Color(0xFF9EC6F4),
    const Color(0xFFCFE0FE),
    const Color(0xFFF1AA60),
    const Color(0xFFF7CD9D),
  ];

  refreshData() {
    setState(() {
      _data = generateData();
      _controller.forward(from: 0);
    });
  }

  @override
  void initState() {
    super.initState();
    _data = generateData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
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
            child: Paper(painter: PieChartPainter(_data, _colors, _controller)),
          )
        ]));
  }

  // 随机生成数据
  List<Map<String, double>> generateData() {
    List<String> keys = ["公众号信息", "朋友圈", "聊天会话", "公众号主页", "推荐", "搜一搜", "朋友在看", "其它"];
    Random random = Random();
    List<double> values = List.generate(keys.length, (_) => random.nextDouble());
    double sum = values.reduce((a, b) => a + b);
    values = values.map((value) => value / sum).toList();
    List<Map<String, double>> data = [];
    for (int i = 0; i < keys.length; i++) {
      data.add({keys[i]: values[i]});
    }
    return data;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, double>> data;
  final List<Color> colors;
  final Animation<double> repaint;

  double width = 0.0;
  double height = 0.0;
  double halfWidth = 0.0;
  double titleEndY = 0.0; // 标题结束的Y坐标
  double pieEndY = 0.0; // 标题结束的Y坐标
  double radius = 0.0;  // 饼图半径

  PieChartPainter(
    this.data,
    this.colors,
    this.repaint,
  ) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    halfWidth = size.width / 2;
    // 绘制一条居中从上往下的线
    canvas.drawLine(Offset(halfWidth, 0), Offset(halfWidth, height), Paint()..color = Colors.grey);
    drawTitle(canvas);
    drawPie(canvas);
    drawDesc(canvas);
  }

  drawTitle(Canvas canvas) {
    TextPainter textPainter = TextPainter(
        text: const TextSpan(
            text: "· 阅读来源 ·", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    // 文字居中
    textPainter.paint(canvas, Offset(halfWidth - textPainter.width / 2, 10));
    titleEndY = textPainter.height + 10;
  }

  drawPie(Canvas canvas) {
    // 圆半径
    radius = halfWidth / 2;
    // 求圆心
    Offset center = Offset(width / 2, titleEndY + radius + 30);
    // -90°开始画
    double startAngle = -pi / 2;


    // 裁剪动画
    canvas.save();
    Path clipPath = Path();
    // 起点挪到中心点
    clipPath.moveTo(center.dx, center.dy);
    clipPath.arcTo(
      Rect.fromCircle(center: center, radius: radius), // 以中心点为圆心的圆
      startAngle, // 起始角度
      2 * pi * repaint.value, // 扫过角度
      false
    );
    clipPath.close();
    if(repaint.value!=1.0){
      canvas.clipPath(clipPath);
    }

    // 遍历画弧
    for (int i = 0; i < data.length; i++) {
      double sweepAngle = data[i].values.first * 2 * pi;
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          Paint()
            ..isAntiAlias = true
            ..color = colors[i]);
      startAngle += sweepAngle;
    }
    pieEndY = titleEndY + radius * 2 + 60;

    // 画前面的圆
    canvas.drawCircle(center, radius / 2, Paint()..color = Colors.white);
    canvas.restore();
  }

  drawDesc(Canvas canvas) {
    // 每一项的宽高
    final itemWidth = halfWidth - 40;
    const itemHeight = 20.0;
    const itemSpace = 15.0;
    for (int i = 0; i < data.length; i++) {
      // 类型
      TextPainter categoryPainter = TextPainter(
          text: TextSpan(
              text: data[i].keys.first,
              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal)),
          textDirection: TextDirection.ltr);
      categoryPainter.layout();

      // 百分比
      TextPainter percentPainter = TextPainter(
          text: TextSpan(
              text: "${(data[i].values.first * 100).toStringAsFixed(2)}%",
              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal)),
          textDirection: TextDirection.ltr);
      percentPainter.layout();
      // 循环绘制
      if (i < 4) {
        canvas.drawRect(
            Rect.fromLTWH(halfWidth - itemWidth, pieEndY + (itemHeight + itemSpace) * (i % 4), itemHeight, itemHeight),
            Paint()..color = colors[i]);
        categoryPainter.paint(
            canvas,
            Offset(halfWidth - itemWidth + itemHeight + 10,
                pieEndY + (itemHeight + itemSpace) * (i % 4) + (itemHeight - categoryPainter.height) / 2));
        // 右边对齐
        percentPainter.paint(
            canvas,
            Offset(halfWidth - percentPainter.width - 20,
                pieEndY + (itemHeight + itemSpace) * (i % 4) + (itemHeight - percentPainter.height) / 2));
      } else {
        canvas.drawRect(
            Rect.fromLTWH(halfWidth + 20, pieEndY + (itemHeight + itemSpace) * (i % 4), itemHeight, itemHeight),
            Paint()..color = colors[i]);
        categoryPainter.paint(
            canvas,
            Offset(halfWidth + 20 + itemHeight + 10,
                pieEndY + (itemHeight + itemSpace) * (i % 4) + (itemHeight - categoryPainter.height) / 2));
        // 右边对齐
        percentPainter.paint(
            canvas,
            Offset(width - percentPainter.width - 40,
                pieEndY + (itemHeight + itemSpace) * (i % 4) + (itemHeight - percentPainter.height) / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
