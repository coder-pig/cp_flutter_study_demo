import 'package:flutter/material.dart';

import 'gesture_paint_preview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('自定义图表')),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    child: Wrap(
      spacing: 10,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GesturePaintPreview()));
            },
            child: const Text("手势识别绘制效果预览")),
      ],
    ),
  );
}
