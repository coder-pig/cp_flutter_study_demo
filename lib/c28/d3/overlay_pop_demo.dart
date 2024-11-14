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
          title: const Text('Overlay弹窗示例'),
        ),
        body: const MenuPage(),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton("左上", Alignment.topLeft, (context, alignment) => showOverlay(context, alignment)),
              _buildButton("上", Alignment.topCenter, (context, alignment) => showOverlay(context, alignment)),
              _buildButton("右上", Alignment.topRight, (context, alignment) => showOverlay(context, alignment)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton("左", Alignment.centerLeft, (context, alignment) => showOverlay(context, alignment)),
              _buildButton("中", Alignment.center, (context, alignment) => showOverlay(context, alignment)),
              _buildButton("右", Alignment.centerRight, (context, alignment) => showOverlay(context, alignment)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton("左下", Alignment.bottomLeft, (context, alignment) => showOverlay(context, alignment)),
              _buildButton("下", Alignment.bottomCenter, (context, alignment) => showOverlay(context, alignment)),
              _buildButton("右下", Alignment.bottomRight, (context, alignment) => showOverlay(context, alignment)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      String direction, Alignment alignment, Function(BuildContext context, Alignment alignment) onPressed) {
    return Builder(builder: (context) {
      return ElevatedButton(onPressed: () => onPressed(context, alignment), child: Text(direction));
    });
  }

  void showOverlay(BuildContext context, Alignment alignment) {
    // 💡 通过context获取当前Widget的RenderObject，并转换为RenderBox，它是具有具体尺寸和位置的渲染对象
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final widgetSize = renderBox.size;

    // 💡 将 RenderBox 的局部坐标转换为全局坐标(渲染盒子的绝对位置)，Offset.zero 表示左上角
    final position = renderBox.localToGlobal(Offset.zero);

    // 💡 浮层的实际位置
    Offset overPosition = const Offset(-300, -300);

    // 💡 如果浮层存在，先移除
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // 💡 根据不同的对齐方式，计算浮层的位置
    if (alignment == Alignment.topLeft) {
      overPosition = overPosition;
    } else if (alignment == Alignment.topCenter) {
      overPosition = position.translate(0, -widgetSize.height);
    } else if (alignment == Alignment.topRight) {
      overPosition = position.translate(widgetSize.width, -widgetSize.height);
    } else if (alignment == Alignment.centerLeft) {
      overPosition = overPosition;
    } else if (alignment == Alignment.center) {
      overPosition = position.translate(0, 0);
    } else if (alignment == Alignment.centerRight) {
      overPosition = position.translate(widgetSize.width, 0);
    } else if (alignment == Alignment.bottomLeft) {
      overPosition = overPosition;
    } else if (alignment == Alignment.bottomCenter) {
      overPosition = position.translate(0, widgetSize.height);
    } else if (alignment == Alignment.bottomRight) {
      overPosition = position.translate(widgetSize.width, widgetSize.height);
    }

    final overlayKey = GlobalKey();
    _overlayEntry = OverlayEntry(builder: (context) {
      print("renderBox-${renderBox.size}、position-${position}、overPosition-${overPosition}");
      return Positioned(
        top: overPosition.dy,
        left: overPosition.dx,
        child: Container(
          color: Colors.red,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                _overlayEntry!.remove();
                _overlayEntry = null;
              },
              child: const Text('关闭'),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(_overlayEntry!);

    // 在下一帧中获取浮层的尺寸
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayRenderBox = overlayKey.currentContext!.findRenderObject() as RenderBox;
      final overlaySize = overlayRenderBox.size;
      // 计算浮层的位置，使其显示在组件的左侧
      if (alignment == Alignment.topLeft) {
        overPosition = position.translate(-overlaySize.width, -widgetSize.height);
      } else if (alignment == Alignment.centerLeft) {
        overPosition = position.translate(-overlaySize.width, 0);
      } else if (alignment == Alignment.bottomLeft) {
        overPosition = position.translate(-overlaySize.width, widgetSize.height);
      }
      // 更新浮层的位置
      _overlayEntry!.markNeedsBuild();
    });
  }
}
