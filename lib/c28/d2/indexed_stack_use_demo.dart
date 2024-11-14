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
        appBar: AppBar(title: const Text('IndexedStack Demo')),
        body: const Center(
          child: IndexedStackExample(),
        ),
      ),
    );
  }
}

class IndexedStackExample extends StatefulWidget {
  const IndexedStackExample({super.key});

  @override
  State createState() => _IndexedStackExampleState();
}

class _IndexedStackExampleState extends State<IndexedStackExample> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // IntrinsicHeight 会根据子控件的高度来确定自身的高度
        IntrinsicHeight(
          child: Column(
            children: [
              _buildButton('Show Red', 0),
              _buildButton('Show Green', 1),
              _buildButton('Show Blue', 2),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Container(
              color: Colors.grey,
              child: IndexedStack(
                // 💡 index 为要显示的子控件的索引
                index: _selectedIndex,
                children: <Widget>[
                  _buildColorSquare('Red', Colors.red),
                  _buildColorSquare('Green', Colors.green),
                  _buildColorSquare('Blue', Colors.blue),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  // 构建按钮
  Widget _buildButton(String text, int index) => ElevatedButton(
        onPressed: () => _updateIndex(index),
        child: Text(text),
      );

  // 构建随机颜色的正方形
  Widget _buildColorSquare(String text, Color color) => Container(
        width: 100,
        height: 100,
        color: color,
        child: Center(child: Text(text)),
      );
}
