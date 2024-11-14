import 'package:cp_flutter_study_demo/utils/color_ext.dart';
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
        appBar: AppBar(title: const Text('Overlay浮窗弹浮窗Demo')),
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
  late OverlayEntry _overlayEntry;
  final List<OverlayEntry> _entries = [];

  void _showOverlay(int index) {
    Overlay.of(context).insert(_entries[index]);
  }

  @override
  void dispose() {
    for (var entry in _entries) {
      entry.remove();
    }
    _entries.clear();
    super.dispose();
  }

  OverlayEntry buildOverlayEntry(int index, Color color) => OverlayEntry(
    builder: (context) => Positioned(
      top: 50 + index * 20.0,
      left: 100,
      child: Container(
        color: color,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                var newIndex = index + 1;
                if (newIndex >= _entries.length) {
                  _entries.add(buildOverlayEntry(newIndex, randomColor));
                } else {
                  _entries[newIndex] = buildOverlayEntry(newIndex, randomColor);
                }
                _showOverlay(newIndex);
              },
              child: const Text('打开浮层'),
            ),
            ElevatedButton(
              onPressed: () {
                var entry = _entries[index];
                _entries.remove(entry);
                entry.remove();
              },
              child: const Text('关闭浮层'),
            )
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () {
      _overlayEntry = buildOverlayEntry(0, randomColor);
      _entries.add(_overlayEntry);
      _showOverlay(0);
    },
    child: const Text('显示Overlay浮层'),
  );
}