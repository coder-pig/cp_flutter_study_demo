import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '多个SliverPersistentHeader演示',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MultiplePinnedHeaderDemo(),
      );
}

/// 多个SliverPersistentHeader演示页面
class MultiplePinnedHeaderDemo extends StatefulWidget {
  const MultiplePinnedHeaderDemo({super.key});

  @override
  State<MultiplePinnedHeaderDemo> createState() => _MultiplePinnedHeaderDemoState();
}

class _MultiplePinnedHeaderDemoState extends State<MultiplePinnedHeaderDemo> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  
  // 预生成随机数据，避免滚动时重复计算
  late final List<IconData> _preGeneratedIcons;
  late final List<String> _preGeneratedEmojis;

  @override
  void initState() {
    super.initState();
    // 预生成足够的随机数据
    _preGeneratedIcons = _generateRandomIcons(50);
    _preGeneratedEmojis = _generateRandomEmojis(50);
    
    // 移除滚动监听器，减少不必要的 setState
    // _scrollController.addListener(() {
    //   setState(() {
    //     _scrollOffset = _scrollController.offset;
    //   });
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('多个固定头部演示'),
          backgroundColor: Colors.deepPurple.shade100,
          elevation: 0,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 第一个头部 - 用户信息头部
            _buildUserInfoHeader(),
            
            // 第一组内容
            _buildContentSection('个人信息', Colors.blue, 5),

            // 第二个头部 - 导航菜单头部
            _buildNavigationHeader(),
            
            // 第二组内容
            _buildContentSection('菜单选项', Colors.green, 8),

            // 第三个头部 - 统计信息头部
            _buildStatsHeader(),
            
            // 第三组内容
            _buildContentSection('数据统计', Colors.orange, 6),

            // 第四个头部 - 设置头部
            _buildSettingsHeader(),
            
            // 第四组内容
            _buildContentSection('系统设置', Colors.purple, 10),

            // 底部间距
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showEffectExplanation(),
          tooltip: '查看效果说明',
          child: const Icon(Icons.info_outline),
        ),
      );

  /// 构建用户信息头部
  Widget _buildUserInfoHeader() => SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: _CustomHeaderDelegate(
          minHeight: 60.0,
          maxHeight: 150.0,
          colors: [Colors.blue.shade400, Colors.blue.shade700],
          title: '👤 用户中心',
          subtitle: '查看个人信息和设置',
          icon: Icons.account_circle,
        ),
      );

  /// 构建导航菜单头部
  Widget _buildNavigationHeader() => SliverPersistentHeader(
        pinned: true,
        delegate: _CustomHeaderDelegate(
          minHeight: 60.0,
          maxHeight: 120.0,
          colors: [Colors.green.shade400, Colors.green.shade700],
          title: '🧭 导航菜单',
          subtitle: '快速访问常用功能',
          icon: Icons.menu,
        ),
      );

  /// 构建统计信息头部
  Widget _buildStatsHeader() => SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: _CustomHeaderDelegate(
          minHeight: 60.0,
          maxHeight: 130.0,
          colors: [Colors.orange.shade400, Colors.orange.shade700],
          title: '📊 数据中心',
          subtitle: '查看详细统计信息',
          icon: Icons.bar_chart,
        ),
      );

  /// 构建设置头部
  Widget _buildSettingsHeader() => SliverPersistentHeader(
        pinned: true,
        delegate: _CustomHeaderDelegate(
          minHeight: 60.0,
          maxHeight: 140.0,
          colors: [Colors.purple.shade400, Colors.purple.shade700],
          title: '⚙️ 系统设置',
          subtitle: '个性化配置和偏好',
          icon: Icons.settings,
        ),
      );

  /// 构建内容区域
  Widget _buildContentSection(String title, MaterialColor color, int itemCount) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ContentItem(
            title: '$title 项目 ${index + 1}',
            subtitle: '这是$title的第${index + 1}个选项',
            icon: _preGeneratedIcons[index % _preGeneratedIcons.length],
            emoji: _preGeneratedEmojis[index % _preGeneratedEmojis.length],
            color: color,
          ),
          childCount: itemCount,
        ),
      );

  /// 预生成随机图标列表
  List<IconData> _generateRandomIcons(int count) {
    final icons = [
      Icons.star, Icons.favorite, Icons.home, Icons.work,
      Icons.school, Icons.restaurant, Icons.shopping_cart, Icons.camera,
      Icons.music_note, Icons.sports_soccer, Icons.flight, Icons.hotel,
    ];
    final random = math.Random();
    return List.generate(count, (index) => icons[random.nextInt(icons.length)]);
  }

  /// 预生成随机表情符号列表
  List<String> _generateRandomEmojis(int count) {
    final emojis = ['(◕‿◕)', '(´∀｀)', '(≧∇≦)', '(◡ ‿ ◡ ✿)', '♪(´▽｀)', '(ﾉ◕ヮ◕)ﾉ'];
    final random = math.Random();
    return List.generate(count, (index) => emojis[random.nextInt(emojis.length)]);
  }

  /// 显示效果说明对话框
  void _showEffectExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎨 多头部效果说明'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎯 观察要点：'),
              SizedBox(height: 8),
              Text('• 多个头部会依次叠加在顶部'),
              Text('• 后面的头部会推挤前面的头部'),
              Text('• 每个头部都有自己的收缩效果'),
              Text('• 固定+浮动的组合创造层级效果'),
              SizedBox(height: 16),
              Text('📋 头部配置：'),
              SizedBox(height: 8),
              Text('• 用户中心：只固定，不浮动'),
              Text('• 导航菜单：固定+浮动'),
              Text('• 数据中心：只固定，不浮动'),
              Text('• 系统设置：固定+浮动'),
              SizedBox(height: 16),
              Text('💡 试试这些操作：'),
              SizedBox(height: 8),
              Text('• 快速向下滚动观察头部叠加'),
              Text('• 慢慢向上滚动看头部展开'),
              Text('• 注意浮动头部的即时响应'),
              Text('• 观察头部高度的实时变化'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('明白了 (｡◕‿◕｡)'),
          ),
        ],
      ),
    );
  }
}

/// 优化的列表项组件，使用 StatelessWidget 避免不必要的重建
class _ContentItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String emoji;
  final MaterialColor color;

  const _ContentItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.shade200),
          boxShadow: [
            BoxShadow(
              color: color.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.shade100,
            child: Icon(
              icon,
              color: color.shade600,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color.shade800,
            ),
          ),
          subtitle: Text(
            '$subtitle $emoji',
            style: TextStyle(color: color.shade600),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color.shade400,
            size: 16,
          ),
        ),
      );
}

/// 自定义头部委托类
class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final List<Color> colors;
  final String title;
  final String subtitle;
  final IconData icon;

  /// 构造函数
  /// [minHeight] 最小高度
  /// [maxHeight] 最大高度
  /// [colors] 渐变色数组
  /// [title] 标题文本
  /// [subtitle] 副标题文本
  /// [icon] 图标
  _CustomHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 计算收缩进度，限制范围避免异常值
    final double shrinkProgress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final double expandedProgress = 1.0 - shrinkProgress;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[1].withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 主要内容
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // 图标
                  Container(
                    width: 40 + (expandedProgress * 20),
                    height: 40 + (expandedProgress * 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8 + (expandedProgress * 12)),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20 + (expandedProgress * 10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 文本内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 + (expandedProgress * 6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // 副标题只在展开时显示
                        if (expandedProgress > 0.3)
                          Opacity(
                            opacity: expandedProgress,
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12 + (expandedProgress * 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
                     // 注释掉调试信息以提升性能
           // 收缩进度指示器（右下角）
           // Positioned(
           //   bottom: 4,
           //   right: 8,
           //   child: Container(
           //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
           //     decoration: BoxDecoration(
           //       color: Colors.black.withOpacity(0.5),
           //       borderRadius: BorderRadius.circular(8),
           //     ),
           //     child: Text(
           //       '${(shrinkProgress * 100).toInt()}%',
           //       style: const TextStyle(
           //         color: Colors.white,
           //         fontSize: 10,
           //       ),
           //     ),
           //   ),
           // ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate is _CustomHeaderDelegate) {
      return oldDelegate.minHeight != minHeight ||
          oldDelegate.maxHeight != maxHeight ||
          oldDelegate.title != title ||
          oldDelegate.subtitle != subtitle ||
          oldDelegate.icon != icon;
    }
    return true;
  }
}
