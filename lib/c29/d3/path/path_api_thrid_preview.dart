import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:flutter/material.dart';

class PathApiThirdPreview extends StatefulWidget {
  const PathApiThirdPreview({super.key});

  @override
  State<StatefulWidget> createState() => _PathApiThirdPreviewState();
}

class _PathApiThirdPreviewState extends State<PathApiThirdPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Path API-其它')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                _buildTransform(),
                const SizedBox(height: 20),
              ],
            ))));
  }

  Widget _buildTransform() {
    late double halfWidth;
    late double halfHeight;
    final paint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    late Rect combineFirstRect;
    late Rect combineSecondRect;
    late Path combineFirstPath;
    late Path combineSecondPath;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          halfWidth = size.width / 2;
          halfHeight = size.height / 2;
          // 创建原始路径
          Path path = Path();
          Rect rect = Rect.fromCircle(center: Offset(halfWidth, halfHeight - 20), radius: 10);
          path.addOval(rect);
          Path transformedPath = Path.from(path);
          Matrix4 matrix = Matrix4.identity();
          matrix.translate(20.0, 10.0); // 平移变换
          // 绘制原始路径
          canvas.drawPath(path, paint);
          // 绘制变换后的路径
          canvas.drawPath(
            transformedPath.transform(matrix.storage),
            Paint()
              ..color = Colors.red
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
          canvas.drawParagraph(
              fastParagraph("transform() 执行\n平移变换", size.width, Colors.red), Offset(10, size.height - 40));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          Rect rect = Rect.fromCircle(center: Offset(halfWidth, halfHeight - 20), radius: 10);
          path.addRect(rect);
          canvas.drawPath(path, paint);
          canvas.drawParagraph(
              fastParagraph("${path.computeMetrics()}", size.width, Colors.red), Offset(5, size.height - 50));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          Rect rect = Rect.fromCircle(center: Offset(halfWidth, halfHeight - 20), radius: 10);
          path.addRect(rect);
          canvas.drawPath(path, paint);
          Path shiftPath = Path.from(path);
          canvas.drawPath(shiftPath.shift(const Offset(30, 10)), paint);
          canvas.drawParagraph(
              fastParagraph("shift() 平移", size.width, Colors.red), Offset(halfWidth - 20, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          combineFirstRect = Rect.fromCircle(center: Offset(halfWidth - 10, halfHeight), radius: 25);
          combineSecondRect = Rect.fromCircle(center: Offset(halfWidth + 10, halfHeight), radius: 25);
          combineFirstPath = Path();
          combineFirstPath.addOval(combineFirstRect);
          combineSecondPath = Path();
          combineSecondPath.addRect(combineSecondRect);
          canvas.drawPath(combineFirstPath, paint);
          canvas.drawPath(combineSecondPath, paint);
          canvas.drawParagraph(fastParagraph("未调combine()组合", size.width, Colors.red), Offset(10, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawPath(Path.combine(PathOperation.difference, combineFirstPath, combineSecondPath), paint);
          canvas.drawParagraph(fastParagraph("difference-差集", size.width, Colors.red), Offset(10, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawPath(Path.combine(PathOperation.intersect, combineFirstPath, combineSecondPath), paint);
          canvas.drawParagraph(fastParagraph("intersect-交集", size.width, Colors.red), Offset(10, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawPath(Path.combine(PathOperation.union, combineFirstPath, combineSecondPath), paint);
          canvas.drawParagraph(fastParagraph("union-并集", size.width, Colors.red), Offset(10, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawPath(Path.combine(PathOperation.xor, combineFirstPath, combineSecondPath), paint);
          canvas.drawParagraph(fastParagraph("xor-异或", size.width, Colors.red), Offset(10, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawPath(Path.combine(PathOperation.reverseDifference, combineFirstPath, combineSecondPath), paint);
          canvas.drawParagraph(
              fastParagraph("reverseDifference-\n反向差集", size.width, Colors.red), Offset(10, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawParagraph(fastParagraph("getBounds()获取边界", size.width, Colors.red), Offset(2, halfHeight - 50));
          canvas.drawPath(combineFirstPath, paint);
          canvas.drawParagraph(
              fastParagraph("${combineFirstPath.getBounds()}", size.width, Colors.red), Offset(5, size.height - 30));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          paint.style = PaintingStyle.fill;
          path.fillType = PathFillType.nonZero; // 默认非零环绕，重叠区域会填充颜色
          path.addRect(Rect.fromCenter(center: Offset(halfWidth + 20, halfHeight), width: 30, height: 30)); // 内矩形
          path.addRect(Rect.fromCenter(center: Offset(halfWidth, halfHeight), width: 50, height: 50)); // 外矩形
          canvas.drawPath(path, paint);
          canvas.drawParagraph(fastParagraph("${path.fillType}", size.width, Colors.red), Offset(2, halfHeight - 50));
          canvas.drawParagraph(fastParagraph("非零环绕-填充", size.width, Colors.red), Offset(20, size.height - 20));
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          Path path = Path();
          path.fillType = PathFillType.evenOdd; // 设置填充类型为奇偶环绕，重叠区域会被挖空，产生镂空效果
          path.addRect(Rect.fromCenter(center: Offset(halfWidth + 20, halfHeight), width: 30, height: 30)); // 内矩形
          path.addRect(Rect.fromCenter(center: Offset(halfWidth, halfHeight), width: 50, height: 50)); // 外矩形
          canvas.drawPath(path, paint);
          canvas.drawParagraph(fastParagraph("${path.fillType}", size.width, Colors.red), Offset(2, halfHeight - 50));
          canvas.drawParagraph(fastParagraph("奇偶环绕-挖空", size.width, Colors.red), Offset(20, size.height - 20));
        })),
      ]),
    ]);
  }
}
