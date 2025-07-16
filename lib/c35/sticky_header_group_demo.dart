import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'dart:math' as math;

/// 应用入口
void main() => runApp(const MyApp());

/// 根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'StickyHeader 分组吸顶演示',
        theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
        home: const StickyHeaderGroupDemo(),
      );
}

/// 分组数据模型
class GroupData {
  final String title;         // 分组标题
  final Color color;          // 主题颜色
  final List<ItemData> items; // 分组内项目

  GroupData({required this.title, required this.color, required this.items});
}

/// 列表项数据模型
class ItemData {
  final String title;   // 标题
  final IconData icon;  // 图标

  ItemData({required this.title, required this.icon});
}

/// StickyHeader 分组吸顶演示页面
class StickyHeaderGroupDemo extends StatelessWidget {
  const StickyHeaderGroupDemo({super.key});

  // 生成演示数据
  List<GroupData> _buildGroups() {
    final random = math.Random();
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.home,
      Icons.work,
      Icons.school,
      Icons.music_note,
      Icons.flight,
      Icons.shop,
    ];

    List<GroupData> groups = [];
    final colors = [Colors.red, Colors.orange, Colors.green, Colors.blue, Colors.purple, Colors.pink];
    final fruits = ['🍎', '🍌', '🍇', '🍉', '🍒', '🥭'];
    for (int i = 0; i < 6; i++) {
      groups.add(GroupData(
        title: '${fruits[i]} 第 ${i + 1} 组',
        color: colors[i].shade400,
        items: List.generate(
          8,
          (index) => ItemData(
            title: '项目 ${index + 1}',
            icon: icons[random.nextInt(icons.length)],
          ),
        ),
      ));
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _buildGroups();

    return Scaffold(
      appBar: AppBar(title: const Text('StickyHeader 分组吸顶演示')),
      body: CustomScrollView(
        slivers: [
          for (final group in groups)
            SliverStickyHeader(
              header: _buildGroupHeader(group),
              sliver: _buildGroupList(group),
            ),
        ],
      ),
    );
  }

  /// 构建分组头部
  Widget _buildGroupHeader(GroupData group) => Container(
        height: 60,
        color: group.color,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          group.title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  /// 构建分组列表
  Widget _buildGroupList(GroupData group) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(
            leading: CircleAvatar(
              backgroundColor: group.color.withOpacity(.2),
              child: Icon(group.items[index].icon, color: group.color),
            ),
            title: Text(group.items[index].title),
          ),
          childCount: group.items.length,
        ),
      );
} 