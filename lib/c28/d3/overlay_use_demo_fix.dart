import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Overlay使用Demo')),
        body: const OverlayExample(),
      ),
    );
  }
}

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});

  @override
  State createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  // 💡 ① 定义浮层变量
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    // 💡 ② 初始化浮层
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 200,
        child: Container(
          color: Colors.red,
          width: 200,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                _overlayEntry.remove();
              },
              child: const Text('关闭浮层'),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    // 💡 ③ 显示浮层
    Overlay.of(context).insert(_overlayEntry);
  }

  @override
  void dispose() {
    // 💡 ④ 卸载浮层
    _overlayEntry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: _showOverlay,
        child: const Text('显示Overlay浮层'),
      );
}