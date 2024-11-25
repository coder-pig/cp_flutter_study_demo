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
        appBar: AppBar(title: const Text('Gesture手势测试')),
        body: const GestureTestPage(),
      ),
    );
  }
}

class GestureTestPage extends StatefulWidget {
  const GestureTestPage({super.key});

  @override
  State createState() => _GestureTestPage();
}

class _GestureTestPage extends State<GestureTestPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          print('onTap');
        },
        onDoubleTap: () {
          print('onDoubleTap');
        },
        onLongPress: () {
          print('onLongPress');
        },
        onPanUpdate: (details) {
          print('onPanUpdate: ${details.localPosition}');
        },
        child: Container(
          width: 200,
          height: 200,
          color: Colors.blue,
        ),
      ),
    );
  }
}
