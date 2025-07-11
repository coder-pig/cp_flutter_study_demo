import 'package:flutter/material.dart';

/// 主入口函数
void main() {
  runApp(const MyApp());
}

/// 应用程序根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SingleChildScrollView Clip Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const SingleChildScrollViewNoneClipDemo(),
  );
}

/// SingleChildScrollView 剪切效果演示页面
class SingleChildScrollViewNoneClipDemo extends StatefulWidget {
  const SingleChildScrollViewNoneClipDemo({super.key});

  @override
  State<SingleChildScrollViewNoneClipDemo> createState() => _SingleChildScrollViewNoneClipDemoState();
}

class _SingleChildScrollViewNoneClipDemoState extends State<SingleChildScrollViewNoneClipDemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SingleChildScrollView Clip 对比'),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          // 左侧：有剪切效果 (默认)
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.shade100,
                  child: const Text(
                    'Clip.hardEdge-剪切',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        children: _buildOverflowContent(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 右侧：无剪切效果
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.orange.shade100,
                  child: const Text(
                    'Clip.none-无剪切',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      clipBehavior: Clip.none,
                      child: Column(
                        children: _buildOverflowContent(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建超出边界的内容
  List<Widget> _buildOverflowContent() => [
    // 正常内容
    Container(
      height: 100,
      color: Colors.blue.shade200,
      child: const Center(
        child: Text('正常内容 1', style: TextStyle(fontSize: 18)),
      ),
    ),
    const SizedBox(height: 10),
    Container(
      height: 100,
      color: Colors.green.shade200,
      child: const Center(
        child: Text('正常内容 2', style: TextStyle(fontSize: 18)),
      ),
    ),
    const SizedBox(height: 10),
    // 超出边界的内容
    Transform.translate(
      offset: const Offset(50, 0), // 向右偏移50像素，超出容器边界
      child: Container(
        height: 120,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '超出边界的内容 ╰( ͡° ͜ʖ ͡° )つ──☆*:・ﾟ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
    const SizedBox(height: 20),
    Container(
      height: 100,
      color: Colors.purple.shade200,
      child: const Center(
        child: Text('正常内容 3', style: TextStyle(fontSize: 18)),
      ),
    ),
    const SizedBox(height: 10),
    // 另一个超出边界的内容
    Transform.translate(
      offset: const Offset(-30, 0), // 向左偏移30像素
      child: Container(
        height: 100,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.orange.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            '左侧超出内容 ٩(◕‿◕)۶',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
    const SizedBox(height: 20),
    Container(
      height: 100,
      color: Colors.teal.shade200,
      child: const Center(
        child: Text('正常内容 4', style: TextStyle(fontSize: 18)),
      ),
    ),
  ];
}

