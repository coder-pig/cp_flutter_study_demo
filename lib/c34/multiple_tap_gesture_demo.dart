import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

/// 🎯 综合手势识别Demo
class MultipleTapGestureDemo extends StatefulWidget {
  const MultipleTapGestureDemo({Key? key}) : super(key: key);

  @override
  State<MultipleTapGestureDemo> createState() => _MultipleTapGestureDemoState();
}

class _MultipleTapGestureDemoState extends State<MultipleTapGestureDemo> {
  final ValueNotifier<List<String>> _gestureHistory = ValueNotifier([]); // 手势历史列表
  final ValueNotifier<Color> _bgColorNotifier = ValueNotifier(Colors.black);
  final Color _tapColor = Colors.green; // 单击颜色
  final Color _longPressColor = Colors.red; // 长按颜色
  final List<Color> _multipleTapColors = [
    // N连击颜色列表
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N连击手势检测Demo'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          RawGestureDetector(
            // 设置手势识别器：Key为TapGestureRecognizer类型，Value为手势识别器的工厂对象
            gestures: {
              TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                () => TapGestureRecognizer(),
                (GestureRecognizer instance) {
                  (instance as TapGestureRecognizer).onTap = () {
                    _gestureHistory.value = ['触发单击', ..._gestureHistory.value];
                    _bgColorNotifier.value = _tapColor;
                  };
                },
              ),
              LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(),
                (GestureRecognizer instance) {
                  (instance as LongPressGestureRecognizer).onLongPress = () {
                    _gestureHistory.value = ['触发长按', ..._gestureHistory.value];
                    _bgColorNotifier.value = _longPressColor;
                  };
                },
              ),
              MultipleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<MultipleTapGestureRecognizer>(
                () => MultipleTapGestureRecognizer(),
                (GestureRecognizer instance) {
                  (instance as MultipleTapGestureRecognizer).onMultipleTap = (tapCount, position) {
                    _gestureHistory.value = ['触发N连击: $tapCount', ..._gestureHistory.value];
                    // 可能有数组越界问题
                    _bgColorNotifier.value = _multipleTapColors[(tapCount - 2) % _multipleTapColors.length];
                  };
                },
              ),
            },
            child: ValueListenableBuilder(
              valueListenable: _bgColorNotifier,
              builder: (context, value, child) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _bgColorNotifier.value,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _bgColorNotifier.value.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 48,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // 美化的手势历史标题
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '手势历史记录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                if (_gestureHistory.value.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _gestureHistory.value = [];
                      _bgColorNotifier.value = Colors.black;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.clear_all,
                            size: 14,
                            color: Colors.red[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '清空',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 美化的手势历史列表
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _gestureHistory,
              builder: (context, gestureList, child) {
                if (gestureList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无手势记录',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '点击上方方块开始体验',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: gestureList.length,
                  itemBuilder: (context, index) {
                    final gesture = gestureList[index];
                    IconData icon;
                    Color color;

                    // 根据手势类型设置不同的图标和颜色
                    if (gesture.contains('单击')) {
                      icon = Icons.touch_app;
                      color = _tapColor;
                    } else if (gesture.contains('长按')) {
                      icon = Icons.ads_click;
                      color = _longPressColor;
                    } else {
                      icon = Icons.multiple_stop;
                      color = Colors.purple;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              icon,
                              size: 16,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              gesture,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Text(
                            '#${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎯 N连击手势识别器
class MultipleTapGestureRecognizer extends OneSequenceGestureRecognizer {
  /// 连击时间间隔限制（毫秒）
  final int tapInterval;

  /// 连击位置偏移限制（像素）
  final double positionTolerance;

  /// N连击事件回调函数
  Function(int tapCount, Offset position)? onMultipleTap;

  /// 当前连击次数
  int _tapCount = 0;

  /// 上次点击时间
  DateTime? _lastTapTime;

  /// 上次点击位置
  Offset? _lastTapPosition;

  /// 重置定时器
  Timer? _resetTimer;

  MultipleTapGestureRecognizer({
    this.tapInterval = 300,
    this.positionTolerance = 50.0,
  });

  @override
  String get debugDescription => 'MultipleTapGestureRecognizer';

  @override
  void addAllowedPointer(PointerDownEvent event) {
    // 开始跟踪这个指针
    startTrackingPointer(event.pointer, event.transform);
  }

  @override
  void handleEvent(PointerEvent event) {
    // 只处理抬起事件
    if (event is PointerUpEvent) _handleTapUp(event);
  }

  /// 🎯 处理抬起事件
  void _handleTapUp(PointerUpEvent event) {
    final now = DateTime.now();
    final position = event.position;

    // 检查是否在连击时间间隔内
    bool isWithinTapInterval = false;
    if (_lastTapTime != null) {
      final timeDiff = now.difference(_lastTapTime!).inMilliseconds;
      isWithinTapInterval = timeDiff <= tapInterval;
    }

    // 检查是否在连击位置范围内
    bool isWithinPositionTolerance = true;
    if (_lastTapPosition != null) {
      final distance = (position - _lastTapPosition!).distance;
      isWithinPositionTolerance = distance <= positionTolerance;
    }

    // 判断是否为连击
    if (isWithinTapInterval && isWithinPositionTolerance) {
      _tapCount++;
    } else {
      _tapCount = 1;
    }

    // 更新状态
    _lastTapTime = now;
    _lastTapPosition = position;
    // 取消之前的重置定时器
    _resetTimer?.cancel();

    if (_tapCount == 1) {
      // 第一次点击时hold住竞技场，阻止TapGestureRecognizer立即获胜
      GestureBinding.instance.gestureArena.hold(event.pointer);
    } else if (_tapCount >= 2) {
      // 多击成功，立即触发连击事件并获胜
      resolve(GestureDisposition.accepted);
      onMultipleTap?.call(_tapCount, position);
    }

    // 设置重置定时器
    _resetTimer = Timer(Duration(milliseconds: tapInterval), () {
      _tapCount = 0;
      _lastTapTime = null;
      _lastTapPosition = null;
      // 超时后释放竞技场
      GestureBinding.instance.gestureArena.release(event.pointer);
    });
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    // 如果连击次数小于2，认输
    if (_tapCount < 2)  resolve(GestureDisposition.rejected);
  }

  @override
  void dispose() {
    _tapCount = 0;
    _lastTapTime = null;
    _lastTapPosition = null;
    _resetTimer?.cancel();
    _resetTimer = null;
    super.dispose();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Study Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MultipleTapGestureDemo(),
    );
  }
}
