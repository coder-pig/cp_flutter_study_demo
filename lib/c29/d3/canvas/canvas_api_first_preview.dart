import 'dart:math';
import 'dart:ui';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class CanvasApiFirstPreview extends StatefulWidget {
  const CanvasApiFirstPreview({super.key});

  @override
  State<StatefulWidget> createState() => _CanvasApiFirstPreviewState();
}

class _CanvasApiFirstPreviewState extends State<CanvasApiFirstPreview> {
  final _imgNotifier = ValueNotifier<ui.Image?>(null);
  final _bubbleImgNotifier = ValueNotifier<ui.Image?>(null);

  @override
  void initState() {
    super.initState();
    loadImageFromAssets("assets/images/ic_lm.png")?.then((value) {
      _imgNotifier.value = value;
    });
    loadImageFromAssets("assets/images/talk_bubble.png")?.then((value) {
      _bubbleImgNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Canvas API-图形绘制')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(child: _buildContent())));
  }

  Widget _buildContent() {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;
    late double halfWidth;
    late double halfHeight;
    return fastGridView([
      // 划线
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        halfWidth = size.width / 2;
        halfHeight = size.height / 2;
        canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
        canvas.drawLine(Offset(halfWidth, 10), Offset(halfWidth, size.height - 40), paint);
        canvas.drawParagraph(fastParagraph("drawLine()-画线", size.width, Colors.red), Offset(10, size.height - 30));
      })),
      // 画矩形
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        canvas.drawRect(Rect.fromLTWH(30, 20, size.width - 60, size.height - 60), paint);
        canvas.drawParagraph(fastParagraph("drawRect()-画矩形", size.width, Colors.red), Offset(10, size.height - 40));
      })),
      // 画圆角矩形
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(30, 20, size.width - 60, size.height - 60), const Radius.circular(20)),
            paint);
        canvas.drawParagraph(fastParagraph("drawRRect()-画圆角矩形", size.width, Colors.red), Offset(5, size.height - 40));
      })),
      // 画嵌套圆角矩形
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        canvas.drawDRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(20, 20, size.width - 60, size.height - 60), const Radius.circular(20)),
            RRect.fromRectAndRadius(
                Rect.fromLTWH(30, 30, size.width - 80, size.height - 80), const Radius.circular(20)),
            paint);
        canvas.drawParagraph(fastParagraph("drawDRRect()-画嵌套圆角矩形", size.width - 10, Colors.red), Offset(5, size.height - 40));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        canvas.drawOval(Rect.fromLTWH(20, 20, size.width - 40, size.height - 60), paint);
        canvas.drawParagraph(fastParagraph("drawOval()-画椭圆", size.width, Colors.red), Offset(10, size.height - 40));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        canvas.drawCircle(Offset(halfWidth, halfHeight - 20), 30, paint);
        canvas.drawParagraph(fastParagraph("drawCircle()-画圆", size.width, Colors.red), Offset(10, size.height - 40));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        final rect = Rect.fromLTWH(20, 10, size.width - 50, size.height - 50);
        canvas.drawArc(rect, 0, - pi / 2, true, paint);
        canvas.drawArc(rect, 0, - pi / 2, true, paint);
        canvas.drawParagraph(fastParagraph("drawArc()-画弧", size.width, Colors.red), Offset(10, size.height - 40));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        var width25 = size.width / 4;
        paint.style = PaintingStyle.stroke;
        final path = Path();
        path.moveTo(halfWidth, 10);
        path.lineTo(halfWidth - width25 + 10, halfHeight + width25 - 10);
        path.lineTo(halfWidth + width25, halfHeight - width25 + 10);
        path.lineTo(halfWidth - width25, halfHeight - width25 + 10);
        path.lineTo(halfWidth + width25 - 10, halfHeight + width25 - 10);
        path.close();
        canvas.drawPath(path, paint);
        canvas.drawParagraph(fastParagraph("drawPath()-画路径", size.width - 10, Colors.red), Offset(10, size.height - 40));
      })),
      ValueListenableBuilder(valueListenable: _imgNotifier, builder: (context, ui.Image? image, child) {
        if (image == null) return const SizedBox();
        return AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          canvas.drawImage(image, const Offset(10, 10), paint);
          canvas.drawParagraph(fastParagraph("drawImage()-画图\n😳超出绘制区域", size.width, Colors.red), Offset(10, size.height - 40));
        }));
      }),
      ValueListenableBuilder(valueListenable: _imgNotifier, builder: (context, ui.Image? image, child) {
        if (image == null) return const SizedBox();
        return AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          // 图像的原始大小
          final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
          // 图像的目标大小
          final dstRect = Rect.fromLTWH(10, 10, size.width - 50, size.height - 50);
          canvas.drawImageRect(image, srcRect, dstRect, paint);
          canvas.drawParagraph(fastParagraph("drawImageRect()\n-缩放绘制图像", size.width, Colors.red), Offset(10, size.height - 40));
        }));
      }),
      ValueListenableBuilder(valueListenable: _bubbleImgNotifier, builder: (context, ui.Image? image, child) {
        if (image == null) return const SizedBox();
        return AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          final center = Rect.fromCenter(
              center: Offset(image.width / 2, image.height / 2),
              width: image.width.toDouble() - 100,
              height: 6
          );
          final dstRect = Rect.fromLTWH(10, 10, size.width - 20, 60);
          canvas.drawImageNine(image, center, dstRect, paint);
          canvas.drawParagraph(fastParagraph("drawImageNine()\n-九宫格绘制图像", size.width, Colors.red), Offset(10, size.height - 40));
        }));
      }),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        final recorder = PictureRecorder();
        final pictureCanvas = Canvas(recorder, Rect.fromPoints(const Offset(0, 0), const Offset(100, 100)));
        pictureCanvas.drawCircle(const Offset(50, 50), 20, paint);
        final picture = recorder.endRecording();
        canvas.drawPicture(picture);
        canvas.drawParagraph(fastParagraph("drawPicture()\n-绘制Picture", size.width, Colors.red), Offset(10, size.height - 40));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        final paragraph = fastParagraph("drawParagraph()\n-绘制文本", size.width, Colors.red, TextAlign.center);
        canvas.drawParagraph(paragraph, Offset(0, halfHeight - 20));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        final points = <Offset>[
          const Offset(10, 10),
          const Offset(20, 20),
          const Offset(30, 30),
          const Offset(40, 40),
          const Offset(50, 50),
          const Offset(60, 60),
          const Offset(70, 70),
          const Offset(80, 80),
          const Offset(90, 90),
          const Offset(100, 100),
        ];
        canvas.drawPoints(PointMode.points, points, paint);
        canvas.drawParagraph(fastParagraph("drawPoints()\n-绘制点", size.width, Colors.red), Offset(10, size.height - 40));
      })),
      // drawVertices()
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        final vertices = Vertices(VertexMode.triangleFan, [
          // 第一个顶点在画布中心
          Offset(halfWidth, halfHeight),
          // 生成刘哥顶点，围绕中心点形成一个六边形
          for (var i = 0; i <= 6; i++) Offset(halfWidth + 50 * cos(i * pi / 3), halfHeight + 50 * sin(i * pi / 3)),
        ], colors: [
          // 中心点颜色为红色
          const Color(0xFFFF0000),
          // 六边形顶点的颜色为绿色
          for (var i = 0; i <= 6; i++) const Color(0xFF00FF00),
        ]);
        // 绘制顶点，绘制过程中Flutter会自动在顶点键进行颜色插值 (渐变) 结果会呈现中心点
        // 红色到六边形顶点的绿色的过渡效果。
        canvas.drawVertices(vertices, BlendMode.color, paint);
        canvas.drawParagraph(fastParagraph("drawVertices()\n-绘制顶点", size.width, Colors.red), Offset(10, size.height - 40));
      })),
    ]);
  }

  // 加载图片数据解码为图片对象
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}
