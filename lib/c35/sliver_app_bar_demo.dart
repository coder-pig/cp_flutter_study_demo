import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SliverAppBar Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SliverAppBarDemo(),
      );
}

/// 应用栏类型枚举
enum AppBarType {
  basic,      // 基础应用栏
  expandable, // 可展开应用栏
  pinned,     // 固定应用栏
  floating,   // 浮动应用栏
  snap,       // 快速响应应用栏
}

/// SliverAppBar 演示页面
class SliverAppBarDemo extends StatefulWidget {
  const SliverAppBarDemo({super.key});

  @override
  State<SliverAppBarDemo> createState() => _SliverAppBarDemoState();
}

class _SliverAppBarDemoState extends State<SliverAppBarDemo> {
  AppBarType _currentType = AppBarType.basic;

  /// 获取当前应用栏类型的配置
  Map<String, dynamic> get _appBarConfig {
    switch (_currentType) {
      case AppBarType.basic:
        return {
          'pinned': false,
          'floating': false,
          'snap': false,
          'expandedHeight': null,
        };
      case AppBarType.expandable:
        return {
          'pinned': false,
          'floating': false,
          'snap': false,
          'expandedHeight': 200.0,
        };
      case AppBarType.pinned:
        return {
          'pinned': true,
          'floating': false,
          'snap': false,
          'expandedHeight': 200.0,
        };
      case AppBarType.floating:
        return {
          'pinned': false,
          'floating': true,
          'snap': false,
          'expandedHeight': 200.0,
        };
      case AppBarType.snap:
        return {
          'pinned': false,
          'floating': true,
          'snap': true,
          'expandedHeight': 200.0,
        };
    }
  }

  /// 获取当前应用栏类型的描述
  String get _appBarDescription {
    switch (_currentType) {
      case AppBarType.basic:
        return '基础应用栏 (Basic AppBar) 📱\n简单的固定高度应用栏';
      case AppBarType.expandable:
        return '可展开应用栏 (Expandable AppBar) 📏\n可以展开显示更多内容';
      case AppBarType.pinned:
        return '固定应用栏 (Pinned AppBar) 📌\n滚动时固定在顶部';
      case AppBarType.floating:
        return '浮动应用栏 (Floating AppBar) 🌊\n反向滚动时立即出现';
      case AppBarType.snap:
        return '快速响应应用栏 (Snap AppBar) ⚡\n快速展开和收缩';
    }
  }

  /// 获取当前应用栏类型的主题色
  MaterialColor get _themeColor {
    switch (_currentType) {
      case AppBarType.basic:
        return Colors.blue;
      case AppBarType.expandable:
        return Colors.green;
      case AppBarType.pinned:
        return Colors.purple;
      case AppBarType.floating:
        return Colors.orange;
      case AppBarType.snap:
        return Colors.red;
    }
  }

  /// 获取背景图片
  Widget get _backgroundImage => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _themeColor.shade300,
              _themeColor.shade600,
              _themeColor.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getTypeIcon(),
                size: 48,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 8),
              Text(
                _appBarDescription.split('\n')[1],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  /// 获取类型对应的图标
  IconData _getTypeIcon() {
    switch (_currentType) {
      case AppBarType.basic:
        return Icons.apps;
      case AppBarType.expandable:
        return Icons.expand_more;
      case AppBarType.pinned:
        return Icons.push_pin;
      case AppBarType.floating:
        return Icons.cloud;
      case AppBarType.snap:
        return Icons.flash_on;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // 动态配置的 SliverAppBar
            SliverAppBar(
              // 基础配置
              title: Text(_appBarDescription.split('\n')[0]),
              backgroundColor: _themeColor,
              foregroundColor: Colors.white,
              
              // 行为配置
              pinned: _appBarConfig['pinned'] ?? false,
              floating: _appBarConfig['floating'] ?? false,
              snap: _appBarConfig['snap'] ?? false,
              expandedHeight: _appBarConfig['expandedHeight'],
              
              // 操作按钮
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _showSnackBar('搜索按钮被点击'),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showSnackBar('更多按钮被点击'),
                ),
              ],
              
              // 可展开区域（仅当有 expandedHeight 时显示）
              flexibleSpace: _appBarConfig['expandedHeight'] != null
                  ? FlexibleSpaceBar(
                      title: Text(
                        '${_getCurrentConfigText()} ✨',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: _backgroundImage,
                      centerTitle: true,
                      titlePadding: const EdgeInsets.only(bottom: 16),
                    )
                  : null,
            ),

            // 配置说明卡片
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _themeColor.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _themeColor.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getTypeIcon(), color: _themeColor),
                        const SizedBox(width: 8),
                        Text(
                          '当前配置详情',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _themeColor.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildConfigItem('pinned', _appBarConfig['pinned']),
                    _buildConfigItem('floating', _appBarConfig['floating']),
                    _buildConfigItem('snap', _appBarConfig['snap']),
                    _buildConfigItem('expandedHeight', _appBarConfig['expandedHeight']?.toString() ?? 'null'),
                    const SizedBox(height: 12),
                    Text(
                      _getDetailedDescription(),
                      style: TextStyle(
                        fontSize: 14,
                        color: _themeColor.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 对比说明
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🆚 SliverAppBar vs SliverPersistentHeader',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• SliverAppBar：内置 Material Design 风格，开箱即用\n'
                      '• SliverPersistentHeader：完全自定义，需要实现 delegate\n'
                      '• SliverAppBar 内部实际使用了 SliverPersistentHeader',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 示例列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: _themeColor.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _themeColor.shade300),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getTypeIcon(), color: _themeColor),
                        const SizedBox(width: 8),
                        Text(
                          '列表项 ${index + 1} ${_getRandomEmoji()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _themeColor.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                childCount: 30,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentType.index,
          onTap: (index) => setState(() => _currentType = AppBarType.values[index]),
          selectedItemColor: _themeColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: '基础',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.expand_more),
              label: '可展开',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.push_pin),
              label: '固定',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: '浮动',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on),
              label: '快速响应',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showHelpDialog(context),
          backgroundColor: _themeColor,
          child: const Icon(Icons.help_outline, color: Colors.white),
        ),
      );

  /// 构建配置项显示
  Widget _buildConfigItem(String key, dynamic value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                '$key:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _themeColor.shade700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: value == true || (value != null && value != 'null')
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: value == true || (value != null && value != 'null')
                      ? Colors.green.shade800
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  /// 获取当前配置的简短文本
  String _getCurrentConfigText() {
    final config = _appBarConfig;
    final List<String> activeConfigs = [];
    
    if (config['pinned'] == true) activeConfigs.add('pinned');
    if (config['floating'] == true) activeConfigs.add('floating');
    if (config['snap'] == true) activeConfigs.add('snap');
    if (config['expandedHeight'] != null) activeConfigs.add('expandable');
    
    return activeConfigs.isEmpty ? 'basic' : activeConfigs.join(' + ');
  }

  /// 获取详细描述
  String _getDetailedDescription() {
    switch (_currentType) {
      case AppBarType.basic:
        return '最简单的应用栏配置，固定高度，不会随滚动改变。\n'
            '适用于简单的页面导航。';
      case AppBarType.expandable:
        return '具有可展开区域的应用栏，可以显示更多内容如背景图片。\n'
            '向下滚动时会完全消失，向上滚动到顶部时完全展开。';
      case AppBarType.pinned:
        return '滚动时会固定在屏幕顶部的应用栏。\n'
            '向下滚动时收缩到最小高度并保持可见。';
      case AppBarType.floating:
        return '浮动应用栏，向上滚动时立即出现。\n'
            '向下滚动时消失，向上滚动时立即重新出现。';
      case AppBarType.snap:
        return '结合浮动效果的快速响应应用栏。\n'
            '滚动停止时会自动完成展开或收缩动画。';
    }
  }

  /// 获取随机表情符号
  String _getRandomEmoji() {
    final emojis = ['(｡◕‿◕｡)', '♪(´▽｀)', '(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', '╰( ͡° ͜ʖ ͡° )つ──☆*:･ﾟ', '(≧∇≦)', '(◡ ‿ ◡ ✿)'];
    return emojis[math.Random().nextInt(emojis.length)];
  }

  /// 显示消息提示
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: _themeColor,
      ),
    );
  }

  /// 显示帮助对话框
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💡 SliverAppBar 使用指南'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎯 如何体验不同效果：'),
              SizedBox(height: 8),
              Text('1. 点击底部导航栏切换不同的应用栏类型'),
              Text('2. 上下滚动页面观察应用栏的行为变化'),
              Text('3. 注意观察配置详情卡片中的参数'),
              SizedBox(height: 16),
              Text('📋 五种类型对比：'),
              SizedBox(height: 8),
              Text('• 基础：固定高度，不变化'),
              Text('• 可展开：有展开区域，可显示背景'),
              Text('• 固定：滚动时固定在顶部'),
              Text('• 浮动：反向滚动时立即出现'),
              Text('• 快速响应：自动完成展开/收缩'),
              SizedBox(height: 16),
              Text('🔧 关键参数说明：'),
              SizedBox(height: 8),
              Text('• pinned: 是否固定在顶部'),
              Text('• floating: 是否浮动显示'),
              Text('• snap: 是否快速响应'),
              Text('• expandedHeight: 展开时的高度'),
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
