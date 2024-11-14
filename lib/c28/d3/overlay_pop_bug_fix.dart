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
        appBar: AppBar(title: const Text('Overlay弹窗问题演示')),
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
        top: 140,
        left: 0,
        // 需要给Navigator指定一个约束，否则会报constraints.biggest.isFinite错误
        // 这里直接给它套一个SizedBox
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          width: MediaQuery.of(context).size.width,
          child: Navigator(
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder: (context) => Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _overlayEntry.remove();
                        },
                        child: const Text('关闭浮层'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            useRootNavigator: false,
                            builder: (context) => AlertDialog(
                              title: const Text('标题'),
                              content: const Text('内容'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('确定'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('弹对话框'),
                      ),
                    ],
                  ),
                ),
              );
            },
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
