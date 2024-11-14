import 'dart:math';
import 'dart:typed_data';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/color_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class PaintApiSecondPreviewPage extends StatefulWidget {
  const PaintApiSecondPreviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _PaintApiSecondPreviewPageState();
}

class _PaintApiSecondPreviewPageState extends State<PaintApiSecondPreviewPage> {
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
        appBar: AppBar(title: const Text('Paint API-着色器')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              _buildGradientLinear(),
              fastLine(),
              _buildGradientRadial(),
              fastLine(),
              _buildGradientSweep(),
              fastLine(),
              _buildImageShader()
            ]))));
  }

  // Gradient.linear 线性渐变
  Widget _buildGradientLinear() {
    // 随机生成colors数组 & 对应的colorStops
    const colorCount = 4; // 颜色数量
    final colors = List.generate(colorCount, (index) => randomColor); // 渐变色数组
    final colorStops = List.generate(colorCount, (index) => (index + 1) / colorCount); // 每个颜色所处的分率
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = 50;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('① Gradient.linear-线性渐变', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            paint.shader =
                ui.Gradient.linear(Offset(40, halfHeight), Offset(size.width - 40, halfHeight), colors, colorStops);
            canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            paint.shader = ui.Gradient.linear(
                Offset(40, halfHeight), Offset(size.width - 40, halfHeight), colors, colorStops, TileMode.repeated);
            canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            paint.shader = ui.Gradient.linear(
                Offset(40, halfHeight), Offset(size.width - 40, halfHeight), colors, colorStops, TileMode.mirror);
            canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
          }),
        ),
      ]),
      fastText('当绘制内容超过渐变范围时「tileMode」会决定超出部分的处理方式，依次为「clamp-拉伸边缘颜色(默认)」「repeated-重复」「mirror-镜像重复」',
          CPTextStyle.s14.c(Colors.black)),
      fastGridView([
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            paint.shader = ui.Gradient.linear(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), colors,
                colorStops, TileMode.clamp, Matrix4.rotationZ(pi / 2).storage);
            canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            paint.shader = ui.Gradient.linear(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), colors,
                colorStops, TileMode.clamp, Matrix4.translationValues(20, 0, 0).storage);
            canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
          }),
        ),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            paint.shader = ui.Gradient.linear(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), colors,
                colorStops, TileMode.clamp, Matrix4.skewX(pi / 6).storage);
            canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
          }),
        ),
      ]),
      fastText('Matrix4 可以对画笔填充进行变化，依次为：沿Z轴旋转90°、x轴移动20、x轴倾斜30°', CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  // Gradient.radial-径向渐变
  Widget _buildGradientRadial() {
    // 随机生成colors数组 & 对应的colorStops
    const colorCount = 5; // 颜色数量
    final colors = List.generate(colorCount, (index) => randomColor); // 渐变色数组
    final colorStops = List.generate(colorCount, (index) => (index + 1) / colorCount); // 每个颜色所处的分率
    final paint = Paint()..style = PaintingStyle.fill;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('② Gradient.radial-径向渐变', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var gradientRadius = 30.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.radial(circleCenterOffset, gradientRadius, colors, colorStops, TileMode.clamp);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var gradientRadius = 30.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.radial(circleCenterOffset, gradientRadius, colors, colorStops, TileMode.repeated);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var gradientRadius = 30.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.radial(circleCenterOffset, gradientRadius, colors, colorStops, TileMode.mirror);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        }))
      ]),
      fastText('「tileMode」依次为「clamp-拉伸边缘颜色(默认)」「repeated-重复」「mirror-镜像重复」', CPTextStyle.s14.c(Colors.black)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var gradientRadius = 30.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.radial(circleCenterOffset, gradientRadius, colors, colorStops, TileMode.clamp,
              null, Offset(halfWidth + 10, halfHeight - 10), 5);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var gradientRadius = 30.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.radial(circleCenterOffset, gradientRadius, colors, colorStops, TileMode.repeated,
              null, Offset(halfWidth + 10, halfHeight - 10), 5);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var gradientRadius = 30.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.radial(circleCenterOffset, gradientRadius, colors, colorStops, TileMode.mirror,
              null, Offset(halfWidth + 10, halfHeight - 10), 5);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
      ]),
      fastText('不同「tileMode」下修改「focal-焦点位置」和「focalRadius-焦点半径」，渐变焦点坐标为屏幕中点右上角(10,-10)，半径为5',
          CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  // Gradient.sweep-扫描渐变
  Widget _buildGradientSweep() {
    // 随机生成colors数组 & 对应的colorStops
    const colorCount = 5; // 颜色数量
    final colors = List.generate(colorCount, (index) => randomColor); // 渐变色数组
    final colorStops = List.generate(colorCount, (index) => (index + 1) / colorCount); // 每��颜色所处的分率
    final paint = Paint()..style = PaintingStyle.fill;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('③ Gradient.sweep-扫描渐变', CPTextStyle.s16.bold.c(Colors.red)),
      fastGridView([
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.sweep(circleCenterOffset, colors, colorStops, TileMode.clamp, 0, pi / 2);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
        AdjustCustomPaint(painter: DynamicPainter((canvas, size) {
          var halfWidth = size.width / 2;
          var halfHeight = size.height / 2;
          var circleRadius = 50.0;
          var circleCenterOffset = Offset(halfWidth, halfHeight);
          paint.shader = ui.Gradient.sweep(circleCenterOffset, colors, colorStops, TileMode.repeated, 0, pi / 2);
          canvas.drawCircle(circleCenterOffset, circleRadius, paint);
        })),
        AdjustCustomPaint(
          painter: DynamicPainter((canvas, size) {
            var halfWidth = size.width / 2;
            var halfHeight = size.height / 2;
            var circleRadius = 50.0;
            var circleCenterOffset = Offset(halfWidth, halfHeight);
            paint.shader = ui.Gradient.sweep(circleCenterOffset, colors, colorStops, TileMode.mirror, 0, pi / 2);
            canvas.drawCircle(circleCenterOffset, circleRadius, paint);
          }),
        )
      ]),
      fastText('不同「tileMode」的 0°-90°扫描渐变', CPTextStyle.s14.c(Colors.black)),
    ]);
  }

  // 图片着色器
  Widget _buildImageShader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fastText('④ ImageShader-图片着色器', CPTextStyle.s16.bold.c(Colors.red)),
      ValueListenableBuilder(
          valueListenable: _imgNotifier,
          builder: (context, ui.Image? image, child) {
            if (image == null) return Container();
            final paint = Paint()..style = PaintingStyle.fill;
            // 定义一个没有任何变换的 Matrix4
            final matrix4 = Float64List.fromList([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              fastGridView([
                AdjustCustomPaint(
                  painter: DynamicPainter((canvas, size) {
                    paint.shader = ImageShader(image, TileMode.clamp, TileMode.clamp, matrix4);
                    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), paint);
                  }),
                ),
                AdjustCustomPaint(
                  painter: DynamicPainter((canvas, size) {
                    paint.shader = ImageShader(
                        image, TileMode.repeated, TileMode.repeated, Matrix4.translationValues(-50, -60, 0).storage);
                    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), paint);
                  }),
                ),
                AdjustCustomPaint(
                  painter: DynamicPainter((canvas, size) {
                    paint.shader =
                        ImageShader(image, TileMode.mirror, TileMode.mirror, Matrix4.rotationZ(pi / 2).storage);
                    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), paint);
                  }),
                ),
                AdjustCustomPaint(
                  painter: DynamicPainter((canvas, size) {
                    paint.shader =
                        ImageShader(image, TileMode.mirror, TileMode.mirror, (Matrix4.identity()..scale(0.5)).storage);
                    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), paint);
                  }),
                ),
                AdjustCustomPaint(
                  painter: DynamicPainter((canvas, size) {
                    var halfWidth = size.width / 2;
                    var halfHeight = size.height / 2;
                    paint.strokeWidth = halfWidth;
                    paint.shader =
                        ImageShader(image, TileMode.repeated, TileMode.repeated, (Matrix4.identity()..scale(0.1)).storage);
                    canvas.drawLine(Offset(10, halfHeight), Offset(size.width - 10, halfHeight), paint);
                  }),
                ),
                AdjustCustomPaint(
                  painter: DynamicPainter((canvas, size) {
                    var halfWidth = size.width / 2;
                    var halfHeight = size.height / 2;
                    paint.strokeWidth = 15;
                    paint.style = PaintingStyle.stroke;
                    paint.shader =
                        ImageShader(image, TileMode.mirror, TileMode.mirror, (Matrix4.identity()..scale(0.1)).storage);
                    canvas.drawCircle(Offset(halfWidth, halfHeight), 50, paint);
                  }),
                ),
              ]),
              fastText('依次为「单位矩阵」「平移xy轴-50和-60」「沿着z轴旋转90度」「x轴缩放0.5」「画直线+tileMode-repeat」「画空心圆+tileMode-mirror」', CPTextStyle.s14.c(Colors.black)),
            ]);
          })
    ]);
  }

  // 加载图片数据解码为图片对象
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}
