import 'package:flutter/material.dart';

class FilterMenuStack extends StatefulWidget {
  final List<MenuItemConfig> configs; // 菜单项配置
  final Widget content; // 内容

  const FilterMenuStack(this.configs, {super.key, required this.content});

  @override
  State<StatefulWidget> createState() => FilterMenuStackState();
}

class FilterMenuStackState extends State<FilterMenuStack> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(-1); // 当前展开的索引
  final ValueNotifier<bool> _isShow = ValueNotifier<bool>(false); // 弹窗是否展开
  late FilterMenuController _controller; // 控制器，暴露给外部控制菜单的显示和隐藏

  @override
  void initState() {
    super.initState();
    _controller = FilterMenuController(this);
  }

  // 关闭弹窗
  void closeMenu() {
    _isShow.value = false;
    _currentIndex.value = -1;
  }

  // 显示弹窗
  void showMenu(int index) {
    _isShow.value = true;
    _currentIndex.value = index;
  }

  // 设置选中状态
  void setSelect(int index, bool isSelect) {
    widget.configs[index].isSelected = isSelect;
  }

  // 设置是否可点击
  void setClickable(int index, bool isClickable) {
    widget.configs[index].isClickable = isClickable;
  }

  // 设置标题
  void setTitle(int index, String title) {
    widget.configs[index].title = title;
  }

  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < widget.configs.length; i++) _createHeaderItem(i),
            ],
          ),
        ),
        Expanded(
            child: Stack(
          children: [
            widget.content,
            ValueListenableBuilder<bool>(
              valueListenable: _isShow,
              builder: (context, isShow, child) {
                return isShow
                    ? ValueListenableBuilder<int>(
                        valueListenable: _currentIndex,
                        builder: (context, currentIndex, child) {
                          return _createMenuDialog(widget.configs[currentIndex].buildPopMenu(_controller));
                        },
                      )
                    : Container();
              },
            ),
          ],
        ))
      ]));

  // 生成菜单项
  Widget _createHeaderItem(index) {
    final String title = widget.configs[index].title;
    return GestureDetector(
      onTap: () {
        if (widget.configs[index].isClickable) {
          if (_currentIndex.value == index) {
            closeMenu();
          } else {
            showMenu(index);
          }
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
                  (_currentIndex.value == index && _isShow.value)
                      ? const Icon(Icons.arrow_drop_up, color: Colors.red, size: 20)
                      : const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
                ],
              )),
        ),
      ),
    );
  }

  // 生成菜单弹窗
  Widget _createMenuDialog(Widget popMenu) {
    if (_currentIndex.value == -1) {
      return Container();
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            ConstrainedBox(
                constraints: BoxConstraints.loose(Size(constraints.maxWidth, constraints.maxHeight - 100)),
                child: popMenu),
            Expanded(
                child: GestureDetector(
              onTap: () => closeMenu(),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ))
          ],
        );
      });
    }
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _isShow.dispose();
    super.dispose();
  }
}

// 菜单项配置
class MenuItemConfig {
  String title; // 菜单标题
  bool isSelected; // 是否选中
  bool isClickable; // 是否可点击
  final Widget Function(FilterMenuController controller) buildPopMenu; // 对应构建的菜单弹窗Widget的方法

  MenuItemConfig(this.title, this.buildPopMenu, {this.isSelected = false, this.isClickable = true});
}

// 控制器 (暴露给外部，方便调用菜单组件)
class FilterMenuController {
  final FilterMenuStackState _state;

  FilterMenuController(this._state);

  void closeMenu() => _state.closeMenu();

  void setSelect(int index, bool isSelect) => _state.setSelect(index, isSelect);

  void setClickable(int index, bool isClickable) => _state.setClickable(index, isClickable);

  void setTitle(int index, String title) => _state.setTitle(index, title);
}
