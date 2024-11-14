import 'dart:math';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:flutter/material.dart';

class PathApiSecondPreview extends StatefulWidget {
  const PathApiSecondPreview({super.key});

  @override
  State<StatefulWidget> createState() => _PathApiSecondPreviewState();
}

class _PathApiSecondPreviewState extends State<PathApiSecondPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Path API-添加路径')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                _buildContent(),
                const SizedBox(height: 20),
              ],
            ))));
  }

  Widget _buildContent() {
    late double halfWidth;
    late double halfHeight;
    final paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    late Rect rect;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          rect = Rect.fromLTWH(halfWidth, halfHeight - 15, 50, 30);
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          path.addArc(rect, 0, pi);
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("addArc()-添加圆弧", size.width - 10, Colors.red), Offset(5, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          path.addOval(rect);
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("addOval()-添加椭圆", size.width - 10, Colors.red), Offset(5, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          Path newPath = Path();
          newPath.moveTo(halfWidth + 20, halfHeight - 30);
          newPath.lineTo(halfWidth + 40, halfHeight + 20);
          path.addPath(newPath, const Offset(0, -10));
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("addPath()-添加路径", size.width - 10, Colors.red), Offset(5, size.height - 40));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          Path newPath = Path();
          newPath.moveTo(halfWidth + 20, halfHeight - 30);
          newPath.lineTo(halfWidth + 40, halfHeight + 20);
          path.extendWithPath(newPath, const Offset(0, -10));
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("extendWithPath()\n-扩展路径", size.width - 10, Colors.red), Offset(5, size.height - 40));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          Path newPath = Path();
          newPath.moveTo(halfWidth, halfHeight - 30);
          newPath.lineTo(halfWidth, halfHeight + 30);
          path.addRect(rect);
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("addRect()-添加矩形", size.width - 10, Colors.red), Offset(5, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          Path newPath = Path();
          newPath.moveTo(halfWidth, halfHeight - 30);
          newPath.lineTo(halfWidth, halfHeight + 30);
          RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
          path.addRRect(rRect);
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("addRRect()-\n添加圆角矩形", size.width - 10, Colors.red), Offset(20, size.height - 35));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.moveTo(10, halfHeight);
          path.lineTo(halfWidth, halfHeight);
          Path newPath = Path();
          newPath.moveTo(halfWidth, halfHeight - 30);
          newPath.lineTo(halfWidth, halfHeight + 30);
          path.addPolygon([
            Offset(halfWidth, halfHeight),
            Offset(halfWidth + 20, halfHeight - 20),
            Offset(halfWidth + 40, halfHeight),
            Offset(halfWidth + 30, halfHeight + 20),
            Offset(halfWidth + 10, halfHeight + 20),
          ], true);
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("addPolygon()-\n添加多边形", size.width - 10, Colors.red), Offset(20, size.height - 35));
        })),
      ])
    ]);
  }
}
