import 'dart:math';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';

class PathApiFirstPreview extends StatefulWidget {
  const PathApiFirstPreview({super.key});

  @override
  State<StatefulWidget> createState() => _PathApiFirstPreviewState();
}

class _PathApiFirstPreviewState extends State<PathApiFirstPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Path API-移动路径')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMoveToLineTo(),
                    fastLine(),
                    _buildArcTo(),
                    fastLine(),
                    _buildArcToPoint(),
                    fastLine(),
                    _buildConicTo(),
                    fastLine(),
                    buildQuadraticBezierTo(),
                    fastLine(),
                    buildCubicTo(),
                    const SizedBox(height: 20),
                  ],
                ))));
  }

  Widget _buildMoveToLineTo() {
    late double halfWidth;
    late double halfHeight;
    double triangleWidth = 30;
    double triangleHeight = 40;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fastText('① 绝对 & 相对 的 moveTo() + lineTo()', CPTextStyle.s16.bold.c(Colors.red)),
        fastGridView([
          // 绝对
          AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
            halfWidth = size.width / 2;
            halfHeight = size.height / 2;
            final paint = Paint()
              ..color = Colors.blue
              ..isAntiAlias = true
              ..style = PaintingStyle.fill;
            Path path = Path();
            path.moveTo(halfWidth, halfHeight - triangleHeight);
            path.lineTo(halfWidth - triangleWidth, halfHeight);
            path.lineTo(halfWidth + triangleWidth, halfHeight);
            path.close();
            canvas.drawPath(path, paint);
            path.reset();
            paint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4.0
              ..color = Colors.red;
            path.moveTo(halfWidth, halfHeight + triangleHeight);
            path.lineTo(halfWidth - triangleWidth, halfHeight);
            path.lineTo(halfWidth + triangleWidth, halfHeight);
            path.close();
            canvas.drawPath(path, paint);
          })),
          // 相对
          AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
            final paint = Paint()
              ..color = Colors.blue
              ..isAntiAlias = true
              ..style = PaintingStyle.fill;
            Path path = Path();
            path.moveTo(halfWidth, halfHeight - triangleHeight);
            path.relativeLineTo(-triangleWidth, triangleHeight);
            path.relativeLineTo(triangleWidth * 2, 0);
            path.close();
            canvas.drawPath(path, paint);
            path.reset();
            paint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4.0
              ..color = Colors.red;
            path.moveTo(halfWidth, halfHeight + triangleHeight);
            path.relativeLineTo(-triangleWidth, -triangleHeight);
            path.relativeLineTo(triangleWidth * 2, 0);
            path.close();
            canvas.drawPath(path, paint);
          }))
        ]),
        fastText('左侧采用绝对坐标，右侧采用相对偏移，后者写起来更加简单', CPTextStyle.s14.c(Colors.black)),
      ],
    );
  }

  Widget _buildArcTo() {
    late double halfWidth;
    late double halfHeight;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('② 画弧：arcTo()', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          final paint = Paint()
            ..color = Colors.blue
            ..isAntiAlias = true
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0;
          Path path = Path();
          path.moveTo(halfWidth, halfHeight);
          path.arcTo(Rect.fromCenter(center: Offset(halfWidth, halfHeight), width: 100, height: 100), 0, pi, true);
          canvas.drawPath(path, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          final paint = Paint()
            ..color = Colors.blue
            ..isAntiAlias = true
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0;
          Path path = Path();
          path.moveTo(halfWidth, halfHeight);
          path.arcTo(Rect.fromCenter(center: Offset(halfWidth, halfHeight), width: 100, height: 100), 0, pi, false);
          canvas.drawPath(path, paint);
        })),
      ]),
      fastText('最后的「forceMoveTo」参数决定绘制弧线前是否移动到弧线起点，左侧效果为true，右侧为false',
          CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  Widget _buildArcToPoint() {
    late double halfWidth;
    late double halfHeight;
    final paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('③ 添加圆弧片段：arcToPoint() & relativeArcToPoint()', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          Path path = Path();
          path.moveTo(halfWidth - 30, halfHeight);
          path.lineTo(halfWidth, halfHeight + 40);
          path.lineTo(halfWidth + 30, halfHeight);
          path.arcToPoint(Offset(halfWidth - 30, halfHeight),
              radius: const Radius.circular(60), largeArc: false, clockwise: true);
          path.close();
          canvas.drawPath(path, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(halfWidth - 30, halfHeight);
          path.lineTo(halfWidth, halfHeight + 40);
          path.lineTo(halfWidth + 30, halfHeight);
          path.arcToPoint(Offset(halfWidth - 30, halfHeight),
              radius: const Radius.circular(60), largeArc: false, clockwise: false);
          path.close();
          canvas.drawPath(path, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(halfWidth - 30, halfHeight);
          path.lineTo(halfWidth, halfHeight + 40);
          path.lineTo(halfWidth + 30, halfHeight);
          path.arcToPoint(Offset(halfWidth - 30, halfHeight),
              radius: const Radius.circular(35), largeArc: true, clockwise: true);
          path.close();
          canvas.drawPath(path, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          Path path = Path();
          path.moveTo(halfWidth - 30, halfHeight);
          path.lineTo(halfWidth, halfHeight + 40);
          path.lineTo(halfWidth + 30, halfHeight);
          path.relativeArcToPoint(const Offset(-60, 0),
              radius: const Radius.circular(60), largeArc: false, clockwise: true);
          path.close();
          canvas.drawPath(path, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(halfWidth - 30, halfHeight);
          path.lineTo(halfWidth, halfHeight + 40);
          path.lineTo(halfWidth + 30, halfHeight);
          path.relativeArcToPoint(const Offset(-60, 0),
              radius: const Radius.circular(60), largeArc: false, clockwise: false);
          path.close();
          canvas.drawPath(path, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(halfWidth - 30, halfHeight);
          path.lineTo(halfWidth, halfHeight + 40);
          path.lineTo(halfWidth + 30, halfHeight);
          path.relativeArcToPoint(const Offset(-60, 0),
              radius: const Radius.circular(35), largeArc: true, clockwise: true);
          path.close();
          canvas.drawPath(path, paint);
        }))
      ]),
      fastText(
          '这两方法的参数依次为「offset-圆弧终点位置」「radius-圆弧半径」「rotation-圆弧旋转角度」「largeArc-是否绘制大于180度的弧线，true优弧、false劣弧」「clockwise-绘制方向，true顺时针，false逆时针」。\n运行效果依次为：劣顺、劣逆、优顺。',
          CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  Widget _buildConicTo() {
    late double halfWidth;
    late double halfHeight;
    late Offset startPoint;
    late Offset controlPoint;
    late Offset endPoint;
    final paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('④ 带权重的二阶贝塞尔曲线：conicTo() & relativeConicTo()', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          startPoint = Offset(0, size.height);
          controlPoint = Offset(halfWidth, halfHeight - 50);
          endPoint = Offset(size.width, size.height);
          Path path = Path();
          path.moveTo(startPoint.dx, startPoint.dy);
          // 参数依次为：控制点、终点、权重
          path.conicTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy, 0.5);
          canvas.drawPath(path, paint);
          canvas.drawCircle(controlPoint, 3, Paint()
            ..color = Colors.green);
          canvas.drawParagraph(fastParagraph("w<1 椭圆线", size.width, Colors.purple), Offset(25, halfHeight));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(startPoint.dx, startPoint.dy);
          // 参数依次为：控制点、终点、权重
          path.conicTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy, 1);
          canvas.drawPath(path, paint);
          canvas.drawCircle(controlPoint, 3, Paint()
            ..color = Colors.green);
          canvas.drawParagraph(fastParagraph("w=1 抛物线", size.width, Colors.purple), Offset(25, halfHeight - 25));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(startPoint.dx, startPoint.dy);
          // 参数依次为：控制点、终点、权重
          path.conicTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy, 2);
          canvas.drawPath(path, paint);
          canvas.drawCircle(controlPoint, 3, Paint()
            ..color = Colors.green);
          canvas.drawParagraph(fastParagraph("w>1 双曲线", size.width, Colors.purple), Offset(25, halfHeight - 35));
        })),
      ]),
      fastText(
          '先调 moveTo() 移动到绘制起点，然后 conicTo() 参数依次为：控制点 (图中绿色圆点，影响曲线弯曲方向的点，'
              '不一定在曲线上，但它会拉动曲线使其朝向控制点弯曲)、终点、权重 (决定曲线弯曲程度，'
              '为1时和quadraticBezierTo()小姑哦相同，w>1时更靠近控制点，0<w<1时远离控制点)',
          CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  Widget buildQuadraticBezierTo() {
    late double halfWidth;
    late double halfHeight;
    late Offset startPoint;
    late Offset controlPoint;
    late Offset endPoint;
    final paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText(
          '⑤ 二阶贝塞尔曲线：quadraticBezierTo() & relativeQuadraticBezierTo()', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          startPoint = Offset(0, halfHeight);
          controlPoint = Offset(halfWidth, halfHeight - 50);
          endPoint = Offset(size.width, size.height);
          Path path = Path();
          path.moveTo(startPoint.dx, startPoint.dy);
          path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
          canvas.drawPath(path, paint);
          canvas.drawCircle(controlPoint, 3, Paint()
            ..color = Colors.green);
          canvas.drawLine(controlPoint, startPoint, Paint()
            ..color = Colors.pink);
          canvas.drawLine(controlPoint, endPoint, Paint()
            ..color = Colors.pink);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          controlPoint = Offset(size.width - 20, halfHeight - 50);
          Path path = Path();
          path.moveTo(startPoint.dx, startPoint.dy);
          path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
          canvas.drawPath(path, paint);
          canvas.drawCircle(controlPoint, 3, Paint()
            ..color = Colors.green);
          canvas.drawLine(controlPoint, startPoint, Paint()
            ..color = Colors.pink);
          canvas.drawLine(controlPoint, endPoint, Paint()
            ..color = Colors.pink);
        }))
      ]),
      fastText('参数依次为：控制点 (图中绿色圆点)、终点，粉色线为笔者绘制的辅助点线', CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  Widget buildCubicTo() {
    late double halfWidth;
    late double halfHeight;
    late Offset startPoint;
    late Offset firstControlPoint;
    late Offset secondControlPoint;
    late Offset endPoint;
    final paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('⑤ 三阶贝塞尔曲线：cubicTo() & relativeCubicTo()', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          startPoint = Offset(0, halfHeight);
          firstControlPoint = Offset(halfWidth, halfHeight - 50);
          secondControlPoint = Offset(halfWidth + 50, halfHeight -30);
          endPoint = Offset(size.width, size.height);
          Path path = Path();
          path.moveTo(startPoint.dx, startPoint.dy);
          path.cubicTo(
              firstControlPoint.dx, firstControlPoint.dy, secondControlPoint.dx, secondControlPoint.dy, endPoint.dx,
              endPoint.dy);
          canvas.drawPath(path, paint);
          canvas.drawCircle(firstControlPoint, 3, Paint()..color = Colors.green);
          canvas.drawCircle(secondControlPoint, 3, Paint()..color = Colors.green);
          canvas.drawLine(firstControlPoint, startPoint, Paint()..color = Colors.pink);
          canvas.drawLine(secondControlPoint, endPoint, Paint()..color = Colors.pink);
          canvas.drawLine(firstControlPoint, secondControlPoint, Paint()..color = Colors.pink);
        })),
      ]),
      fastText('参数依次为：第一个控制点、第二个控制点、终点', CPTextStyle.s14.c(Colors.black)),
    ]);
  }
}
