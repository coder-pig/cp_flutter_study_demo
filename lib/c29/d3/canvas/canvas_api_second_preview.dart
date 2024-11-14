import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class CanvasApiSecondPreview extends StatefulWidget {
  const CanvasApiSecondPreview({super.key});

  @override
  State<StatefulWidget> createState() => _CanvasApiSecondPreviewState();
}

class _CanvasApiSecondPreviewState extends State<CanvasApiSecondPreview> {
  final _imgNotifier = ValueNotifier<ui.Image?>(null);

  @override
  void initState() {
    super.initState();
    loadImageFromAssets("assets/images/ic_lm.png")?.then((value) {
      _imgNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Canvas API-变换')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildExchange(), const SizedBox(height: 50), buildClip()]))));
  }

  Widget _buildExchange() {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;
    late double halfWidth;
    late double halfHeight;
    return fastGridView([
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        halfWidth = size.width / 2;
        halfHeight = size.height / 2;
        canvas.translate(10, 10);
        // 画布原点平移到了新的位置(10,10)，后续绘制都会基于新的原点进行
        canvas.drawRect(const Rect.fromLTWH(0, 0, 80, 80), paint);
        canvas.drawParagraph(fastParagraph("translate()-平移原点", size.width, Colors.red), Offset(0, size.height - 30));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        // 缩放后的宽高都变小了
        canvas.scale(0.5, 0.5);
        canvas.drawRect(const Rect.fromLTWH(0, 0, 80, 80), paint);
        canvas.drawParagraph(fastParagraph("scale()-画布缩放", size.width, Colors.red), Offset(0, size.height - 30));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        // 旋转后的矩形
        canvas.rotate(pi / 6);
        canvas.drawRect(Rect.fromLTWH(halfWidth - 30, halfHeight - 30, 60, 60), paint);
        canvas.drawParagraph(fastParagraph("rotate()-画布旋转", size.width, Colors.red), Offset(0, size.height - 30));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        canvas.skew(0.1, 0.5);
        canvas.drawRect(const Rect.fromLTWH(0, 0, 60, 60), paint);
        canvas.drawParagraph(fastParagraph("skew()-画布倾斜", size.width, Colors.red), Offset(0, size.height - 30));
      })),
      AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
        // 画面的X轴和Y轴平移50个单位
        final matrix4 = Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 50, 50, 0, 1]);
        canvas.transform(matrix4);
        canvas.drawRect(const Rect.fromLTWH(0, 0, 60, 60), paint);
        canvas.drawParagraph(fastParagraph("transform()-矩阵变换", size.width, Colors.red), Offset(0, size.height - 30));
      })),
    ]);
  }

  Widget buildClip() {
    return fastGridView([
      ValueListenableBuilder(
          valueListenable: _imgNotifier,
          builder: (context, ui.Image? image, child) {
            if (image == null) return Container();
            return AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
              // 绘制原始图片
              var centerPointX = (size.width - image.width) / 2;
              var centerPointY = (size.height - image.height) / 2;
              canvas.drawImage(image, Offset(centerPointX, centerPointY), Paint());
              // 剪裁矩形区域
              canvas.save();
              Rect rect =
                  Rect.fromLTWH(image.width * 0.25, image.height * 0.25, image.width * 0.25, image.height * 0.25);
              // 平移画布，避免裁剪到原始图片
              canvas.translate(image.width - size.width + 80, 0);
              // 裁剪
              canvas.clipRect(rect);
              // 绘制被剪裁的图片
              canvas.drawImage(image, const Offset(0, 0), Paint());
              // 画布恢复
              canvas.restore();
              // 裁剪圆角矩形区域
              canvas.save();
              final RRect rRect = RRect.fromRectAndRadius(
                  Rect.fromLTWH(image.width * 0.25, image.height * 0.5, image.width * 0.25, image.height * 0.25),
                  const Radius.circular(20));
              // 平移画布，避免裁剪到原始图片
              canvas.translate(image.width - size.width + 80, size.height - image.height);
              // 裁剪
              canvas.clipRRect(rRect);
              // 绘制被剪裁的图片
              canvas.drawImage(image, const Offset(0, 0), Paint());
              // 画布恢复
              canvas.restore();
              // 剪裁自定义路径
              canvas.save();
              Path path = Path()
                ..addOval(Rect.fromCircle(
                  center: Offset(image.width / 4, image.height / 4),
                  radius: image.width * 0.125,
                ));
              canvas.translate(image.width + 10.0, size.height - image.height);
              canvas.clipPath(path);
              // 绘制被剪裁的图片
              canvas.drawImage(image, const Offset(0, 0), Paint());
              canvas.restore();
            }));
          }),
    ], 1);
  }

  // 加载图片数据解码为图片对象
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}
