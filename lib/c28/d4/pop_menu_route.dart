import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PopMenuRoute<T> extends ModalRoute<T> {
  final GlobalKey anchorKey; // 触发弹窗的Widget
  final WidgetBuilder popMenu; // 跟随弹窗Widget的构建方法

  PopMenuRoute(this.anchorKey, this.popMenu);

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  // 💡 弹出菜单的构建方法
  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Size size = Size.zero;
    late Offset offset;
    RenderObject? renderObject = anchorKey.currentContext!.findRenderObject();
    if (renderObject != null && renderObject is RenderBox) {
      size = renderObject.paintBounds.size;
      offset = renderObject.localToGlobal(Offset.zero);
    }
    offset = Offset(0, offset.dy).translate(0, size.height);
    return Builder(builder: (BuildContext context) {
      return CustomSingleChildLayout(
          delegate: _PopMenuRouteLayout(offset),
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return Column(children: [
              // 💡 改变子组件尺寸的动画，通常用于在显示或隐藏组件时提供平滑的过渡效果。
              ColoredBox(
                  color: Colors.white,
                  child: SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut, // 立方贝塞尔曲线，开始和结束时缓慢，中间加速。
                    ),
                    axisAlignment: -1.0, // 子组件在动画过程的对齐方式，-1.0表示与起点对齐
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: constraints.maxHeight - 100),
                      child: popMenu(context),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  // 💡 透明度动画，通常用于在显示或隐藏组件时提供平滑的过渡效果。
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ]);
          }));
    });
  }

  @override
  String? get barrierLabel => '关闭弹出菜单';

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

Future<T?> showPopMenu<T>(GlobalKey anchorKey, WidgetBuilder popMenu) =>
    Navigator.of(anchorKey.currentContext!).push(PopMenuRoute(anchorKey, popMenu));

class _PopMenuRouteLayout extends SingleChildLayoutDelegate {
  final Offset offset;

  _PopMenuRouteLayout(this.offset);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // 定义对子控件的约束
    return BoxConstraints(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight - offset.dy,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return offset;
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    // 是否需要重新布局
    return oldDelegate is _PopMenuRouteLayout && oldDelegate.offset != offset;
  }
}

class _PopMenu extends SingleChildRenderObjectWidget {
  const _PopMenu({required this.onLayout, required super.child});

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _PopMenuRenderObject(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _PopMenuRenderObject renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _PopMenuRenderObject extends RenderProxyBox {
  _PopMenuRenderObject(this.onLayout);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}
