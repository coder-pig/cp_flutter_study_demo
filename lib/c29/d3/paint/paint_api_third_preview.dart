import 'dart:collection';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaintApiThirdPreviewPage extends StatefulWidget {
  const PaintApiThirdPreviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _PaintApiThirdPreviewPageState();
}

class _PaintApiThirdPreviewPageState extends State<PaintApiThirdPreviewPage> {
  final List<Map<String, LinkedHashMap<BlendMode, String>>> blendModes = [
    {
      '正常模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.srcOver: '默认模式，将源图像绘制在目标图像之上。',
        BlendMode.dstOver: '将目标图像绘制在源图像之上。',
        BlendMode.srcIn: '显示源图像与目标图像重叠部分的源图像。',
        BlendMode.dstIn: '显示目标图像与源图像重叠部分的目标图像。',
        BlendMode.srcOut: '显示源图像中不与目标图像重叠的部分。',
        BlendMode.dstOut: '显示目标图像中不与源图像重叠的部分。',
        BlendMode.srcATop: '在目标图像上显示源图像，保留目标图像的非重叠部分。',
        BlendMode.dstATop: '在源图像上显示目标图像，保留源图像的非重叠部分。',
        BlendMode.xor: '显示源图像和目标图像中不重叠的部分，创建排除效果。',
      }),
    },
    {
      '变暗模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.darken: '选择源和目标图像中较暗的像素值，整体使图像变暗。',
        BlendMode.colorBurn: '加深底色以反映源颜色，增加对比度和深度。',
      }),
    },
    {
      '变亮模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.lighten: '选择源和目标图像中较亮的像素值，整体使图像变亮。',
        BlendMode.colorDodge: '提亮底色以反映源颜色，增强亮部细节。',
      }),
    },
    {
      '对比度模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.overlay: '结合 multiply 和 screen 模式，增强对比度。',
        BlendMode.hardLight: '根据源图像的颜色值决定是 multiply 还是 screen，创造强烈对比效果。',
        BlendMode.softLight: '类似于 overlay，但效果更柔和，适用于轻微调整对比度。',
      }),
    },
    {
      '反转模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.difference: '计算源和目标图像像素的绝对差值，创建反转效果。',
        BlendMode.exclusion: '类似于 difference，但对比度较低，产生柔和的反转效果。',
      }),
    },
    {
      '合成模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.multiply: '将源和目标图像的颜色值相乘，结果通常更暗，适用于阴影效果。',
        BlendMode.screen: '反转、相乘并反转结果，通常比 multiply 更亮，适用于高光效果。',
      }),
    },
    {
      '颜色模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.hue: '保留目标图像的亮度和饱和度，使用源图像的色相。',
        BlendMode.saturation: '保留目标图像的色相和亮度，使用源图像的饱和度。',
        BlendMode.color: '保留目标图像的亮度，使用源图像的色相和饱和度。',
        BlendMode.luminosity: '保留目标图像的色相和饱和度，使用源图像的亮度。',
      }),
    },
    {
      '其它模式': LinkedHashMap<BlendMode, String>.from({
        BlendMode.clear: '清除所有像素，使区域透明。',
        BlendMode.src: '仅显示源图像，忽略目标图像。',
        BlendMode.dst: '仅显示目标图像，忽略源图像。',
        BlendMode.plus: '将源和目标图像的颜色值相加，可能导致颜色溢出。',
        BlendMode.modulate: '将源图像与目标图像的颜色值相乘并归一化，适用于颜色调制效果。',
      }),
    },
  ];

  final _imgNotifier = ValueNotifier<ui.Image?>(null);
  late double _screenWidth;

  @override
  void initState() {
    super.initState();
    loadImageFromAssets("assets/images/ic_lm.png")?.then((value) {
      _imgNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text('Paint API-混合模式（29种）')),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ValueListenableBuilder(
            valueListenable: _imgNotifier,
            builder: (context, ui.Image? image, child) {
              if (image == null) {
                return Container();
              }
              return SingleChildScrollView(
                child: Column(children: [
                  ...blendModes.map((e) => _buildBlendModeType(blendModes.indexOf(e))).toList(),
                  const SizedBox(height: 10)
                ]),
              );
            },
          ),
        ));
  }

  Widget _buildBlendModeType(int index) {
    final blendModeMap = blendModes[index];
    return Column(
      children: [
        fastText(blendModeMap.keys.first, const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...blendModeMap.values.first.entries.map((entry) => _buildBlendModeItem(entry.key, entry.value)).toList(),
      ],
    );
  }

  Widget _buildBlendModeItem(BlendMode blendMode, String desc) {
    double paintWidth = _screenWidth / 3 - 30;
    return Row(
      children: [
        Container(
          width: paintWidth,
          height: paintWidth,
          decoration: fastBorder(),
          child: AdjustCustomPaint(
            painter: DynamicPainter((canvas, size) {
              final dstPaint = Paint()
                ..isAntiAlias = true
                ..shader = ImageShader(_imgNotifier.value!, TileMode.repeated, TileMode.repeated,
                    (Matrix4.identity()..scale(0.4)).storage);
              final srcPaint = Paint()
                ..isAntiAlias = true
                ..color = Colors.pinkAccent
                ..blendMode = blendMode;
              var halfWidth = size.width / 2;
              canvas.drawCircle(Offset(halfWidth - 10, halfWidth), 30, dstPaint);
              canvas.drawCircle(Offset(halfWidth + 10, halfWidth), 30, srcPaint);
            }),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Container(
              height: paintWidth,
              padding: const EdgeInsets.all(10),
              decoration: fastBorder(),
              child: Text("$blendMode：$desc".substring(10), style: const TextStyle(fontSize: 16)),
            ))
      ],
    );
  }

  // 加载图片数据解码为图片对象
  Future<ui.Image>? loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }
}
