import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // 使用 TabController 来轻松切换不同的 PageView 示例
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('PageView Examples'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Default'),
                Tab(text: 'Builder'),
                Tab(text: 'Custom'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // 示例 1: PageView()
              DefaultPageViewDemo(),
              // 示例 2: PageView.builder()
              BuilderPageViewDemo(),
              // 示例 3: PageView.custom()
              CustomPageViewDemo(),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// 示例 1: PageView() - 默认构造函数
// ===================================================================
/// 适用场景：当页面数量是固定的、并且数量较少时。
/// 优点：代码最简单直观。
/// 缺点：一次性构建所有子页面，如果页面过多或过于复杂，会消耗大量内存和CPU，导致性能问题。
class DefaultPageViewDemo extends StatelessWidget {
  const DefaultPageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building DefaultPageViewExample which builds ALL its children at once.");
    return PageView(
      children: <Widget>[
        _buildPage(1, Colors.pink),
        _buildPage(2, Colors.cyan),
        _buildPage(3, Colors.deepPurple),
      ],
    );
  }

  Widget _buildPage(int pageNumber, Color color) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          'Page $pageNumber\n(From PageView())',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ===================================================================
// 示例 2: PageView.builder() - 构造器构造函数
// ===================================================================
/// 适用场景：最常用、性能最好的方式，尤其适合页面数量多或不确定的情况。
/// 优点：懒加载（Lazy Loading）。只构建当前可见和缓存区内的页面，极大地节省了资源。
/// 缺点：需要提供 itemCount。
class BuilderPageViewDemo extends StatelessWidget {
  const BuilderPageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // 假设我们有100个页面
    const int pageCount = 100;

    return PageView.builder(
      itemCount: pageCount,
      itemBuilder: (BuildContext context, int index) {
        // itemBuilder 会在页面即将进入视口时被调用
        // 这意味着只有当用户滑动到某个页面时，它才会被构建
        print("Building page ${index + 1} for PageView.builder...");
        
        // 使用取模运算来循环使用颜色
        final color = Colors.accents[index % Colors.accents.length];
        
        return Container(
          color: color,
          child: Center(
            child: Text(
              'Page ${index + 1}\n(From PageView.builder())',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

// ===================================================================
// 示例 3: PageView.custom() - 自定义构造函数
// ===================================================================
/// 适用场景：需要对子项的构建、布局和回收逻辑进行高度自定义时。
/// 优点：最灵活，可以集成自定义的 SliverChildDelegate，实现例如在列表中混合不同类型的项目。
/// 缺点：代码相对复杂，通常不常用，除非有特殊需求。
class CustomPageViewDemo extends StatelessWidget {
  const CustomPageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.custom(
      // childrenDelegate 是核心，它决定了如何提供子页面
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 在这个例子中，我们让奇数页和偶数页显示不同的内容
          if (index.isEven) {
            return Container(
              color: Colors.green,
              child: Center(
                child: Text(
                  'Even Page ${index + 1}\n(From PageView.custom())',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.orange,
              child: Center(
                child: Text(
                  'Odd Page ${index + 1}\n(From PageView.custom())',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            );
          }
        },
        // 同样可以指定子项数量，也可以为 null 表示无限列表
        childCount: 20, 
      ),
    );
  }
}