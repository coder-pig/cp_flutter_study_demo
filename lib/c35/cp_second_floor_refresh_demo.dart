import 'package:cp_flutter_study_demo/c35/cp_second_floor_refresh.dart';
import 'package:flutter/material.dart';

class CpSecondFloorRefreshDemo extends StatefulWidget {
  const CpSecondFloorRefreshDemo({super.key});

  @override
  State<CpSecondFloorRefreshDemo> createState() => _CpSecondFloorRefreshDemoState();
}

class _CpSecondFloorRefreshDemoState extends State<CpSecondFloorRefreshDemo> {
  final CpRefreshContainer _refreshContainer = CpRefreshContainer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('二楼刷新'),
      ),
      body: CpSecondFloorRefresh(
        controller: _refreshContainer,
        enableRefresh: true,
        enableLoadMore: true,
        enableSecondFloor: true,
        onRefresh: () {
          print('触发刷新');
        },
        onLoadMore: () {
          print('触发加载更多');
        },
        onSecondFloor: () {
          print('触发进入二楼');
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _refreshContainer.showSecondFloor();
            },
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _refreshContainer.hideSecondFloor();
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CpSecondFloorRefreshDemo',
      home: CpSecondFloorRefreshDemo(),
    );
  }
}