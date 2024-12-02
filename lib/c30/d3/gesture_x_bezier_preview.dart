import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../c29/fast_widget_ext.dart';
import '../../utils/text_ext.dart';

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
  Widget build(BuildContext context) => const MaterialApp(home: Scaffold(body: GestureXBezierPreview()));
}

class GestureXBezierPreview extends StatefulWidget {
  const GestureXBezierPreview({super.key});

  @override
  State<StatefulWidget> createState() => _GestureXBezierPreviewState();
}

class _GestureXBezierPreviewState extends State<GestureXBezierPreview> {
  final ValueNotifier<Offset> offset = ValueNotifier<Offset>(Offset.zero);
  final ValueNotifier<int> reset = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                fastText("手势+贝塞尔曲线示例 (拖动控制点可以改变曲线形状)", CPTextStyle.s18.bold.c(Colors.redAccent)),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      reset.value++;
                      offset.value = Offset.zero;
                    },
                    child: const Text("重置"))
              ],
            ),
            Expanded(
                child: LayoutBuilder(
                    builder: (context, constraints) => GestureDetector(
                        onPanUpdate: (details) {
                          offset.value = details.localPosition;
                        },
                        child: CustomPaint(painter: GestureBezierPainter(offset, reset), size: constraints.biggest))))
          ],
        ));
  }
}

class GestureBezierPainter extends CustomPainter {
  final ValueNotifier<Offset> offset;
  final ValueNotifier<int> reset;
  double width = 0;
  double height = 0;
  double space = 20;
  double percentWidth = 0.0;
  double percentHeight = 0.0;
  Paint grayLinePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  // 维护控制点
  Offset p1 = Offset.zero;
  Offset p2 = Offset.zero;

  GestureBezierPainter(this.offset, this.reset) : super(repaint: Listenable.merge([offset, reset]));

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    percentWidth = (width - space * 2) / 4;
    percentHeight = (height - space * 2) / 4;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(20));
    canvas.save();
    // 坐标原点挪到左下角
    canvas.translate(space, height - space);
    // 绘制坐标系
    canvas.drawLine(Offset.zero, Offset(0, -height + space * 2), grayLinePaint);
    canvas.drawLine(Offset.zero, Offset(width - space * 2, 0), grayLinePaint);
    // 起点p0和终点p3
    final p0 = Offset(width / 2 - 90, -percentHeight);
    final p3 = Offset(width / 2 + 90, -percentHeight * 3);
    // 计算控制点p1和p2
    final p1Rect = Rect.fromCircle(center: p1, radius: 20);
    final p2Rect = Rect.fromCircle(center: p2, radius: 20);
    final offsetPoint = Offset(offset.value.dx - space, offset.value.dy - height + space);
    // 判断是否是初始状态
    if(offset.value == Offset.zero) {
      p1 = Offset(p0.dx + 60, p0.dy);
      p2 = Offset(p3.dx - 60, p3.dy);
    } else {
      // 判断触点是否在控制点p1和p2的范围内
      if (p1Rect.contains(offsetPoint)) p1 = offsetPoint;
      if (p2Rect.contains(offsetPoint)) p2 = offsetPoint;
    }
    // 绘制控制点
    final blueLinePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(p0, p1, blueLinePaint);
    canvas.drawLine(p2, p3, blueLinePaint);
    // 绘制三阶贝塞尔曲线
    final redLinePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
    canvas.drawPath(path, redLinePaint);
    drawBorderCircle(canvas, p0);
    drawBorderCircle(canvas, p3);
    drawBorderCircle(canvas, p1, fillColor: Colors.blue);
    drawBorderCircle(canvas, p2, fillColor: Colors.blue);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
