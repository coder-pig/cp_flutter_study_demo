import 'dart:math';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/utils/color_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';

class PaintApiFirstPreviewPage extends StatefulWidget {
  const PaintApiFirstPreviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _PaintApiFirstPreviewPageState();
}

class _PaintApiFirstPreviewPageState extends State<PaintApiFirstPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Paint API-基础属性')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                _buildColorAndAntiAlias(),
                fastLine(),
                _buildStyleAndStrokeWidth(),
                fastLine(),
                _buildStrokeCap(),
                fastLine(),
                _buildStrokeJoin()
              ]),
            )));
  }

  // color-颜色 & isAntiAlias-是否抗锯齿
  Widget _buildColorAndAntiAlias() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fastText('① color-颜色 & isAntiAlias-抗锯齿', CPTextStyle.s16.bold.c(Colors.red)),
          fastGridView([
            AdjustCustomPaint(
              painter: DynamicPainter((canvas, size) {
                final paint = Paint()
                  ..color = randomColor
                  ..isAntiAlias = false;
                canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);
              }),
            ),
            AdjustCustomPaint(
              painter: DynamicPainter((canvas, size) {
                final paint = Paint()
                  ..color = Colors.blue
                  ..isAntiAlias = true;
                canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);
              }),
            ),
          ]),
          fastText('左侧圆未设置抗锯齿，边缘有肉眼可见的粗糙感', CPTextStyle.s14.c(Colors.black)),
        ],
      );

  // style-画笔类型 & strokeWidth-线宽
  Widget _buildStyleAndStrokeWidth() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fastText('② style-画笔类型 & strokeWidth-线宽', CPTextStyle.s16.bold.c(Colors.red)),
          fastGridView([
            AdjustCustomPaint(
              painter: DynamicPainter((canvas, size) {
                var halfWidth = size.width / 2;
                var halfHeight = size.height / 2;
                final paint = Paint()
                  ..color = randomColor
                  ..isAntiAlias = true
                  ..style = PaintingStyle.fill;
                canvas.drawCircle(Offset(halfWidth, halfHeight), 50, paint);
                canvas.drawLine(
                    Offset(0, halfHeight - 50), Offset(size.width, halfHeight - 50), Paint()..color = Colors.red);
              }),
            ),
            AdjustCustomPaint(
              painter: DynamicPainter((canvas, size) {
                var halfWidth = size.width / 2;
                var halfHeight = size.height / 2;
                final paint = Paint()
                  ..color = randomColor
                  ..isAntiAlias = true
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 10;
                canvas.drawCircle(Offset(halfWidth, halfHeight), 50, paint);
                canvas.drawLine(
                    Offset(0, halfHeight - 50), Offset(size.width, halfHeight - 50), Paint()..color = Colors.red);
              }),
            ),
          ]),
          fastText(
              '左侧「PaintingStyle.fill-填充」绘制实心圆，右侧「PaintingStyle.stroke-线条」绘制空心圆。画笔是「stroke」类型「strokeWidth」才会起作用，而且要注意会有一半的宽度在外侧',
              CPTextStyle.s14.c(Colors.black)),
        ],
      );

  // strokeCap-线帽类型
  Widget _buildStrokeCap() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        fastText('③ strokeCap-线帽类型', CPTextStyle.s16.bold.c(Colors.red)),
        fastGridView([
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeCap = StrokeCap.butt
                ..strokeWidth = 10;
              canvas.drawLine(Offset(halfWidth, halfHeight - 20), Offset(halfWidth, halfHeight + 20), paint);
              canvas.drawLine(
                  Offset(0, halfHeight - 20), Offset(size.width, halfHeight - 20), Paint()..color = Colors.red);
              canvas.drawLine(
                  Offset(0, halfHeight + 20), Offset(size.width, halfHeight + 20), Paint()..color = Colors.red);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeCap = StrokeCap.round
                ..strokeWidth = 10;
              canvas.drawLine(Offset(halfWidth, halfHeight - 20), Offset(halfWidth, halfHeight + 20), paint);
              canvas.drawLine(
                  Offset(0, halfHeight - 20), Offset(size.width, halfHeight - 20), Paint()..color = Colors.red);
              canvas.drawLine(
                  Offset(0, halfHeight + 20), Offset(size.width, halfHeight + 20), Paint()..color = Colors.red);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeCap = StrokeCap.square
                ..strokeWidth = 10;
              canvas.drawLine(Offset(halfWidth, halfHeight - 20), Offset(halfWidth, halfHeight + 20), paint);
              canvas.drawLine(
                  Offset(0, halfHeight - 20), Offset(size.width, halfHeight - 20), Paint()..color = Colors.red);
              canvas.drawLine(
                  Offset(0, halfHeight + 20), Offset(size.width, halfHeight + 20), Paint()..color = Colors.red);
            }),
          ),
        ]),
        fastText('依次为「StrokeCap.butt-不出头」「StrokeCap.round-圆头」「StrokeCap.square-方头」', CPTextStyle.s14.c(Colors.black)),
      ]);

  // strokeJoin-线接类型 & strokeMiterLimit-斜接限制
  Widget _buildStrokeJoin() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        fastText('④ strokeJoin-线接类型 & strokeMiterLimit-斜接限制', CPTextStyle.s16.bold.c(Colors.red)),
        fastGridView([
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.bevel;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.round;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.miter;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
        ]),
        fastText(
            '前三个依次为「StrokeJoin.bevel-斜角」「StrokeJoin.miter-锐角」「StrokeJoin.round-圆角」只适用于Path的线段绘制，'
            '不适用于Canvas.drawPoints绘制的线。',
            CPTextStyle.s14.c(Colors.black)),
        fastGridView([
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.miter;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeMiterLimit = 1
                ..strokeJoin = StrokeJoin.miter;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeMiterLimit = 2
                ..strokeJoin = StrokeJoin.miter;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
          AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              var halfWidth = size.width / 2;
              var halfHeight = size.height / 2;
              const double sideLength = 50;
              final double height = sideLength * sqrt(3) / 2;
              final paint = Paint()
                ..color = randomColor
                ..isAntiAlias = true
                ..strokeWidth = 10
                ..style = PaintingStyle.stroke
                ..strokeMiterLimit = 3
                ..strokeJoin = StrokeJoin.miter;
              // 绘制一个边长为50的居中等边三角形
              Path path = Path()
                ..moveTo(halfHeight, halfHeight - height / 2)
                ..lineTo(halfHeight - sideLength / 2, halfHeight + height / 2)
                ..lineTo(halfHeight + sideLength / 2, halfHeight + height / 2)
                ..close();
              canvas.drawPath(path, paint);
            }),
          ),
        ]),
        fastText(
            '依次为「不设置strokeMiterLimit-默认4」「strokeMiterLimit=1」，「strokeMiterLimit=2」'
            '用于控制斜接长度，值越大，尖角越尖，为2意味着斜接长度超过两倍线宽，斜接将被剪裁，值该属性只适用于「StrokeJoin.miter」',
            CPTextStyle.s14.c(Colors.black))
      ]);

  // 着色器
}
