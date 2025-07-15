import 'package:flutter/material.dart';

void main() {
  runApp(NestedScrollViewLearningApp());
}

/// 🎓 NestedScrollView 学习应用
class NestedScrollViewLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'NestedScrollView 学习之旅',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LearningHomePage(),
      );
}

/// 🏠 学习主页 - 选择不同的示例
class LearningHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎓 NestedScrollView 学习之旅'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            '📚 第一步：基础概念',
            '了解什么是 NestedScrollView',
            Colors.green,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BasicConceptDemo(),
                )),
          ),
          _buildCard(
            context,
            '🔧 第二步：最简单的例子',
            '最基本的 NestedScrollView 用法',
            Colors.orange,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SimpleDemo(),
                )),
          ),
          _buildCard(
            context,
            '📱 第三步：加入 AppBar',
            '添加可折叠的 SliverAppBar',
            Colors.purple,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AppBarDemo(),
                )),
          ),
          _buildCard(
            context,
            '🏷️ 第四步：添加 TabBar',
            '实现 AppBar + TabBar + TabBarView',
            Colors.red,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TabBarDemo(),
                )),
          ),
          _buildCard(
            context,
            '📐 第五步：重叠处理',
            '学习 SliverOverlapAbsorber/Injector',
            Colors.teal,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OverlapDemo(),
                )),
          ),
          _buildCard(
            context,
            '🎨 第六步：完整示例',
            '所有功能组合的完整示例',
            Colors.indigo,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompleteDemo(),
                )),
          ),
        ],
      ),
    );
  }

  /// 构建学习卡片
  Widget _buildCard(BuildContext context, String title, String subtitle, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 📚 第一步：基础概念
// ============================================================================

/// 基础概念演示
class BasicConceptDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 基础概念'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _conceptCard(
              '🤔 什么是 NestedScrollView？',
              'NestedScrollView 是一个可以嵌套滚动视图的Widget，'
                  '它解决了多个滚动组件之间的协调问题。',
              Colors.blue,
            ),
            _conceptCard(
              '🎯 主要用途',
              '• 实现带有可折叠AppBar的页面\n'
                  '• TabBar + TabBarView 的组合\n'
                  '• 复杂的滚动联动效果',
              Colors.orange,
            ),
            _conceptCard(
              '🏗️ 基本结构',
              'NestedScrollView 分为两部分：\n'
                  '• headerSliverBuilder: 头部组件（如AppBar）\n'
                  '• body: 主体内容（如TabBarView）',
              Colors.purple,
            ),
            _conceptCard(
              '📐 重叠处理组件',
              '解决内容被遮挡的关键组件：\n'
                  '• SliverOverlapAbsorber: 在头部吸收重叠\n'
                  '• SliverOverlapInjector: 在内容区注入空间\n'
                  '• 必须配对使用，共享同一个 Handle',
              Colors.teal,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SimpleDemo(),
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('下一步：看看最简单的例子 →'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conceptCard(String title, String content, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 🔧 第二步：最简单的例子
// ============================================================================

/// 最简单的 NestedScrollView 示例
class SimpleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // 📋 头部构建器 - 返回头部组件列表
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 📌 简单的头部
            SliverToBoxAdapter(
              child: Container(height: 200, color: Colors.orange),
            ),
          ];
        },
        // 📄 主体内容
        body: Container(
          color: Colors.orange.shade50,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 30,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text('${index + 1}'),
                ),
                title: const Text('这是主体内容 (body)'),
                subtitle: Text('列表项 ${index + 1}'),
              ),
            ),
          ),
        ),
      ),

      // 返回按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}

// ============================================================================
// 📱 第三步：加入 AppBar
// ============================================================================

/// 带有 SliverAppBar 的示例
class AppBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 🎨 可折叠的 SliverAppBar
            SliverAppBar(
              title: const Text('📱 SliverAppBar 示例'),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              floating: true,
              pinned: true,
              snap: true,
              expandedHeight: 200.0,
              // 🎭 弹性空间 - 展开时显示的内容
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('可折叠标题'),
                background: Container(
                  color: Colors.purple,
                  child: Center(
                    child: Icon(Icons.star, size: 80, color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              // 根据内容滚动状态决定是否显示阴影
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: Container(
          color: Colors.purple.shade50,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 50,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 体验要点 ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      index == 0
                          ? '🔼 向上滚动：AppBar 会逐渐收起变小'
                          : index == 1
                              ? '🔽 向下滚动：AppBar 会重新出现并展开'
                              : '📱 这是一个可折叠 AppBar 的完美体验！',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 🏷️ 第四步：添加 TabBar
// ============================================================================

/// 带有 TabBar 的完整示例 - TabBar 在页面底部
class TabBarDemo extends StatefulWidget {
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 🎨 可折叠的 SliverAppBar
            SliverAppBar(
              title: const Text('📱 SliverAppBar 示例'),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              floating: true,
              pinned: true,
              snap: true,
              expandedHeight: 200.0,
              // 🎭 弹性空间 - 展开时显示的内容
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('可折叠标题'),
                background: Container(
                  color: Colors.purple,
                  child: Center(
                    child: Icon(Icons.star, size: 80, color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              // 根据内容滚动状态决定是否显示阴影
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },

        // 📄 TabBarView 作为主体
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent('🏠 首页', Colors.purple.shade50, '这是首页内容'),
            _buildTabContent('❤️ 收藏', Colors.pink.shade50, '这是收藏内容'),
            _buildTabContent('👤 我的', Colors.orange.shade50, '这是个人中心'),
          ],
        ),
      ),

      // 🔽 TabBar 在页面底部
      bottomNavigationBar: Container(
        color: Colors.purple,
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              const Tab(icon: Icon(Icons.home), text: '首页'),
              const Tab(icon: Icon(Icons.favorite), text: '收藏'),
              const Tab(icon: Icon(Icons.person), text: '我的'),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建 Tab 内容
  Widget _buildTabContent(String title, Color backgroundColor, String description) {
    return Container(
      color: backgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text('${index + 1}'),
            ),
            title: Text('$title - 项目 ${index + 1}'),
            subtitle: Text(description),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 📐 第五步：重叠处理详解
// ============================================================================

/// 重叠处理示例 - 详细展示 SliverOverlapAbsorber 和 SliverOverlapInjector 的用法
class OverlapDemo extends StatefulWidget {
  @override
  _OverlapDemoState createState() => _OverlapDemoState();
}

class _OverlapDemoState extends State<OverlapDemo> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showOverlapComponents = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true, // 开启浮动效果，更容易看到重叠问题

        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 🎯 关键点：使用 SliverOverlapAbsorber 包装有重叠的组件
            _showOverlapComponents
                ? SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: SliverAppBar(
                      title: const Text('📐 重叠处理示例'),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      floating: true,
                      pinned: true,
                      snap: true,
                      expandedHeight: 200.0,
                      forceElevated: innerBoxIsScrolled,
                      flexibleSpace: FlexibleSpaceBar(
                        title: const Text('重叠问题解决'),
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal.shade300, Colors.teal.shade700],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.layers,
                              size: 80,
                              color: Colors.white30,
                            ),
                          ),
                        ),
                      ),
                      bottom: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        indicatorColor: Colors.white,
                        tabs: const [
                          Tab(icon: Icon(Icons.check_circle), text: '正确示例'),
                          Tab(icon: Icon(Icons.error), text: '错误对比'),
                        ],
                      ),
                    ),
                  )
                : // 🚫 不使用 SliverOverlapAbsorber 的错误示例
                SliverOverlapAbsorber(
                    // 🔴 注意：这里还是要用 SliverOverlapAbsorber，否则 TabBar 不会显示
                    // 区别在于内容区域是否使用 SliverOverlapInjector
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: SliverAppBar(
                      title: const Text('📐 重叠处理示例'),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      floating: true,
                      pinned: true,
                      snap: true,
                      expandedHeight: 200.0,
                      forceElevated: innerBoxIsScrolled,
                      flexibleSpace: const FlexibleSpaceBar(
                        title: Text('❌ 没有重叠处理'),
                        background: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.warning,
                              size: 80,
                              color: Colors.white30,
                            ),
                          ),
                        ),
                      ),
                      bottom: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        indicatorColor: Colors.white,
                        tabs: const [
                          Tab(icon: Icon(Icons.check_circle), text: '正确示例'),
                          Tab(icon: Icon(Icons.error), text: '错误对比'),
                        ],
                      ),
                    ),
                  ),

            // 📊 控制面板
            SliverToBoxAdapter(
              child: Container(
                color: Colors.teal.shade50,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _showOverlapComponents ? Icons.check_circle : Icons.error,
                          color: _showOverlapComponents ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                                                   child: Text(
                           _showOverlapComponents 
                               ? '✅ 正在使用 SliverOverlapInjector 处理重叠'
                               : '❌ 未在内容区使用 SliverOverlapInjector',
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: _showOverlapComponents ? Colors.green : Colors.red,
                           ),
                         ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showOverlapComponents = !_showOverlapComponents;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_showOverlapComponents ? '🚫 禁用 SliverOverlapInjector' : '✅ 启用 SliverOverlapInjector'),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },

        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCorrectExample(),
            _buildErrorExample(),
          ],
        ),
      ),
    );
  }

  /// 构建正确示例 - 使用 SliverOverlapInjector
  Widget _buildCorrectExample() {
    return Container(
      color: Colors.green.shade50,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: [
              // 🎯 关键点：使用 SliverOverlapInjector 注入重叠区域
              if (_showOverlapComponents)
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),

              // 说明卡片
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text(
                            '✅ 正确示例',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '🔧 使用了 SliverOverlapInjector：\n'
                        '• 内容不会被 AppBar 遮挡\n'
                        '• 滚动时对齐正确\n'
                        '• 用户体验良好',
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              // 列表内容
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('正确对齐的内容 ${index + 1}'),
                      subtitle: const Text('这些内容不会被 AppBar 遮挡'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  ),
                  childCount: 30,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建错误示例 - 不使用 SliverOverlapInjector
  Widget _buildErrorExample() {
    return Container(
      color: Colors.red.shade50,
      child: CustomScrollView(
        slivers: [
          // 🚫 故意不使用 SliverOverlapInjector，展示问题

          // 说明卡片
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        '❌ 错误示例',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🚫 没有使用 SliverOverlapInjector：\n'
                    '• 内容可能被 AppBar 遮挡\n'
                    '• 滚动时对齐有问题\n'
                    '• 用户体验差',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          // 列表内容（可能被遮挡）
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('可能被遮挡的内容 ${index + 1}'),
                  subtitle: const Text('没有正确处理重叠问题'),
                  trailing: const Icon(Icons.error, color: Colors.red),
                ),
              ),
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 🎨 第六步：完整示例
// ============================================================================

/// 最完整的 NestedScrollView 示例
class CompleteDemo extends StatefulWidget {
  @override
  _CompleteDemoState createState() => _CompleteDemoState();
}

class _CompleteDemoState extends State<CompleteDemo> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // 🎈 开启头部浮动效果
        floatHeaderSlivers: true,

        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 🎨 主 AppBar
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('🎨 完整示例'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                floating: true,
                pinned: true,
                snap: true,
                expandedHeight: 200.0,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('完整功能演示'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade300, Colors.indigo.shade700],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.widgets,
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 📊 额外的信息栏
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('📊', '统计', '1,234'),
                    _buildStatItem('💰', '收入', '¥5,678'),
                    _buildStatItem('⭐', '评分', '4.8'),
                  ],
                ),
              ),
            ),

            // 🏷️ TabBar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.indigo,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.indigo,
                  tabs: [
                    const Tab(icon: Icon(Icons.list), text: '列表'),
                    const Tab(icon: Icon(Icons.grid_view), text: '网格'),
                    const Tab(icon: Icon(Icons.settings), text: '设置'),
                  ],
                ),
              ),
            ),
          ];
        },

        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAdvancedTabContent('📋 高级列表', Colors.indigo.shade50),
            _buildGridTabContent('🔲 网格视图', Colors.blue.shade50),
            _buildSettingsTabContent('⚙️ 设置页面', Colors.grey.shade50),
          ],
        ),
      ),
    );
  }

  /// 构建统计项目
  Widget _buildStatItem(String icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// 高级列表内容
  Widget _buildAdvancedTabContent(String title, Color backgroundColor) {
    return Container(
      color: backgroundColor,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: [
              // 📌 重叠注入器
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),

              // 📄 列表内容
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    elevation: 2,
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('可展开项目 ${index + 1}'),
                      subtitle: const Text('点击展开查看详细信息'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            '这是展开后的详细内容。NestedScrollView 让滚动变得如此流畅！',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  childCount: 20,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 网格内容
  Widget _buildGridTabContent(String title, Color backgroundColor) {
    return Container(
      color: backgroundColor,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Card(
                    margin: const EdgeInsets.all(4),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo,
                            size: 40,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          Text('项目 ${index + 1}'),
                        ],
                      ),
                    ),
                  ),
                  childCount: 20,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 设置内容
  Widget _buildSettingsTabContent(String title, Color backgroundColor) {
    return Container(
      color: backgroundColor,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildSettingSection('🔔 通知设置', [
                    _buildSettingItem('推送通知', true),
                    _buildSettingItem('声音提醒', false),
                    _buildSettingItem('震动反馈', true),
                  ]),
                  _buildSettingSection('🎨 显示设置', [
                    _buildSettingItem('深色模式', false),
                    _buildSettingItem('大字体', false),
                    _buildSettingItem('高对比度', false),
                  ]),
                  _buildSettingSection('🔐 隐私设置', [
                    _buildSettingItem('位置服务', true),
                    _buildSettingItem('数据统计', true),
                    _buildSettingItem('广告个性化', false),
                  ]),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (bool newValue) {
        // 设置变更逻辑
      },
      activeColor: Colors.indigo,
    );
  }
}

/// TabBar 代理类
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => tabBar != oldDelegate.tabBar;
}
