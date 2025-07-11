import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SimpleScrollDemo(),
  ));
}

/// 使用 Scrollable 实现的最简单滚动案例
class SimpleScrollDemo extends StatefulWidget {
  const SimpleScrollDemo({super.key});

  @override
  State<SimpleScrollDemo> createState() => _SimpleScrollDemoState();
}

class _SimpleScrollDemoState extends State<SimpleScrollDemo> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Scroll Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Scrollable(
        controller: _scrollController,
        viewportBuilder: (context, position) => Viewport(
          offset: position,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(height: 500, color: Colors.red),
                  Container(height: 500, color: Colors.green),
                  Container(height: 500, color: Colors.yellow),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
            heroTag: "top",
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
            heroTag: "bottom",
            child: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }

  /// 构建简单的滚动内容 - 高度2000的Container
  Widget _buildSimpleContent() => Container(
        height: 2000,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.1),
              Colors.pink.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildContentSection('顶部区域 ♪(´▽｀)', Colors.blue),
            _buildContentSection('中间区域 (ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', Colors.purple),
            _buildContentSection('底部区域 ╰( ͡° ͜ʖ ͡° )つ──☆*:･ﾟ', Colors.pink),
          ],
        ),
      );

  /// 构建内容区域
  Widget _buildContentSection(String text, Color color) => Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );

  /// 滚动到顶部
  void _scrollToTop() => _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

  /// 滚动到底部
  void _scrollToBottom() => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
}
