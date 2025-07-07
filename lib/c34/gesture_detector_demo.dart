import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// GestureDecotor-手势检测器使用代码示例
void main() {
  runApp(const GestureDetectorDemoApp());
}

class GestureDetectorDemoApp extends StatelessWidget {
  const GestureDetectorDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestureDetector手势探测器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GestureDetectorDemo(),
    );
  }
}

class GestureDetectorDemo extends StatefulWidget {
  const GestureDetectorDemo({super.key});

  @override
  State<GestureDetectorDemo> createState() => _GestureDetectorDemoState();
}

class _GestureDetectorDemoState extends State<GestureDetectorDemo> {
  // 使用 ValueNotifier 管理状态
  final ValueNotifier<List<String>> _logs = ValueNotifier<List<String>>([]);
  final ValueNotifier<Offset> _panPosition = ValueNotifier<Offset>(const Offset(200, 150));
  final ValueNotifier<double> _scale = ValueNotifier<double>(1.0);
  final ValueNotifier<double> _horizontalPosition = ValueNotifier<double>(0);
  final ValueNotifier<double> _verticalPosition = ValueNotifier<double>(0);

  @override
  void dispose() {
    _logs.dispose();
    _panPosition.dispose();
    _scale.dispose();
    _horizontalPosition.dispose();
    _verticalPosition.dispose();
    super.dispose();
  }

  // 添加日志
  void _addLog(String message) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    final logMessage = '$timeStr: $message';
    
    // 同时打印到控制台，方便调试
    print(logMessage);
    
    final newLogs = List<String>.from(_logs.value);
    newLogs.insert(0, logMessage);
    if (newLogs.length > 100) {
      newLogs.removeLast();
    }
    _logs.value = newLogs;
  }

  // 清空日志
  void _clearLogs() {
    _logs.value = [];
  }

  @override
  Widget build(BuildContext context) {
    // 计算拖拽区域的初始位置
    if (_panPosition.value == const Offset(200, 150)) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      _panPosition.value = Offset(
        screenWidth - 140,
        screenHeight * 0.6 - 100,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GestureDetector 手势演示'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLogs,
            tooltip: '清空日志',
          ),
        ],
      ),
      body: Column(
        children: [
          // 手势区域
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: Stack(
                children: [
                  // 单击、双击、长按演示区域
                  const Positioned(
                    left: 20,
                    top: 20,
                    child: _TapGestureArea(),
                  ),

                  // 拖拽演示区域
                  ValueListenableBuilder<Offset>(
                    valueListenable: _panPosition,
                    builder: (context, position, child) {
                      return Positioned(
                        left: position.dx,
                        top: position.dy,
                        child: _PanGestureArea(
                          onPositionChanged: _updatePanPosition,
                          onLog: _addLog,
                        ),
                      );
                    },
                  ),

                  // 缩放演示区域
                  Center(
                    child: ValueListenableBuilder<double>(
                      valueListenable: _scale,
                      builder: (context, scale, child) {
                        return _ScaleGestureArea(
                          scale: scale,
                          onScaleChanged: (newScale) => _scale.value = newScale,
                          onLog: _addLog,
                        );
                      },
                    ),
                  ),

                  // 水平拖拽演示区域
                  ValueListenableBuilder<double>(
                    valueListenable: _horizontalPosition,
                    builder: (context, position, child) {
                      return Positioned(
                        left: 20 + position,
                        bottom: 100,
                        child: _HorizontalDragArea(
                          onPositionChanged: _updateHorizontalPosition,
                          onLog: _addLog,
                        ),
                      );
                    },
                  ),

                  // 垂直拖拽演示区域
                  ValueListenableBuilder<double>(
                    valueListenable: _verticalPosition,
                    builder: (context, position, child) {
                      return Positioned(
                        right: 100,
                        top: 20 + position,
                        child: _VerticalDragArea(
                          onPositionChanged: _updateVerticalPosition,
                          onLog: _addLog,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 日志显示区域
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.black87,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Text(
                          '手势日志 (最新100条)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _clearLogs,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: _logs,
                      builder: (context, logs, child) {
                        return ListView.builder(
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              child: Text(
                                logs[index],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePanPosition(Offset delta) {
    final currentPosition = _panPosition.value;
    final newPosition = currentPosition + delta;

    // 边界检查
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // clamp() 方法用于将一个值限制在指定的范围内。
    // 如果值小于最小值，则返回最小值；如果值大于最大值，则返回最大值。
    final clampedPosition = Offset(
      newPosition.dx.clamp(0, screenWidth - 120),
      newPosition.dy.clamp(0, screenHeight * 0.6 - 80),
    );

    _panPosition.value = clampedPosition;
  }

  void _updateHorizontalPosition(double delta) {
    final currentPosition = _horizontalPosition.value;
    final newPosition = currentPosition + delta;

    // 边界检查
    final screenWidth = MediaQuery.of(context).size.width;
    const minX = -20.0;
    final maxX = screenWidth - 20.0 - 100.0;

    _horizontalPosition.value = newPosition.clamp(minX, maxX);
  }

  void _updateVerticalPosition(double delta) {
    final currentPosition = _verticalPosition.value;
    final newPosition = currentPosition + delta;

    // 边界检查
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.6;
    const minY = -20.0;
    final maxY = containerHeight - 20.0 - 100.0;

    _verticalPosition.value = newPosition.clamp(minY, maxY);
  }
}

// 单击、双击、长按手势区域组件
class _TapGestureArea extends StatelessWidget {
  const _TapGestureArea();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_GestureDetectorDemoState>();

    return GestureDetector(
      onTapDown: (details) => state?._addLog('🔵 onTapDown: ${details.localPosition}'),
      onTapUp: (details) => state?._addLog('🔵 onTapUp: ${details.localPosition}'),
      onTap: () => state?._addLog('🔵 onTap: 单击完成'),
      onTapCancel: () => state?._addLog('🔵 onTapCancel: 单击取消'),
      onDoubleTapDown: (details) => state?._addLog('🔵 onDoubleTapDown: ${details.localPosition}'),
      onDoubleTap: () => state?._addLog('🔵 onDoubleTap: 双击完成'),
      onDoubleTapCancel: () => state?._addLog('🔵 onDoubleTapCancel: 双击取消'),
      onLongPressDown: (details) => state?._addLog('🔵 onLongPressDown: ${details.localPosition}'),
      onLongPressStart: (details) => state?._addLog('🔵 onLongPressStart: ${details.localPosition}'),
      onLongPress: () => state?._addLog('🔵 onLongPress: 长按触发'),
      onLongPressMoveUpdate: (details) => state?._addLog('🔵 onLongPressMoveUpdate: ${details.localPosition}'),
      onLongPressEnd: (details) => state?._addLog('🔵 onLongPressEnd: ${details.localPosition}'),
      onLongPressUp: () => state?._addLog('🔵 onLongPressUp: 长按结束'),
      onLongPressCancel: () => state?._addLog('🔵 onLongPressCancel: 长按取消'),
      onVerticalDragDown: (details) => state?._addLog('🔵 onVerticalDragDown: ${details.localPosition}'),
      onVerticalDragStart: (details) => state?._addLog('🔵 onVerticalDragStart: ${details.localPosition}'),
      onVerticalDragUpdate: (details) => state?._addLog('🔵 onVerticalDragUpdate: ${details.localPosition}'),
      onVerticalDragEnd: (details) => state?._addLog('🔵 onVerticalDragEnd: ${details.localPosition}'),
      onVerticalDragCancel: () => state?._addLog('🔵 onVerticalDragCancel: 垂直拖拽取消'),
      onHorizontalDragDown: (details) => state?._addLog('🔵 onHorizontalDragDown: ${details.localPosition}'),
      onHorizontalDragStart: (details) => state?._addLog('🔵 onHorizontalDragStart: ${details.localPosition}'),
      child: _buildGestureContainer(
        color: Colors.blue,
        width: 120,
        height: 80,
        text: '点击/双击/长按\n演示区域',
      ),
    );
  }
}

// 拖拽手势区域组件
class _PanGestureArea extends StatelessWidget {
  final Function(Offset) onPositionChanged;
  final Function(String) onLog;

  const _PanGestureArea({
    required this.onPositionChanged,
    required this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => onLog('🟢 onTapDown: ${details.localPosition}'),
      onTapUp: (details) => onLog('🟢 onTapUp: ${details.localPosition}'),
      onTap: () => onLog('🟢 onTap: 单击完成'),
      onTapCancel: () => onLog('🟢 onTapCancel: 单击取消'),
      onDoubleTapDown: (details) => onLog('🟢 onDoubleTapDown: ${details.localPosition}'),
      onDoubleTap: () => onLog('✅ onDoubleTap: 双击完成'),
      onDoubleTapCancel: () => onLog('🟢 onDoubleTapCancel: 双击取消'),
      onPanDown: (details) => onLog('🟢 onPanDown: ${details.localPosition}'),
      onPanStart: (details) => onLog('🟢 onPanStart: ${details.localPosition}'),
      onPanUpdate: (details) {
        onPositionChanged(details.delta);
        onLog('🟢 onPanUpdate: delta=${details.delta}');
      },
      onPanEnd: (details) => onLog('🟢 onPanEnd: velocity=${details.velocity.pixelsPerSecond}'),
      onPanCancel: () => onLog('🟢 onPanCancel: 拖拽取消'),
      child: _buildGestureContainer(
        color: Colors.green,
        width: 120,
        height: 80,
        text: '拖拽我！\n(Pan手势)',
      ),
    );
  }
}

// 缩放手势区域组件
class _ScaleGestureArea extends StatefulWidget {
  final double scale;
  final Function(double) onScaleChanged;
  final Function(String) onLog;

  const _ScaleGestureArea({
    required this.scale,
    required this.onScaleChanged,
    required this.onLog,
  });

  @override
  State<_ScaleGestureArea> createState() => _ScaleGestureAreaState();
}

class _ScaleGestureAreaState extends State<_ScaleGestureArea> {
  double _baseScale = 1.0; // 保存的基础缩放比例
  double _currentScale = 1.0; // 当前手势缩放比例

  @override
  void initState() {
    super.initState();
    _baseScale = widget.scale;
    _currentScale = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    // 计算实际的手势检测区域大小
    final actualWidth = 100.0 * widget.scale;
    final actualHeight = 100.0 * widget.scale;

    return SizedBox(
      width: actualWidth,
      height: actualHeight,
      child: GestureDetector(
        onTapDown: (details) => widget.onLog('🟠 onTapDown: ${details.localPosition}'),
        onTapUp: (details) => widget.onLog('🟠 onTapUp: ${details.localPosition}'),
        onTap: () => widget.onLog('🟠 onTap: 单击完成'),
        onTapCancel: () => widget.onLog('🟠 onTapCancel: 单击取消'),
        onDoubleTapDown: (details) => widget.onLog('🟠 onDoubleTapDown: ${details.localPosition}'),
        onDoubleTapCancel: () => widget.onLog('🟠 onDoubleTapCancel: 双击取消'),
        onLongPressDown: (details) => widget.onLog('🟠 onLongPressDown: ${details.localPosition}'),
        onLongPressStart: (details) => widget.onLog('🟠 onLongPressStart: ${details.localPosition}'),
        onLongPress: () => widget.onLog('🟠 onLongPress: 长按触发'),
        onLongPressMoveUpdate: (details) => widget.onLog('🟠 onLongPressMoveUpdate: ${details.localPosition}'),
        onLongPressEnd: (details) => widget.onLog('🟠 onLongPressEnd: ${details.localPosition}'),
        // 双击重置缩放
        onDoubleTap: () {
          _baseScale = 1.0;
          _currentScale = 1.0;
          widget.onScaleChanged(1.0);
          widget.onLog('🟠 onDoubleTap: 重置缩放为1.0x');
        },

        // 缩放手势
        onScaleStart: (details) {
          _currentScale = 1.0;
          widget.onLog('🟠 onScaleStart: focalPoint=${details.focalPoint}');
        },
        onScaleUpdate: (details) {
          _currentScale = details.scale;
          final newScale = (_baseScale * _currentScale).clamp(0.5, 3.0);
          widget.onScaleChanged(newScale);
          widget.onLog('🟠 onScaleUpdate: scale=${newScale.toStringAsFixed(2)}');
        },
        onScaleEnd: (details) {
          // 保存最终的缩放比例
          _baseScale = widget.scale;
          _currentScale = 1.0;
          widget.onLog('🟠 onScaleEnd: 保存缩放比例=${_baseScale.toStringAsFixed(2)}x');
        },

        child: _buildGestureContainer(
          color: Colors.orange,
          width: actualWidth,
          height: actualHeight,
          text: '缩放我！\n${widget.scale.toStringAsFixed(1)}x\n(双击重置)',
        ),
      ),
    );
  }
}

// 水平拖拽区域组件
class _HorizontalDragArea extends StatelessWidget {
  final Function(double) onPositionChanged;
  final Function(String) onLog;

  const _HorizontalDragArea({
    required this.onPositionChanged,
    required this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => onLog('🔴 onTapDown: ${details.localPosition}'),
      onTapUp: (details) => onLog('🔴 onTapUp: ${details.localPosition}'),
      onTap: () => onLog('🔴 onTap: 单击完成'),
      onTapCancel: () => onLog('🔴 onTapCancel: 单击取消'),
      onDoubleTapDown: (details) => onLog('🔴 onDoubleTapDown: ${details.localPosition}'),
      onDoubleTap: () => onLog('🔴 onDoubleTap: 双击完成'),
      onDoubleTapCancel: () => onLog('🔴 onDoubleTapCancel: 双击取消'),
      onHorizontalDragDown: (details) => onLog('🔴 onHorizontalDragDown: ${details.localPosition}'),
      onHorizontalDragStart: (details) => onLog('🔴 onHorizontalDragStart: ${details.localPosition}'),
      onHorizontalDragUpdate: (details) {
        onPositionChanged(details.delta.dx);
        onLog('🔴 onHorizontalDragUpdate: delta=${details.delta.dx.toStringAsFixed(1)}');
      },
      onHorizontalDragEnd: (details) =>
          onLog('🔴 onHorizontalDragEnd: velocity=${details.velocity.pixelsPerSecond.dx.toStringAsFixed(1)}'),
      onHorizontalDragCancel: () => onLog('🔴 onHorizontalDragCancel: 水平拖拽取消'),
      child: _buildGestureContainer(
        color: Colors.red,
        width: 100,
        height: 60,
        text: '水平拖拽\n←→',
      ),
    );
  }
}

// 垂直拖拽区域组件
class _VerticalDragArea extends StatelessWidget {
  final Function(double) onPositionChanged;
  final Function(String) onLog;

  const _VerticalDragArea({
    required this.onPositionChanged,
    required this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => onLog('🟤 onTapDown: ${details.localPosition}'),
      onTapUp: (details) => onLog('🟤 onTapUp: ${details.localPosition}'),
      onTap: () => onLog('🟤 onTap: 单击完成'),
      onTapCancel: () => onLog('🟤 onTapCancel: 单击取消'),
      onDoubleTapDown: (details) => onLog('🟤 onDoubleTapDown: ${details.localPosition}'),
      onDoubleTap: () => onLog('🟤 onDoubleTap: 双击完成'),
      onDoubleTapCancel: () => onLog('❌ onDoubleTapCancel: 双击取消'),
      onVerticalDragDown: (details) => onLog('🟤 onVerticalDragDown: ${details.localPosition}'),
      onVerticalDragStart: (details) => onLog('🟤 onVerticalDragStart: ${details.localPosition}'),
      onVerticalDragUpdate: (details) {
        onPositionChanged(details.delta.dy);
        onLog('🟤 onVerticalDragUpdate: delta=${details.delta.dy.toStringAsFixed(1)}');
      },
      onVerticalDragEnd: (details) =>
          onLog('🟤 onVerticalDragEnd: velocity=${details.velocity.pixelsPerSecond.dy.toStringAsFixed(1)}'),
      onVerticalDragCancel: () => onLog('🟤 onVerticalDragCancel: 垂直拖拽取消'),
      child: _buildGestureContainer(
        color: Colors.brown,
        width: 60,
        height: 100,
        text: '垂直\n拖拽\n↑↓',
      ),
    );
  }
}

// 通用的手势容器构建器
Widget _buildGestureContainer({
  required Color color,
  required double width,
  required double height,
  required String text,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color.withOpacity(0.3),
      border: Border.all(color: color, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
