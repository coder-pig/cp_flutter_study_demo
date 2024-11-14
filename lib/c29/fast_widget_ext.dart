
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// 快速生成标题文本
Widget fastText(String title, TextStyle textStyle) =>
    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(title, style: textStyle));

// 快速生成网格布局
Widget fastGridView(List<Widget> children, [int crossAxisCount = 3]) => GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true, // 是否根据子组件的总长度来设置自己的长度
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, childAspectRatio: 1.0, mainAxisSpacing: 10, crossAxisSpacing: 10),
      children: children,
    );

Widget fastLine() => const Divider(height: 1, color: Colors.grey);

BoxDecoration fastBorder() =>
    const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: Colors.grey, width: 0.5)));

// 绘制回调
typedef PaintCallback = void Function(Canvas canvas, Size size);

// 动态绘制类
class DynamicPainter extends CustomPainter {
  final PaintCallback paintCallback;

  DynamicPainter(this.paintCallback);

  @override
  void paint(Canvas canvas, Size size) => paintCallback(canvas, size);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 宽高自适应的 CustomPaint
class AdjustCustomPaint extends StatelessWidget {
  final CustomPainter painter;

  const AdjustCustomPaint({super.key, required this.painter});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.fromBorderSide(BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: CustomPaint(painter: painter)),
      );
}

// 快速构建文字的paragraph
Paragraph fastParagraph(String text, double width, [Color? textColor, TextAlign? textAlign]) {
  final paragraphStyle = ParagraphStyle(textAlign: textAlign);
  final paragraphBuilder = ParagraphBuilder(paragraphStyle)
    ..pushStyle(ui.TextStyle(color: textColor ?? Colors.black, fontSize: 12, fontWeight: FontWeight.bold))
    ..addText(text);
  return paragraphBuilder.build()..layout(ParagraphConstraints(width: width));
}