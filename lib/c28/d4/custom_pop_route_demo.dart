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
        appBar: AppBar(title: const Text('简单自定义Route示例')),
        body: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(PopMenuRoute());
        },
        child: const Text('显示弹出菜单'),
      ),
    );
  }
}

class PopMenuRoute extends ModalRoute<void> {
  // 💡 遮罩颜色
  @override
  Color? get barrierColor => Colors.black54;

  // 💡 是否可以点击遮罩关闭
  @override
  bool get barrierDismissible => true;

  // 💡 遮罩的无障碍标签
  @override
  String? get barrierLabel => '关闭弹出菜单';

  // 💡 弹出菜单是否保持状态
  @override
  bool get maintainState => true;

  // 💡 弹出菜单是否不透明
  @override
  bool get opaque => false;

  // 💡 路由过渡动画的持续时间
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  // 💡 弹出菜单的构建方法
  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        // 💡 给弹出菜单添加一个缩放动画
        child: ScaleTransition(
          scale: animation,
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('这是一个弹出菜单'),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
