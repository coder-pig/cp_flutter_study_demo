import 'package:cp_flutter_study_demo/c29/d3/canvas/canvas_api_first_preview.dart';
import 'package:cp_flutter_study_demo/c29/d3/paint/paint_api_first_preview.dart';
import 'package:cp_flutter_study_demo/c29/d3/paint/paint_api_second_preview.dart';
import 'package:flutter/material.dart';

import 'canvas/canvas_api_second_preview.dart';
import 'paint/color_filter_demo.dart';
import 'paint/other_filter_demo.dart';
import 'paint/paint_api_third_preview.dart';
import 'path/path_api_first_preview.dart';
import 'path/path_api_second_preview.dart';
import 'path/path_api_thrid_preview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('绘制API预览入口')),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaintApiFirstPreviewPage()));
                  },
                  child: const Text('Paint API-基础属性')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaintApiSecondPreviewPage()));
                  },
                  child: const Text('Paint API-着色器')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaintApiThirdPreviewPage()));
                  },
                  child: const Text('Paint API-混合模式')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CanvasApiFirstPreview()));
                  },
                  child: const Text('Canvas API-图形绘制')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CanvasApiSecondPreview()));
                  },
                  child: const Text('Canvas API-其它')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PathApiFirstPreview()));
                  },
                  child: const Text('Path API-移动路径')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PathApiSecondPreview()));
                  },
                  child: const Text('Path API-添加路径')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PathApiThirdPreview()));
                  },
                  child: const Text('Path API-其它')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ColorFilterDemo()));
                  },
                  child: const Text('ColorFilter-滤色器')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OtherFilterDemo()));
                  },
                  child: const Text('Filter-其它滤镜')),
            ],
          )
        ]),
      ));
}
