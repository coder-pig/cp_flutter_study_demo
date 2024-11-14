import 'dart:ui' as ui;
import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorFilterDemo extends StatefulWidget {
  const ColorFilterDemo({super.key});

  @override
  State<StatefulWidget> createState() => _ColorFilterDemoState();
}

class _ColorFilterDemoState extends State<ColorFilterDemo> {
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
        appBar: AppBar(title: const Text('ColorFilter-滤色器')),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
                valueListenable: _imgNotifier,
                builder: (context, ui.Image? image, child) {
                  return Column(
                    children: [
                      _buildPaintColorFilter(image),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
          ),
        ));
  }

  Widget _buildPaintColorFilter(ui.Image? image) {
    if (image == null) return Container();
    Paint paint = Paint();
    late final double width;
    late final double height;
    final Rect srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    late final Rect dstRect;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('① 根据混合模式创建滤色器', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView(
        [
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              width = size.width;
              height = size.height;
              dstRect = Rect.fromCircle(center: Offset(width / 2, height / 2), radius: width / 2 - 10);
              paint.colorFilter = const ColorFilter.mode(Colors.purpleAccent, BlendMode.srcOver);
              canvas.drawImageRect(image, srcRect, dstRect, paint);
              canvas.drawParagraph(fastParagraph("srcOver", width), Offset(30, height - 40));
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              paint.colorFilter = const ColorFilter.mode(Colors.purpleAccent, BlendMode.dst);
              canvas.drawImageRect(image, srcRect, dstRect, paint);
              canvas.drawParagraph(fastParagraph("dstOver", width), Offset(30, height - 40));
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              paint.colorFilter = const ColorFilter.mode(Colors.purpleAccent, BlendMode.lighten);
              canvas.drawImageRect(image, srcRect, dstRect, paint);
              canvas.drawParagraph(fastParagraph("lighten", width), Offset(30, height - 40));
            }),
          ),
        ],
      ),
      fastText('② 根据颜色变换矩阵创建滤色器', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.colorFilter =
                const ColorFilter.matrix(<double>[-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("颜色反转/负片", width, Colors.white), Offset(20, height - 50));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.colorFilter = const ColorFilter.matrix(
                <double>[0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0, 0, 0, 1, 0]);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("灰度", width, Colors.red), Offset(45, height - 40));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.colorFilter =
                const ColorFilter.matrix(<double>[1, 0, 0, 0, 50, 0, 1, 0, 0, 50, 0, 0, 1, 0, 50, 0, 0, 0, 1, 0]);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("增加亮度", width, Colors.red), Offset(30, height - 40));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.colorFilter = const ColorFilter.matrix(
                <double>[1.5, 0, 0, 0, -128, 0, 1.5, 0, 0, -128, 0, 0, 1.5, 0, -128, 0, 0, 0, 1, 0]);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("增加对比度", width, Colors.red), Offset(30, height - 40));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.colorFilter = const ColorFilter.matrix(<double>[
              0.213,
              0.715,
              0.072,
              0,
              0,
              0.213,
              0.715,
              0.072,
              0,
              0,
              0.213,
              0.715,
              0.072,
              0,
              0,
              0,
              0,
              0,
              1,
              0
            ]);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("饱和度变换", width, Colors.red), Offset(30, height - 40));
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            paint.colorFilter = const ColorFilter.matrix(<double>[
              0.393,
              0.769,
              0.189,
              0,
              0,
              0.349,
              0.686,
              0.168,
              0,
              0,
              0.272,
              0.534,
              0.131,
              0,
              0,
              0,
              0,
              0,
              1,
              0
            ]);
            canvas.drawImageRect(image, srcRect, dstRect, paint);
            canvas.drawParagraph(fastParagraph("复古/棕褐色效果", width, Colors.red), Offset(20, height - 40));
          }),
        ),
      ]),
      fastText('③ ColorFiltered 应用混合模式 → 滤镜效果', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.red.withOpacity(0.5),
            BlendMode.colorBurn,
          ),
          child: Image.asset('assets/images/ic_lm.png'),
        )
      ]),
      fastText('④ Container 应用混合模式 → 背景图与颜色混合', CPTextStyle.s16.bold.c(Colors.red)),
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/ic_lm.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(0.6),
              BlendMode.overlay,
            ),
          ),
        ),
      ),
      fastText('⑤ ShaderMask 应用混合模式 → 复杂遮罩', CPTextStyle.s16.bold.c(Colors.red)),
      ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.red, Colors.yellow],
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        blendMode: BlendMode.multiply,
        child: SizedBox(width: 100, height: 100, child: Image.asset('assets/images/ic_lm.png')),
      )
    ]);
  }

  // 加载图片数据解码为图片对象
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}
