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
          appBar: AppBar(title: const Text('文字绘制效果预览')),
          body: const TextPaintAnimPreview(),
        ),
      );
}

class TextPaintAnimPreview extends StatefulWidget {
  const TextPaintAnimPreview({super.key});

  @override
  State<StatefulWidget> createState() => _TextPaintAnimPreviewState();
}

class _TextPaintAnimPreviewState extends State<TextPaintAnimPreview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)..addListener(() {});
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      fastText('① 颜色渐变 + 外框模糊遮罩', CPTextStyle.s16.bold.c(Colors.red)),
      RepaintBoundary(child: SizedBox(height: 100, child: Paper(painter: _FirstPainter(_animation)))),
      fastText('② 文字斜阴影', CPTextStyle.s16.bold.c(Colors.red)),
      RepaintBoundary(child: SizedBox(height: 100, child: Paper(painter: _SecondPainter(_animation)))),
      fastText('③ 跑马灯', CPTextStyle.s16.bold.c(Colors.red)),
      RepaintBoundary(child: SizedBox(height: 100, child: Paper(painter: _ThirdPainter(_animation)))),
      fastText('④ 掘金Loading效果', CPTextStyle.s16.bold.c(Colors.red)),
      RepaintBoundary(child: SizedBox(height: 100, child: Paper(painter: _ForthPainter(_animation)))),
    ]));
  }
}

class _FirstPainter extends CustomPainter {
  final Animation<double> animation;

  double width = 0.0;
  double height = 0.0;
  String text = "杰哥不要";

  _FirstPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;

    // 预绘制文字获取绘制宽高、绘制的起点
    TextSpan textSpan = TextSpan(text: text, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold));
    TextPainter textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    // 绘制的起点
    final dx = (size.width - textWidth) / 2;
    final dy = (size.height - textHeight) / 2;

    // 实际绘制
    // 线性渐变(红黄绿蓝、区域外的渐变的绘制方式-mirror镜像重复、旋转45度)
    const gradient = LinearGradient(
        colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
        tileMode: TileMode.repeated,
        transform: GradientRotation(pi / 4));
    textSpan = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: 50,
            // 前景，shader设置渐变色、maskFilter设置模糊遮罩、style设置描边+strokeWidth设置描边宽度 → 字体镂空效果
            foreground: Paint()
              ..shader = gradient.createShader(
                  Rect.fromLTWH(dx + animation.value * textWidth, dy, textPainter.width, textPainter.height))
              ..maskFilter = MaskFilter.blur(BlurStyle.solid, 3 * animation.value)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2));
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();

    // 文字居中绘制
    textPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SecondPainter extends CustomPainter {
  final Animation<double> animation;

  double width = 0.0;
  double height = 0.0;
  String text = "杰哥不要";

  _SecondPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;

    // 预绘制文字获取绘制宽高、绘制的起点
    TextSpan textSpan = TextSpan(text: text, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold));
    TextPainter textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    // 绘制的起点
    final dx = (size.width - textWidth) / 2;
    final dy = (size.height - textHeight) / 2;

    canvas.save();
    canvas.skew(0.05 * animation.value, 0.0);
    // 实际绘制，先绘制背后的斜阴影，再绘制前面的文字
    textSpan =
        TextSpan(text: text, style: TextStyle(fontSize: 50, foreground: Paint()..color = Colors.black.withAlpha(100)));
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(dx, dy));
    canvas.restore();
    textSpan = TextSpan(text: text, style: TextStyle(fontSize: 50, foreground: Paint()..color = Colors.black));
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ThirdPainter extends CustomPainter {
  final Animation<double> animation;

  double width = 0.0;
  double height = 0.0;
  String text = "杰哥不要";

  _ThirdPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    // 裁剪画布，避免文字超出
    canvas.clipRect(Offset.zero & size);

    // 预绘制文字获取绘制宽高、绘制的起点
    TextSpan textSpan = TextSpan(text: text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    TextPainter textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    // 水平方向的文字，从屏幕的右边飞入，然后从左边飞出
    textSpan = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            foreground: Paint()..color = Colors.black));
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    // 水平和垂直方向
    // double xOffset = (size.width + textWidth) * (1 - animation.value) - textWidth * 1.5;
    // double yOffset = (size.height - textHeight) * (1 - animation.value) - textHeight * 1.5;
    // textPainter.paint(canvas, Offset(xOffset, (size.height - textHeight) / 2));
    // textPainter.paint(canvas, Offset((size.width - textWidth) / 2, yOffset));

    // 各绘制两组文字,过渡更加平滑
    final xOffset = size.width * (1 - animation.value);
    final yOffset = size.height * (1 - animation.value);
    textPainter.paint(canvas, Offset(xOffset, (size.height - textHeight) / 2));
    textPainter.paint(canvas, Offset(xOffset - size.width, (size.height - textHeight) / 2));
    textPainter.paint(canvas, Offset((size.width - textWidth) / 2, yOffset));
    textPainter.paint(canvas, Offset((size.width - textWidth) / 2, yOffset - size.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ForthPainter extends CustomPainter {
  final Animation<double> animation;
  double width = 0.0;
  double height = 0.0;
  String text = "杰哥不要";

  _ForthPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    // 裁剪画布，避免文字超出
    canvas.clipRect(Offset.zero & size);
    // 预绘制文字获取绘制宽高、绘制的起点
    TextSpan textSpan =
        TextSpan(text: text, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey));
    TextPainter textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // 平行四边形 + 左右梯形实现
    final startX =
        (size.width - textWidth) / 2 - textHeight * 2 - 10 + (textWidth + textHeight * 2 + 10) * animation.value;
    // 绘制中间的透明平行四边形
    final path = Path()
      ..moveTo(startX, (size.height - textHeight) / 2)
      ..relativeLineTo(textHeight, 0)
      ..relativeLineTo(textHeight, textHeight)
      ..relativeLineTo(-textHeight, 0)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill);
    // 绘制前面的体型
    path.reset();
    path
      ..moveTo(startX, (size.height - textHeight) / 2)
      ..relativeLineTo(-textWidth, 0)
      ..relativeLineTo(0, textHeight)
      ..relativeLineTo(textWidth + textHeight, 0)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withAlpha(100)
          ..style = PaintingStyle.fill);
    // 绘制后面
    path.reset();
    path
      ..moveTo(startX + textHeight + 10, (size.height - textHeight) / 2)
      ..relativeLineTo(textHeight, textHeight)
      ..relativeLineTo(textWidth, 0)
      ..relativeLineTo(0, -textHeight)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withAlpha(100)
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
