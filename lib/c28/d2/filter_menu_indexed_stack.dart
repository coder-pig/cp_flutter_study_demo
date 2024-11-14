import 'package:flutter/material.dart';

class FilterMenuIndexedStack extends StatefulWidget {
  final List<MenuItemConfig> configs; // 菜单项配置
  final List<Widget> popMenus; // 子控件
  final Widget content; // 内容
  final FilterMenuController menuController; // 控制器

  const FilterMenuIndexedStack(this.configs,
      {super.key, required this.popMenus, required this.content, required this.menuController});

  @override
  State<StatefulWidget> createState() => _FilterMenuIndexedStackState();
}

class _FilterMenuIndexedStackState extends State<FilterMenuIndexedStack> {
  int _currentIndex = -1; // 当前展开的索引
  int _stackIndex = 0; // IndexedStack中当前显示子控件的索引

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < widget.configs.length; i++) _createHeaderItem(i),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _stackIndex,
                children: [
                  // 💡 将 content 和 popMenus 放在同一个 IndexedStack 中，index 为 0 时显示 content，其它值时显示对应 popMenu
                  LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: widget.content,
                    );
                  }),
                  ...widget.popMenus.map((menu) => _createPopMenu(menu)).toList()
                ],
              ),
            )
          ],
        ));
  }

  // 生成菜单项
  Widget _createHeaderItem(index) {
    final String title = widget.configs[index].title;
    return GestureDetector(
      onTap: () {
        if (widget.configs[index].isClickable) {
          setState(() {
            if (_currentIndex == index) {
              _currentIndex = -1;
              _stackIndex = 0;
              widget.menuController.onMenuClick(_currentIndex, 0);
            } else {
              _currentIndex = index;
              _stackIndex = index + 1;
              widget.menuController.onMenuClick(_currentIndex, _stackIndex);
            }
          });
        }
      },
      child: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (widget.configs[index].isSelected)
                      ? Text(title, style: const TextStyle(color: Colors.red, fontSize: 14))
                      : Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  (_currentIndex == index)
                      ? const Icon(Icons.arrow_drop_up, color: Colors.red, size: 20)
                      : const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
                ],
              )),
        ),
      ),
    );
  }

  // 生成菜单弹窗
  Widget _createPopMenu(menu) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Column(
          children: [
            // 💡 添加约束，限制菜单最大高度
            ConstrainedBox(constraints: BoxConstraints(maxHeight: constraints.maxHeight - 100), child: menu),
            // 💡 剩余空间填充黑色半透明背景，点击关闭菜单
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = -1;
                      _stackIndex = 0;
                      widget.menuController.onMenuClick(_currentIndex, 0);
                    });
                  },
                  child: Container(color: Colors.black.withOpacity(0.5))),
            )
          ],
        ),
      );
    });
  }
}

// 菜单项配置
class MenuItemConfig {
  final String title; // 菜单标题
  bool isSelected; // 是否选中
  bool isClickable; // 是否可点击

  MenuItemConfig(this.title, {this.isSelected = false, this.isClickable = true});
}

// 控制器
class FilterMenuController {
  // 菜单点击回调，参数依次为：当前点击的菜单索引、当前显示的 IndexedStack 子控件索引
  Function(int currentIndex, int statckIndex) onMenuClick;

  FilterMenuController(this.onMenuClick);
}
