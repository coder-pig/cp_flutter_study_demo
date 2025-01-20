import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('CustomPainter 实现用户操作引导'),
          ),
          body: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey firstKey = GlobalKey();
  GlobalKey secondKey = GlobalKey();
  GlobalKey thirdKey = GlobalKey();
  GlobalKey forthKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 30),
          ElevatedButton(
              key: firstKey,
              onPressed: () {
                showHighLight(context, firstKey);
              },
              child: const Text("高亮")),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  showHighLight(context, secondKey);
                },
                child: Container(key: secondKey, width: 100, height: 100, color: Colors.yellow),
              ),
              ElevatedButton(
                  key: thirdKey,
                  onPressed: () {
                    showHighLight(context, thirdKey);
                  },
                  child: const Text("高亮")),
            ],
          ),
          const SizedBox(height: 300),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      key: forthKey,
                      onPressed: () {
                        showHighLight(context, forthKey);
                      },
                      child: const Text("高亮")))),
        ]));
  }
}

class HighLightWidget extends StatelessWidget {
  final GlobalKey highLightKey;
  final VoidCallback onDismiss;

  const HighLightWidget(this.highLightKey, this.onDismiss, {super.key});

  @override
  Widget build(BuildContext context) {
    // 获取高亮组件的宽高、位置信息、中点坐标
    BuildContext? highLightContext = highLightKey.currentContext;
    if (highLightContext == null) return Container();
    // 获取高亮组件的宽高、位置信息、中点坐标
    final renderBox = highLightContext.findRenderObject() as RenderBox;
    final widgetSize = renderBox.size;
    double widgetWidth = widgetSize.width;
    double widgetHeight = widgetSize.height;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero); // 这里获取到原始坐标

    // 计算出高亮区域的Path
    Path lightPath = Path();
    lightPath.addRect(Rect.fromLTWH(widgetPosition.dx, widgetPosition.dy, widgetWidth, widgetHeight));
    return GestureDetector(
      onTap: onDismiss,
      child: CustomPaint(
        painter: LightPainter(lightPath),
        child: Container(),
      ),
    );
  }
}

class LightPainter extends CustomPainter {
  // 高亮区域的Path
  final Path _lightPath;

  // 画布宽高
  double width = 0;
  double height = 0;

  final Paint highLightPaint = Paint() // 高亮
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;

  LightPainter(this._lightPath);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    canvas.saveLayer(Offset.zero & Size(width, height), Paint());
    // 绘制半透明背景
    canvas.drawRect(Offset.zero & Size(width, height), Paint()..color = Colors.black.withOpacity(0.5));
    // 绘制高亮区域
    canvas.drawPath(_lightPath, highLightPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => _lightPath != (oldDelegate as LightPainter)._lightPath;
}

// 弹出用户引导
showHighLight(BuildContext context, GlobalKey highLightKey) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(builder: (context) {
    return HighLightWidget(highLightKey, () {
      // 💡 浮层里的视图点击后，移除浮层
      overlayEntry?.remove();
    });
  });
  Overlay.of(context).insert(overlayEntry);
}
