import 'package:cp_flutter_study_demo/c28/d2/filter_menu_indexed_stack.dart';
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
        appBar: AppBar(
          title: const Text('基于IndexedStack实现下拉菜单筛选框'),
        ),
        body: const MenuPage(),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final FilterMenuController _menuController = FilterMenuController((currentIndex, stackIndex) {
    print('当前展开的菜单索引: $currentIndex, 当前显示的IndexedStack索引: $stackIndex');
    print("当前菜单状态：${stackIndex == 0 ? '关闭' : '展开'}");
  });

  @override
  Widget build(BuildContext context) {
    return FilterMenuIndexedStack(
        [
          MenuItemConfig('筛选1'),
          MenuItemConfig('筛选2'),
          MenuItemConfig('筛选3'),
          MenuItemConfig('筛选4'),
          MenuItemConfig('筛选5'),
          MenuItemConfig('筛选6'),
        ],
        content: const Center(child: Text('内容区域')),
        popMenus: [
          Container(color: Colors.red, height: 100),
          Container(color: Colors.green, height: 200),
          Container(color: Colors.blue, height: 300),
          Container(color: Colors.yellow, height: 400),
          Container(color: Colors.purple, height: 500),
          Container(color: Colors.orange, height: 600),
        ],
        menuController: _menuController);
  }
}
