import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SliverPersistentHeader Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SliverPersistentHeaderDemo(),
      );
}

/// 头部类型枚举
enum HeaderType {
  pinned,    // 固定头部
  floating,  // 浮动头部
  both,      // 固定+浮动头部
}

/// SliverPersistentHeader 演示页面
class SliverPersistentHeaderDemo extends StatefulWidget {
  const SliverPersistentHeaderDemo({super.key});

  @override
  State<SliverPersistentHeaderDemo> createState() => _SliverPersistentHeaderDemoState();
}

class _SliverPersistentHeaderDemoState extends State<SliverPersistentHeaderDemo> {
  HeaderType _currentType = HeaderType.pinned;

  /// 获取当前头部类型的配置
  Map<String, bool> get _headerConfig {
    switch (_currentType) {
      case HeaderType.pinned:
        return {'pinned': true, 'floating': false};
      case HeaderType.floating:
        return {'pinned': false, 'floating': true};
      case HeaderType.both:
        return {'pinned': true, 'floating': true};
    }
  }

  /// 获取当前头部类型的描述
  String get _headerDescription {
    switch (_currentType) {
      case HeaderType.pinned:
        return '固定头部 (Pinned Header) ✨\n滚动时会固定在顶部';
      case HeaderType.floating:
        return '浮动头部 (Floating Header) 🌟\n反向滚动时立即出现';
      case HeaderType.both:
        return '固定+浮动头部 (Pinned + Floating) 🎉\n结合两种效果';
    }
  }

  /// 获取当前头部类型的颜色
  List<Color> get _headerColors {
    switch (_currentType) {
      case HeaderType.pinned:
        return [Colors.blue.shade400, Colors.blue.shade800];
      case HeaderType.floating:
        return [Colors.green.shade400, Colors.green.shade800];
      case HeaderType.both:
        return [Colors.purple.shade400, Colors.purple.shade800];
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // 主要的 SliverPersistentHeader
              SliverPersistentHeader(
                pinned: _headerConfig['pinned']!,
                floating: _headerConfig['floating']!,
                delegate: _SliverHeaderDelegate(
                  minHeight: 80.0,
                  maxHeight: 250.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _headerColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _headerDescription.split('\n')[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _headerDescription.split('\n')[1],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 说明文本
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎯 当前效果说明：',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getEffectDescription(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 列表项
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: _headerColors[0].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _headerColors[0].withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        '列表项 ${index + 1} ${_getRandomEmoji()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _headerColors[1],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentType.index,
          onTap: (index) => setState(() => _currentType = HeaderType.values[index]),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.push_pin),
              label: '固定头部',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: '浮动头部',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: '固定+浮动',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showHelpDialog(context),
          tooltip: '查看使用说明',
          child: const Icon(Icons.help_outline),
        ),
      );

  /// 获取效果描述
  String _getEffectDescription() {
    switch (_currentType) {
      case HeaderType.pinned:
        return '• 向下滚动时，头部会逐渐收缩到最小高度\n'
            '• 收缩完成后，头部会固定在屏幕顶部\n'
            '• 向上滚动时，头部会逐渐展开到最大高度\n'
            '• 适用于需要始终可见的导航栏场景';
      case HeaderType.floating:
        return '• 向下滚动时，头部会完全消失\n'
            '• 向上滚动时，头部会立即重新出现\n'
            '• 头部不会固定在顶部\n'
            '• 适用于需要节省屏幕空间的场景';
      case HeaderType.both:
        return '• 结合了固定和浮动两种效果\n'
            '• 向下滚动时，头部收缩并固定在顶部\n'
            '• 向上滚动时，头部会立即开始展开\n'
            '• 提供最佳的用户体验和交互性';
    }
  }

  /// 获取随机表情符号
  String _getRandomEmoji() {
    final emojis = ['(｡◕‿◕｡)', '♪(´▽｀)', '(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', '╰( ͡° ͜ʖ ͡° )つ──☆*:･ﾟ', '(≧∇≦)', '(◡ ‿ ◡ ✿)'];
    return emojis[math.Random().nextInt(emojis.length)];
  }

  /// 显示帮助对话框
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💡 使用说明'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎯 如何体验不同效果：'),
              SizedBox(height: 8),
              Text('1. 点击底部导航栏切换不同的头部类型'),
              Text('2. 上下滚动页面观察头部的变化'),
              Text('3. 注意观察右下角的收缩进度提示'),
              SizedBox(height: 16),
              Text('📋 三种效果对比：'),
              SizedBox(height: 8),
              Text('• 固定头部：收缩后固定在顶部'),
              Text('• 浮动头部：反向滚动时立即出现'),
              Text('• 固定+浮动：结合两种效果'),
              SizedBox(height: 16),
              Text('💫 观察要点：'),
              SizedBox(height: 8),
              Text('• 头部的高度变化'),
              Text('• 头部的位置变化'),
              Text('• 滚动方向对头部的影响'),
              Text('• 收缩进度的实时显示'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

/// 自定义 SliverPersistentHeaderDelegate
/// 这是实现 SliverPersistentHeader 功能的核心类
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  /// 构造函数
  /// [minHeight] 最小高度
  /// [maxHeight] 最大高度  
  /// [child] 子组件
  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  /// 获取最小高度
  @override
  double get minExtent => minHeight;

  /// 获取最大高度
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  /// 构建头部组件
  /// [context] 构建上下文
  /// [shrinkOffset] 收缩偏移量，用于计算当前的收缩程度
  /// [overlapsContent] 是否与内容重叠
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 计算当前的收缩进度（0.0 到 1.0）
    final double shrinkProgress = shrinkOffset / (maxExtent - minExtent);
    
    return SizedBox.expand(
      child: Stack(
        children: [
          child,
          // 添加一个透明度变化的遮罩，展示收缩效果
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(shrinkProgress * 0.2),
              ),
            ),
          ),
          // 显示当前收缩进度的文本
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '收缩进度: ${(shrinkProgress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // 显示当前高度信息
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '当前高度: ${(maxExtent - shrinkOffset).toInt()}px',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 判断是否需要重建
  /// 当 delegate 的属性发生变化时，返回 true 表示需要重建
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate is _SliverHeaderDelegate) {
      return oldDelegate.minHeight != minHeight ||
          oldDelegate.maxHeight != maxHeight ||
          oldDelegate.child != child;
    }
    return true;
  }
}
