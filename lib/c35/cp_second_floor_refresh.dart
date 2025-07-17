import 'package:flutter/material.dart';

/// 刷新状态枚举
enum CpRefreshState {
  idle, // 空闲状态
  pulling, // 拖拽中
  canRefresh, // 可以刷新
  refreshing, // 刷新中
  refreshed, // 刷新完成
  canSecondFloor, // 可以进入二楼
  secondFloor, // 二楼状态
}

/// 加载状态枚举
enum CpLoadState {
  idle, // 空闲状态
  pulling, // 拖拽中
  canLoad, // 可以加载
  loading, // 加载中
  loaded, // 加载完成
  noMore, // 没有更多数据
}

class CpSecondFloorRefresh extends StatefulWidget {
  final CpRefreshContainer controller;
  final bool enableRefresh; // 是否启用刷新
  final bool enableLoadMore; // 是否启用加载更多
  final bool enableSecondFloor; // 是否启用二楼
  final double refreshHeight; // 刷新指示器高度
  final double loadHeight; // 加载指示器高度
  final double secondFloorHeight; // 二楼触发高度
  final Function? onRefresh; // 刷新回调
  final Function? onLoadMore; // 加载更多回调
  final Function? onSecondFloor; // 进入二楼回调
  const CpSecondFloorRefresh(
      {super.key,
      required this.controller,
      this.enableRefresh = true,
      this.enableLoadMore = true,
      this.enableSecondFloor = true,
      this.refreshHeight = 60,
      this.loadHeight = 60,
      this.secondFloorHeight = 150,
      this.onRefresh,
      this.onLoadMore,
      this.onSecondFloor});

  @override
  State<CpSecondFloorRefresh> createState() => CpSecondFloorRefreshState();
}

class CpSecondFloorRefreshState extends State<CpSecondFloorRefresh> {
  /// 当前刷新状态
  CpRefreshState _refreshState = CpRefreshState.idle;

  /// 当前加载状态
  CpLoadState _loadState = CpLoadState.idle;

  /// 是否正在拖拽
  bool _isDragging = false;

  /// 拖拽偏移量
  double _dragOffset = 0.0;

  /// 是否在顶部
  bool _isAtTop = false;

  /// 是否在底部
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void dispose() {
    widget.controller._detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSecondFloor = _refreshState == CpRefreshState.secondFloor;
    // 如果是进入二楼，需重置拖拽偏移量
    if (isSecondFloor) _dragOffset = 0.0;
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部刷新指示器
            if (!isSecondFloor && _refreshState != CpRefreshState.idle)
              Container(
                height: 60, 
                color: Colors.red,
                child: Text(
              _refreshState == CpRefreshState.pulling
                ? '下拉刷新'
                : _refreshState == CpRefreshState.canRefresh
                  ? '放开刷新'
                  : _refreshState == CpRefreshState.refreshing
                    ? '刷新中'
                    : '进入二楼')
              ),
            // 内容区域
            Expanded(
              child: isSecondFloor
                  ? Container(
                      color: Colors.blue,
                      child: Text('二楼区域'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 增强for循环，生成50个item
                          ...List.generate(
                              50,
                              (index) => Container(
                                    height: 20,
                                    color: Colors.green,
                                    child: Text('item $index'),
                                  )),
                        ],
                      ),
                    ),
            ),
            // 底部加载指示器
            if (!isSecondFloor && _loadState != CpLoadState.idle)
              Container(
                height: 60,
                color: Colors.yellow,
                child: Text(
                  _loadState == CpLoadState.pulling
                      ? '上拉加载更多'
                      : _loadState == CpLoadState.canLoad
                          ? '放开加载更多'
                          : _loadState == CpLoadState.loading
                              ? '加载中'
                              : _loadState == CpLoadState.loaded
                                  ? '加载完成'
                                  : '没有更多数据',
                ),
              ),
          ],
        ));
  }

  // 处理滚动通知
  bool _handleScrollNotification(ScrollNotification notification) {
    // 检查是否在顶部或底部
    _isAtTop = notification.metrics.extentBefore == 0.0;
    _isAtBottom = notification.metrics.extentAfter == 0.0;
    // 三种通知类型 (滚动开始、滚动结束、过度滚动)
    if (notification is ScrollStartNotification) {
      return _handleScrollStart(notification);
    } else if (notification is ScrollEndNotification) {
      return _handleScrollEnd(notification);
    } else if (notification is OverscrollNotification) {
      return _handleOverscroll(notification);
    }
    return false;
  }

  // 处理滚动开始
  bool _handleScrollStart(ScrollStartNotification notification) {
    if (notification.dragDetails != null) _isDragging = true;
    return false;
  }

  // 处理过度滚动 - 增强此方法来完成所有拖拽偏移量的更新
  bool _handleOverscroll(OverscrollNotification notification) {
    if (!_isDragging) return false;
    // 下拉过度滚动 (负数，减负数=加绝对值)
    if (notification.overscroll < 0 && widget.enableRefresh && _isAtTop) {
      _dragOffset -= notification.overscroll;
      _updateRefreshState();
      return true;
    }
    // 上拉过度滚动
    if (notification.overscroll > 0 && widget.enableLoadMore && _isAtBottom) {
      _dragOffset += notification.overscroll;
      _updateLoadState();
      return true;
    }
    return false;
  }

  // 处理滚动结束
  bool _handleScrollEnd(ScrollEndNotification notification) {
    _isDragging = false;
    // 处理刷新结束
    if (_refreshState == CpRefreshState.canRefresh) {
      // 如果可以刷新，则触发刷新
      _triggerRefresh();
    } else if (_refreshState == CpRefreshState.canSecondFloor) {
      // 如果可以进入二楼，则触发进入二楼
      _triggerSecondFloor();
    } else if (_refreshState != CpRefreshState.idle) {
      // 如果不在空闲状态，则重置刷新
      _resetRefresh();
    }
    // 处理加载结束
    if (_loadState == CpLoadState.canLoad) {
      // 如果可以加载，则触发加载更多
      _triggerLoadMore();
    } else if (_loadState != CpLoadState.idle) {
      // 如果不在空闲状态，则重置加载
      _resetLoad();
    }
    return false;
  }

  // 更新刷新状态
  void _updateRefreshState() {
    if (_refreshState == CpRefreshState.refreshing) return;
    if (_dragOffset <= 0) {
      // 如果拖拽偏移量小于0，则处于空闲状态
      _refreshState = CpRefreshState.idle;
    } else if (_dragOffset < widget.refreshHeight) {
      // 如果拖拽偏移量小于刷新高度，则处于拖拽状态
      _refreshState = CpRefreshState.pulling;
    } else if (_dragOffset >= widget.secondFloorHeight && widget.enableSecondFloor && _isAtTop) {
      // 二楼触发条件：启用二楼 && 偏移量大于二楼触发高度 && 处于顶部
      _refreshState = CpRefreshState.canSecondFloor;
    } else {
      // 如果滑动距离大于刷新高度，则处于可以刷新状态
      if(_dragOffset >= widget.refreshHeight) {
        _refreshState = CpRefreshState.canRefresh;
      } else {
        _refreshState = CpRefreshState.idle;
      }
    }
    setState(() {});
  }

  // 更新加载状态
  void _updateLoadState() {
    if (_loadState == CpLoadState.loading) return;
    if (_dragOffset <= 0) {
      // 如果拖拽偏移量小于0，则处于空闲状态
      _loadState = CpLoadState.idle;
    } else if (_dragOffset < widget.loadHeight) {
      // 如果拖拽偏移量小于加载高度，则处于拖拽状态
      _loadState = CpLoadState.pulling;
    } else {
      // 如果拖拽偏移量大于加载高度，则处于可以加载状态
      _loadState = CpLoadState.canLoad;
    }
    setState(() {});
  }

  // 触发刷新
  Future<void> _triggerRefresh() async {
    if (widget.onRefresh == null) return;
    setState(() {
      _refreshState = CpRefreshState.refreshing;
    });
    widget.onRefresh!();
    setState(() {
      _refreshState = CpRefreshState.refreshed;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    _resetRefresh();
  }

  // 触发二楼
  Future<void> _triggerSecondFloor() async {
    if (widget.onSecondFloor == null) return;
    setState(() {
      _refreshState = CpRefreshState.secondFloor;
    });
    widget.onSecondFloor!();
  }

  // 触发加载更多
  Future<void> _triggerLoadMore() async {
    if (widget.onLoadMore == null) return;
    setState(() {
      _loadState = CpLoadState.loading;
    });
    widget.onLoadMore!();
    setState(() {
      _loadState = CpLoadState.loaded;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    _resetLoad();
  }

    // 重置刷新
  void _resetRefresh() {
    setState(() {
      _refreshState = CpRefreshState.idle;
      _dragOffset = 0.0;
    });
  }

  // 重置加载
  void _resetLoad() {
    setState(() {
      _loadState = CpLoadState.idle;
      _dragOffset = 0.0;
    });
  }
}

/// 刷新控制器
class CpRefreshContainer {
  CpSecondFloorRefreshState? state;

  void _attach(CpSecondFloorRefreshState state) {
    this.state = state;
  }

  void _detach(CpSecondFloorRefreshState state) {
    if (this.state == state) this.state = null;
  }

  void showSecondFloor() {
    state?._updateRefreshState();
  }

  void hideSecondFloor() {
    state?._updateRefreshState();
  }
}
