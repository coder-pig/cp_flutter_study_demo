import 'dart:math';

import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:cp_flutter_study_demo/utils/state_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('地图')),
          body: const MapChart(),
        ),
      );
}

class MapChart extends StatefulWidget {
  const MapChart({super.key});

  @override
  State<StatefulWidget> createState() => _MapChartState();
}

class _MapChartState extends State<MapChart> with SingleTickerProviderStateMixin {
  List<MapChartModel> _models = [];
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IntrinsicHeight(
            child: Column(
      children: [
        SizedBox(height: 400, child: Paper(painter: MapPainter(_models))),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              fetchData();
            },
            child: const Text("拉取数据"))
      ],
    )));
  }

  // 拉取地图数据
  fetchData() async {
    List<MapChartModel> models = [];
    Response response = await dio.get('https://geo.datav.aliyun.com/areas_v2/bound/100000_full.json');
    for (var feature in response.data['features']) {
      MapChartModel model = MapChartModel(feature['properties']['name'], []);
      for (var coordinates in feature['geometry']['coordinates'][0]) {
        if (coordinates is List) {
          if(coordinates.length == 2) {
            model.polygons.add([coordinates[0].toDouble(), coordinates[1].toDouble()]);
          } else {
            for(var polygon in coordinates) {
              if(polygon is List) {
                model.polygons.add([polygon[0].toDouble(), polygon[1].toDouble()]);
              } else {
              }
            }
          }
        }
      }
      models.add(model);
    }
    safeSetState(() {
      _models = models;
    });
  }
}

class MapChartModel {
  final String name; // 城市名称
  final List<List<double>> polygons; // 点列表

  MapChartModel(this.name, this.polygons);
}

class MapPainter extends CustomPainter {
  final List<MapChartModel>? models;

  MapPainter(this.models);

  @override
  void paint(Canvas canvas, Size size) {
    if (models == null) return;

    // 计算地图边界
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;

    for (var model in models!) {
      for (var point in model.polygons) {
        if (point[0] < minX) minX = point[0];
        if (point[0] > maxX) maxX = point[0];
        if (point[1] < minY) minY = point[1];
        if (point[1] > maxY) maxY = point[1];
      }
    }

    // 计算缩放比例和偏移量
    double scaleX = (size.width - 50) / (maxX - minX);
    double scaleY = (size.height - 50) / (maxY - minY);
    double scale = min(scaleX, scaleY);
    double offsetX = (size.width - (maxX - minX) * scale) / 2;
    double offsetY = (size.height - (maxY - minY) * scale) / 2;

    // 平移和缩放画布
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, -scale);
    int count = 0;

    // 绘制地图
    for (var model in models!) {
      Path path = Path();
      for (var i = 0; i < model.polygons.length; i++) {
        if (i == 0) {
          path.moveTo(model.polygons[i][0] - minX, model.polygons[i][1] - minY);
        } else {
          path.lineTo(model.polygons[i][0] - minX, model.polygons[i][1] - minY);
        }
      }
      path.close();
      canvas.drawPath(path, Paint()..color = Colors.primaries[count % Colors.primaries.length].withOpacity(0.5));
      count++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
