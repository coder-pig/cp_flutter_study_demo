import 'dart:ui' as ui;

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtherFilterDemo extends StatefulWidget {
  const OtherFilterDemo({super.key});

  @override
  State<StatefulWidget> createState() => _OtherFilterDemoState();
}

class _OtherFilterDemoState extends State<OtherFilterDemo> {
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
        appBar: AppBar(title: const Text('Filter-其它滤镜')),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
                valueListenable: _imgNotifier,
                builder: (context, ui.Image? image, child) {
                  return Column(
                    children: [
                      _buildMaskFilter(image),
                      _buildImageFilter(image),
                      _buildFilterQuality(image),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
          ),
        ));
  }

  Widget _buildMaskFilter(ui.Image? image) {
    if (image == null) return Container();
    Paint paint = Paint();
    late final double halfWidth;
    late final double halfHeight;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('① MaskFilter-模糊滤镜', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            halfWidth = size.width / 2;
            halfHeight = size.height / 2;
            paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
            canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50.0, paint);
            canvas.drawParagraph(fastParagraph("normal-10\n内外均匀模糊", size.width, Colors.red, TextAlign.center),
                Offset(0, halfHeight - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 10);
            canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50.0, paint);
            canvas.drawParagraph(fastParagraph("solid-10\n内糊边界清晰", size.width, Colors.red, TextAlign.center),
                Offset(0, halfHeight - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);
            canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50.0, paint);
            canvas.drawParagraph(
                fastParagraph("outer-5\n外糊内清晰", size.width, Colors.red, TextAlign.center), Offset(0, halfHeight - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.maskFilter = const MaskFilter.blur(BlurStyle.inner, 5);
            canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50.0, paint);
            canvas.drawParagraph(
                fastParagraph("inner-5\n内糊外透明", size.width, Colors.red, TextAlign.center), Offset(0, halfHeight - 20));
          }),
        ),
      ]),
    ]);
  }

  Widget _buildImageFilter(ui.Image? image) {
    if (image == null) return Container();
    Paint paint = Paint();
    late final double halfWidth;
    late final double halfHeight;
    final Rect srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    late final Rect dstRect;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('② ImageFilter-图像滤镜', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            halfWidth = size.width / 2;
            halfHeight = size.height / 2;
            dstRect = Rect.fromCircle(center: Offset(halfWidth, halfHeight), radius: halfWidth - 20);
            paint.imageFilter = ui.ImageFilter.blur(sigmaX: 1, sigmaY: 0);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("x-1,y-0,clamp", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.imageFilter = ui.ImageFilter.blur(sigmaX: 0, sigmaY: 2);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("x-0,y-2,clamp", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.imageFilter = ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("x-3,y-3,clamp", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.imageFilter = ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.repeated);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("x-3,y-3,repeat", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.imageFilter = ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.mirror);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("x-3,y-3,mirror", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.imageFilter = ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.decal);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("x-3,y-3,imageFilter", size.width, Colors.red, TextAlign.center),
                Offset(0, size.height - 20));
          }),
        ),
      ]),
    ]);
  }

  Widget _buildFilterQuality(ui.Image? image) {
    if (image == null) return Container();
    Paint paint = Paint();
    late final double halfWidth;
    late final double halfHeight;
    final Rect srcRect = Rect.fromLTWH(image.width / 2, image.height / 2, 50, 50);
    late final Rect dstRect;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('③ FilterQuality-滤镜质量', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            halfWidth = size.width / 2;
            halfHeight = size.height / 2;
            dstRect = Rect.fromCircle(center: Offset(halfWidth, halfHeight), radius: halfWidth);
            paint.filterQuality = FilterQuality.none;
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("none", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.filterQuality = FilterQuality.low;
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("low", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.filterQuality = FilterQuality.medium;
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("medium", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.filterQuality = FilterQuality.high;
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(
                fastParagraph("high", size.width, Colors.red, TextAlign.center), Offset(0, size.height - 20));
          }),
        ),
      ])
    ]);
  }

  // 加载图片数据解码为图片对象
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}
