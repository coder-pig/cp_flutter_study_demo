import 'package:flutter/material.dart';

import 'bar_chart.dart';
import 'line_chart.dart';
import 'pie_chart.dart';
import 'spider_chart.dart';

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BarChartPage()));
                },
                child: const Text("柱形/直方图")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LineChartPage()));
                },
                child: const Text("折线图")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PieChartPage()));
                },
                child: const Text("饼图")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SpiderChartPage()));
                },
                child: const Text("蜘蛛/雷达图"))
          ],
        ),
      );
}
