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
          appBar: AppBar(title: const Text('南丁格尔玫瑰图(鸡冠花图)')),
          body: const RoseChart(),
        ),
      );
}

class RoseChart extends StatefulWidget {
  const RoseChart({super.key});

  @override
  State<StatefulWidget> createState() => _RoseChartState();
}

class _RoseChartState extends State<RoseChart> with SingleTickerProviderStateMixin {
  late RoseChartModel _model;

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
        SizedBox(height: 400, child: Paper(painter: RosePainter(_model))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: refreshData, child: const Text("刷新数据"))
      ],
    )));
  }

  refreshData() {
    // 生成随机数据
    final random = Random();
    final items = List.generate(12, (index) {
      int balance = 0;
      // 收入随机范围[1000-5000]
      final income = 1000 + random.nextInt(4001);
      balance = income;
      final traffic = random.nextInt(income + 1);
      balance -= traffic;
      final food = balance == 0 ? 0 : random.nextInt(balance + 1);
      balance -= food;
      final game = balance == 0 ? 0 : random.nextInt(balance + 1);
      return RoseChartItem(income, traffic, food, game, balance);
    });
    _model = RoseChartModel(items);
    setState(() {});
  }
}

class RosePainter extends CustomPainter {
  final RoseChartModel model;

  RosePainter(this.model);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    const centerWhiteRadius = 20.0; // 中心白色圆的半径
    const betweenSpace = 1.0; // 每一层间的间隔
    const maxValue = 5000; // 收入的最大值

    // 裁剪画布,绘制浅灰背景,平移坐标原点到中心
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(50));
    canvas.translate(width / 2, height / 2);

    // 不同数据类型对应的颜色
    const Color trafficColor = Colors.lightGreen;
    const Color foodColor = Colors.lightBlue;
    const Color gameColor = Colors.pinkAccent;
    const Color balanceColor = Colors.orangeAccent;

    // 计算每条数据的平均弧度
    final averageAngle = (1.5 * pi - pi / 180 * 11) / model.items.length;

    // 遍历数据
    for (int i = 0; i < model.items.length; i++) {
      final item = model.items[i];
      // 本月收入的最大半径-取宽高中的最小值除以2求出最大半径,然后减去中间白色圆的半径和每一层之间的空白间隔,然后乘以[收入/收入值的平方根]
      final maxRadius =
          (min(width, height) / 2 - centerWhiteRadius - betweenSpace * 3 - 50) * sqrt(item.income / maxValue);
      // 计算起始绘制角度
      final startAngle = pi + i * (averageAngle + (i == 0 ? 0 : pi / 180));
      // 当前绘制的大小半径
      double smallRadius = centerWhiteRadius;
      double bigRadius = maxRadius * item.traffic / maxValue + centerWhiteRadius;

      // 绘制的画笔
      final Paint paint = Paint()..isAntiAlias = true;

      // 绘制交通支出
      Path trafficPath = Path()
        ..moveTo(cos(startAngle) * smallRadius, sin(startAngle) * smallRadius)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: smallRadius), startAngle, averageAngle, false)
        ..lineTo(cos(startAngle + averageAngle) * bigRadius, sin(startAngle + averageAngle) * bigRadius)
        ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: bigRadius), startAngle + averageAngle, -averageAngle, false)
        ..close();
      canvas.drawPath(trafficPath, paint..color = trafficColor);
      // 居中绘制百分比文字
      final trafficPainter = TextPainter(
          text: TextSpan(text: "${item.traffic}", style: const TextStyle(color: Colors.white, fontSize: 5)),
          textDirection: TextDirection.ltr)
        ..layout();
      // 判断路径中心点到路径边缘的宽高是否大于文字的宽高
      if (calculateDistancesToEdges(trafficPath)[0] > trafficPainter.width &&
          calculateDistancesToEdges(trafficPath)[1] > trafficPainter.height) {
        final center = Offset(cos(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2,
            sin(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2);
        final textOffset = Offset(center.dx - trafficPainter.width / 2, center.dy - trafficPainter.height / 2);
        trafficPainter.paint(canvas, textOffset);
      }

      // 绘制食物支出
      smallRadius = bigRadius + betweenSpace;
      bigRadius = maxRadius * item.food / maxValue + smallRadius;
      Path foodPath = Path()
        ..moveTo(cos(startAngle) * smallRadius, sin(startAngle) * smallRadius)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: smallRadius), startAngle, averageAngle, false)
        ..lineTo(cos(startAngle + averageAngle) * bigRadius, sin(startAngle + averageAngle) * bigRadius)
        ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: bigRadius), startAngle + averageAngle, -averageAngle, false)
        ..close();
      canvas.drawPath(foodPath, paint..color = foodColor);
      // 居中绘制百分比文字
      final foodPainter = TextPainter(
          text: TextSpan(text: "${item.food}", style: const TextStyle(color: Colors.white, fontSize: 5)),
          textDirection: TextDirection.ltr)
        ..layout();
      if (calculateDistancesToEdges(foodPath)[0] > foodPainter.width &&
          calculateDistancesToEdges(foodPath)[1] > foodPainter.height) {
        final center = Offset(cos(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2,
            sin(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2);
        final textOffset = Offset(center.dx - foodPainter.width / 2, center.dy - foodPainter.height / 2);
        foodPainter.paint(canvas, textOffset);
      }

      // 绘制娱乐支出
      smallRadius = bigRadius + betweenSpace;
      bigRadius = maxRadius * item.game / maxValue + smallRadius;
      Path gamePath = Path()
        ..moveTo(cos(startAngle) * smallRadius, sin(startAngle) * smallRadius)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: smallRadius), startAngle, averageAngle, false)
        ..lineTo(cos(startAngle + averageAngle) * bigRadius, sin(startAngle + averageAngle) * bigRadius)
        ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: bigRadius), startAngle + averageAngle, -averageAngle, false)
        ..close();
      canvas.drawPath(gamePath, paint..color = gameColor);
      // 居中绘制百分比文字
      final gamePainter = TextPainter(
          text: TextSpan(text: "${item.game}", style: const TextStyle(color: Colors.white, fontSize: 5)),
          textDirection: TextDirection.ltr)
        ..layout();
      if (calculateDistancesToEdges(gamePath)[0] > gamePainter.width &&
          calculateDistancesToEdges(gamePath)[1] > gamePainter.height) {
        final center = Offset(cos(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2,
            sin(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2);
        final textOffset = Offset(center.dx - gamePainter.width / 2, center.dy - gamePainter.height / 2);
        gamePainter.paint(canvas, textOffset);
      }

      // 绘制余额
      smallRadius = bigRadius + betweenSpace;
      bigRadius = maxRadius * item.balance / maxValue + smallRadius;
      Path balancePath = Path()
        ..moveTo(cos(startAngle) * smallRadius, sin(startAngle) * smallRadius)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: smallRadius), startAngle, averageAngle, false)
        ..lineTo(cos(startAngle + averageAngle) * bigRadius, sin(startAngle + averageAngle) * bigRadius)
        ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: bigRadius), startAngle + averageAngle, -averageAngle, false)
        ..close();
      canvas.drawPath(balancePath, paint..color = balanceColor);
      // 居中绘制百分比文字
      final balancePainter = TextPainter(
          text: TextSpan(text: "${item.balance}", style: const TextStyle(color: Colors.white, fontSize: 5)),
          textDirection: TextDirection.ltr)
        ..layout();
      if (calculateDistancesToEdges(balancePath)[0] > balancePainter.width &&
          calculateDistancesToEdges(balancePath)[1] > balancePainter.height) {
        final center = Offset(cos(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2,
            sin(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2);
        final textOffset = Offset(center.dx - balancePainter.width / 2, center.dy - balancePainter.height / 2);
        balancePainter.paint(canvas, textOffset);
      }

      // 弧度中点旋转绘制月份
      smallRadius = bigRadius + 30;
      final month = i + 1;
      final monthPainter = TextPainter(
          text: TextSpan(text: "$month月", style: const TextStyle(color: Colors.black, fontSize: 10)),
          textDirection: TextDirection.ltr)
        ..layout();
      final monthCenter = Offset(cos(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2,
          sin(startAngle + averageAngle / 2) * (smallRadius + bigRadius) / 2);
      final monthOffset = Offset(monthCenter.dx - monthPainter.width / 2, monthCenter.dy - monthPainter.height / 2);
      monthPainter.paint(canvas, monthOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  // 计算Path到水平和垂直边缘的距离
  List<double> calculateDistancesToEdges(Path path) {
    final bounds = path.getBounds();
    final centerPoint = bounds.center;
    final leftDistance = centerPoint.dx - bounds.left;
    final rightDistance = bounds.right - centerPoint.dx;
    final topDistance = centerPoint.dy - bounds.top;
    final bottomDistance = bounds.bottom - centerPoint.dy;
    return [leftDistance + rightDistance, topDistance + bottomDistance];
  }
}

class RoseChartModel {
  final List<RoseChartItem> items;

  RoseChartModel(this.items);
}

class RoseChartItem {
  final int income; // 收入
  final int traffic; // 交通支出
  final int food; // 食物支出
  final int game; // 娱乐支出
  final int balance; // 余额

  RoseChartItem(this.income, this.traffic, this.food, this.game, this.balance);
}
