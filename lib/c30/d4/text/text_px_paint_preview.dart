import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('文字像素化')),
      body: const TexPxPaintPreview(),
    ),
  );
}

class TexPxPaintPreview extends StatefulWidget {
  const TexPxPaintPreview({super.key});

  @override
  State<StatefulWidget> createState() => _TexPxPaintPreviewState();
}

class _TexPxPaintPreviewState extends State<TexPxPaintPreview> with SingleTickerProviderStateMixin {
  Uint8List? pixels;
  int textWidth = 0;
  int textHeight = 0;

  @override
  void initState() {
    super.initState();
    _preparePixelData();
  }

  @override
  Widget build(BuildContext context) {
    return pixels == null
        ? const CircularProgressIndicator()
        : CustomPaint(
      size: Size(textWidth.toDouble(), textHeight.toDouble()),
      painter: PixelTextPainter(
        pixels: pixels!,
        width: textWidth,
        height: textHeight,
        color: Colors.green,
      ),
    );
  }

  // 生成文字像素数据
  Future<void> _preparePixelData() async {
    final textPainter = TextPainter(
      text: const TextSpan(text: "杰哥不要", style: TextStyle(color: Colors.black, fontSize: 20)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    // 获取文本的宽高(向上取整)
    textWidth = textPainter.width.ceil();
    textHeight = textPainter.height.ceil();

    // 创建 PictureRecorder(记录绘制命令的对象，最终生成Picture对象) 和 临时Canvas(记录绘制操作)
    final recorder = ui.PictureRecorder();
    final tempCanvas = Canvas(recorder);
    // 绘制文本
    textPainter.paint(tempCanvas, Offset.zero);
    // 将绘制的内容生成图片
    final picture = recorder.endRecording();
    // 将图片转换为Image对象
    final img = await picture.toImage(textWidth, textHeight);
    // 将Image对象转换为字节数据
    final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
    // 将字节数据转换为Uint8List
    if (byteData != null) {
      setState(() {
        pixels = byteData.buffer.asUint8List();
      });
    }
  }
}

class PixelTextPainter extends CustomPainter {
  final Uint8List pixels;
  final int width;
  final int height;
  final Color color;

  PixelTextPainter({
    required this.pixels,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // 遍历像素数据，绘制像素点
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // 计算当前像素点在pixels数组中的起始索引，每个像素点占4个字节 (RGBA)，
        // 前半部分计算出像素点在二维图像中的位置，后面*4得出一维数组中的起始索引。
        int index = (y * width + x) * 4;
        // index + 3 是像素点的透明度，< pixels.length 防止数组越界，> 128 是为了过滤掉透明度过低的像素点
        if (index + 3 < pixels.length && pixels[index + 3] > 128) {
          // 绘制像素点(半径为2，所以一个像素点的间隔是4)
          canvas.drawCircle(Offset(x.toDouble() * 4, y.toDouble() * 4), 2.0, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PixelTextPainter oldDelegate) {
    return oldDelegate.pixels != pixels;
  }
}