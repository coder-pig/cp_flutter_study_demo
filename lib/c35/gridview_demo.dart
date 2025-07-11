import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GridView Examples',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const GridViewDemo(),
    );
  }
}

class GridViewDemo extends StatefulWidget {
  const GridViewDemo({super.key});

  @override
  State<GridViewDemo> createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // 模拟一些数据
  final List<int> data = List.generate(50, (index) => index);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView Constructors'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'GridView()'),
            Tab(text: 'count'),
            Tab(text: 'extent'),
            Tab(text: 'builder'),
            Tab(text: 'custom'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDefaultGridView(),
          _buildGridViewCount(),
          _buildGridViewExtent(),
          _buildGridViewBuilder(),
          _buildGridViewCustom(),
        ],
      ),
    );
  }

  // 1. GridView() - 默认构造函数
  // 需要手动提供 gridDelegate 和 children 列表。
  // 适合少量、固定的子项。
  Widget _buildDefaultGridView() {
    return GridView(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0, // 子项的宽高比
      ),
      children: data.map((i) => GridItem(index: i)).toList(),
    );
  }

  // 2. GridView.count() - 最常用
  // 用于创建固定列数的网格。
  Widget _buildGridViewCount() {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      // 核心参数：固定列数
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: data.map((i) => GridItem(index: i)).toList(),
    );
  }

  // 3. GridView.extent() - 响应式布局
  // 根据子项的最大宽度自动计算列数。
  Widget _buildGridViewExtent() {
    return GridView.extent(
      padding: const EdgeInsets.all(10),
      // 核心参数：子项在交叉轴上的最大尺寸
      maxCrossAxisExtent: 120.0,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: data.map((i) => GridItem(index: i)).toList(),
    );
  }

  // 4. GridView.builder() - 高性能懒加载
  // 用于大量或无限数据的场景，按需构建子项。
  Widget _buildGridViewBuilder() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      // 布局代理，与默认构造函数中的一样
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      // 核心参数：子项总数
      itemCount: data.length,
      // 核心参数：子项构建器
      itemBuilder: (context, index) {
        // 只有当 item 将要显示时，此方法才会被调用
        print('Building item for builder: $index');
        return GridItem(index: data[index]);
      },
    );
  }

  // 5. GridView.custom() - 完全自定义
  // 提供了最大的灵活性，可以自定义子项的构建和管理策略。
  Widget _buildGridViewCustom() {
    return GridView.custom(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      // 核心参数：子项代理
      // SliverChildBuilderDelegate 行为与 GridView.builder 相同
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          return GridItem(index: data[index]);
        },
        childCount: data.length,
      ),
    );
  }
}

// 用于显示在网格中的通用子项 Widget
class GridItem extends StatelessWidget {
  final int index;
  const GridItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Item $index',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}