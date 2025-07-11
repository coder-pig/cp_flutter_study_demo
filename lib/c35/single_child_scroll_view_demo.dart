import 'package:flutter/material.dart';

/// 滚动组件类型枚举
enum ScrollType { singleChildScrollView, listViewBuilder }

/// SingleChildScrollView 使用示例
class SingleChildScrollViewDemo extends StatefulWidget {
  const SingleChildScrollViewDemo({super.key});

  @override
  State<SingleChildScrollViewDemo> createState() => _SingleChildScrollViewDemoState();
}

class _SingleChildScrollViewDemoState extends State<SingleChildScrollViewDemo> {
  final ScrollController _scrollController = ScrollController();
  
  // 滚动物理效果状态
  ScrollPhysics _currentPhysics = const BouncingScrollPhysics();
  ScrollViewKeyboardDismissBehavior _keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag;
  
  // 物理效果选项
  final List<ScrollPhysics> _physicsOptions = [
    const BouncingScrollPhysics(),
    const ClampingScrollPhysics(),
  ];
  
  // 物理效果名称
  final List<String> _physicsNames = [
    'BouncingScrollPhysics',
    'ClampingScrollPhysics',
  ];
  
  // 键盘消失行为选项
  final List<ScrollViewKeyboardDismissBehavior> _keyboardBehaviorOptions = [
    ScrollViewKeyboardDismissBehavior.onDrag,
    ScrollViewKeyboardDismissBehavior.manual,
  ];
  
  // 键盘消失行为名称
  final List<String> _keyboardBehaviorNames = [
    'onDrag',
    'manual',
  ];


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SingleChildScrollView 示例'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 控制按钮区域
          _buildControlButtons(),
          // 分割线
          const Divider(),
          // 滚动内容区域
          Expanded(
            child: _buildScrollableContent(),
          ),
        ],
      ),
    );
  }

  /// 构建控制按钮区域
  Widget _buildControlButtons() => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 滚动控制按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _scrollToTop(),
                  child: const Text('滚动到顶部'),
                ),
                ElevatedButton(
                  onPressed: () => _scrollToBottom(),
                  child: const Text('滚动到底部'),
                ),
                ElevatedButton(
                  onPressed: () => _scrollToPosition(500),
                  child: const Text('滚动到中间'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 滚动物理效果切换
            Row(
              children: [
                const Text('滚动物理: '),
                Expanded(
                  child: DropdownButton<ScrollPhysics>(
                    value: _currentPhysics,
                    isExpanded: true,
                    items: _physicsOptions.asMap().entries.map((entry) {
                      return DropdownMenuItem<ScrollPhysics>(
                        value: entry.value,
                        child: Text(_physicsNames[entry.key]),
                      );
                    }).toList(),
                    onChanged: (physics) {
                      if (physics != null) {
                        setState(() => _currentPhysics = physics);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // 键盘消失行为切换
            Row(
              children: [
                const Text('键盘消失: '),
                Expanded(
                  child: DropdownButton<ScrollViewKeyboardDismissBehavior>(
                    value: _keyboardDismissBehavior,
                    isExpanded: true,
                    items: _keyboardBehaviorOptions.asMap().entries.map((entry) {
                      return DropdownMenuItem<ScrollViewKeyboardDismissBehavior>(
                        value: entry.value,
                        child: Text(_keyboardBehaviorNames[entry.key]),
                      );
                    }).toList(),
                    onChanged: (behavior) {
                      if (behavior != null) {
                        setState(() => _keyboardDismissBehavior = behavior);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  /// 构建可滚动内容
  Widget _buildScrollableContent() => SingleChildScrollView(
        // 滚动控制器
        controller: _scrollController,
        // 滚动方向：垂直滚动
        scrollDirection: Axis.vertical,
        // 内边距
        padding: const EdgeInsets.all(16),
        // 滚动物理效果：动态切换
        physics: _currentPhysics,
        // 键盘消失行为：动态切换
        keyboardDismissBehavior: _keyboardDismissBehavior,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 表单示例
            _buildFormExample(),
            const SizedBox(height: 32),
            // 长列表示例
            _buildLongListExample(),
            const SizedBox(height: 32),
            // 水平滚动示例
            _buildHorizontalScrollExample(),
          ],
        ),
      );

  /// 构建章节标题
  Widget _buildSectionTitle(String title) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      );

  /// 构建表单示例
  Widget _buildFormExample() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('表单示例'),
              const TextField(
                decoration: InputDecoration(labelText: '用户名'),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showMessage('表单提交'),
                  child: const Text('提交'),
                ),
              ),
            ],
          ),
        ),
      );

  /// 构建长列表示例
  Widget _buildLongListExample() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('长内容示例'),
              ...List.generate(
                15,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('这是第 ${index + 1} 个内容项 (´∀｀)'),
                ),
              ),
            ],
          ),
        ),
      );

  /// 构建水平滚动示例
  Widget _buildHorizontalScrollExample() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('水平滚动示例'),
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      10,
                      (index) => Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.primaries[index % Colors.primaries.length],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  /// 滚动到顶部
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// 滚动到底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 滚动到指定位置
  void _scrollToPosition(double position) {
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// 显示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// GridView构造函数参数中文注释参考：
/// 
/// super.key, // Widget的唯一标识符
/// super.scrollDirection, // 滚动方向，水平或垂直
/// super.reverse, // 是否反向滚动
/// super.controller, // 滚动控制器，用于控制滚动位置
/// super.primary, // 是否为主要滚动视图
/// super.physics, // 滚动物理效果，如回弹、惯性等
/// super.shrinkWrap, // 是否根据内容收缩包装
/// super.padding, // 内边距
/// required this.gridDelegate, // 网格布局代理，控制网格的排列方式
/// bool addAutomaticKeepAlives = true, // 是否自动保持子组件状态
/// bool addRepaintBoundaries = true, // 是否添加重绘边界
/// bool addSemanticIndexes = true, // 是否添加语义索引
/// super.cacheExtent, // 缓存区域大小
/// List<Widget> children = const <Widget>[], // 子组件列表
/// int? semanticChildCount, // 语义子元素数量
/// super.dragStartBehavior, // 拖拽开始行为
/// super.clipBehavior, // 裁剪行为
/// super.keyboardDismissBehavior, // 键盘消失行为
/// super.restorationId, // 状态恢复标识符
/// super.hitTestBehavior, // 点击测试行为

/// 主函数
void main(List<String> args) {
  runApp(const SingleChildScrollViewDemo());
}
