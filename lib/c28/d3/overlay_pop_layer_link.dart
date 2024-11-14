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
              _buildButton("左上"),
              _buildButton("上"),
              _buildButton("右上"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton("左"),
              _buildButton("中"),
              _buildButton("右"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton("左下"),
              _buildButton("下"),
              _buildButton("右下"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String direction) {
    return Builder(builder: (context) {
      var layerLink = LayerLink();
      return CompositedTransformTarget(
          link: layerLink,
          child: ElevatedButton(
              onPressed: () => {
                    if ("左上" == direction)
                      _showOverlay(context, layerLink, Alignment.topLeft, Alignment.bottomRight)
                    else if ("上" == direction)
                      _showOverlay(context, layerLink, Alignment.topCenter, Alignment.bottomCenter)
                    else if ("右上" == direction)
                      _showOverlay(context, layerLink, Alignment.topRight, Alignment.bottomLeft)
                    else if ("左" == direction)
                      _showOverlay(context, layerLink, Alignment.centerLeft, Alignment.centerRight)
                    else if ("中" == direction)
                      _showOverlay(context, layerLink, Alignment.center, Alignment.center)
                    else if ("右" == direction)
                      _showOverlay(context, layerLink, Alignment.centerRight, Alignment.centerLeft)
                    else if ("左下" == direction)
                      _showOverlay(context, layerLink, Alignment.bottomLeft, Alignment.topRight)
                    else if ("下" == direction)
                      _showOverlay(context, layerLink, Alignment.bottomCenter, Alignment.topCenter)
                    else if ("右下" == direction)
                      _showOverlay(context, layerLink, Alignment.bottomRight, Alignment.topLeft)
                  },
              child: Text(direction)));
    });
  }

  /// 显示浮层
  /// [context] 上下文
  /// [layerLink] LayerLink
  /// [targetAnchor] 目标锚点
  /// [followerAnchor] 跟随者锚点
  void _showOverlay(BuildContext context, LayerLink layerLink, Alignment targetAnchor, Alignment followerAnchor) {
    // 💡 如果浮层存在，先移除
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        // 必须设置top和left，否则Container的宽高不会生效
        top: 0,
        left: 0,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
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
        ),
      );
    });
    Overlay.of(context).insert(_overlayEntry!);
  }
}
