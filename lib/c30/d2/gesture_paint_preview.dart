import 'dart:math';
import 'dart:ui' as ui;

import 'package:cp_flutter_study_demo/c29/fast_widget_ext.dart';
import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:cp_flutter_study_demo/utils/color_ext.dart';
import 'package:cp_flutter_study_demo/utils/text_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

class GesturePaintPreview extends StatelessWidget {
  const GesturePaintPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('手势识别绘制效果预览')),
        body: _PreviewContent(),
      ),
    );
  }
}

class _PreviewContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreviewContentState();
}

class _PreviewContentState extends State<_PreviewContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // 动画控制器
  final _imgNotifier = ValueNotifier<ui.Image?>(null);

  @override
  void initState() {
    super.initState();
    loadImageFromAssets("assets/images/ic_lm.png")?.then((value) {
      _imgNotifier.value = value;
    });
    _animationController = AnimationController(vsync: this, lowerBound: 0, upperBound: 400);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
            child: Column(children: [
          fastText("Tap-点击：触点画圆", CPTextStyle.s16.bold.c(Colors.red)),
          RepaintBoundary(child: buildTapPreview()),
          fastText("DoubleTap-双击：圆变色", CPTextStyle.s16.bold.c(Colors.red)),
          RepaintBoundary(child: buildDoubleTapPreview()),
          fastText("LongPress-长按：弹窗", CPTextStyle.s16.bold.c(Colors.red)),
          RepaintBoundary(child: buildLongPressPreview()),
          fastText("Pan-平移：圆形控制柄", CPTextStyle.s16.bold.c(Colors.red)),
          RepaintBoundary(child: buildPanPreview()),
          fastText("VerticalDrag-垂直拖拽：下落小球", CPTextStyle.s16.bold.c(Colors.red)),
          RepaintBoundary(child: buildVerticalDragPreview()),
          fastText("Scale-缩放：图片缩放、旋转、平移", CPTextStyle.s16.bold.c(Colors.red)),
          // Tips：滚动视图和GestureDetector缩放会有冲突，比较恶心，这里直接跳
          ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) {
                  return BuildScalePreview(image: _imgNotifier.value!);
                }));
              },
              child: const Text("跳转预览页")),
        ])));
  }

  // 双击预览
  Widget buildDoubleTapPreview() {
    final ValueNotifier<TapDownDetails> tapDownDetails = ValueNotifier<TapDownDetails>(TapDownDetails());
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      child: GestureDetector(
        onDoubleTapDown: (details) {
          tapDownDetails.value = details;
        },
        child: Paper(painter: DoubleTapPreviewPainter(tapDownDetails)),
      ),
    );
  }

  // 单击预览
  Widget buildTapPreview() {
    final ValueNotifier<TapDownDetails> tapDownDetails = ValueNotifier<TapDownDetails>(TapDownDetails());
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      child: GestureDetector(
        onTapDown: (details) {
          tapDownDetails.value = details;
        },
        child: Paper(painter: TapPreviewPainter(tapDownDetails)),
      ),
    );
  }

  // 长按预览
  Widget buildLongPressPreview() {
    final LongPressNotifier notifier = LongPressNotifier();
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      child: GestureDetector(
        onTap: () {
          notifier.setShowPopup(false);
        },
        onLongPressStart: (details) {
          notifier.updateDetails(details);
          notifier.setShowPopup(true);
        },
        child: Paper(painter: LongPressPreviewPainter(notifier)),
      ),
    );
  }

  // 平移预览
  Widget buildPanPreview() {
    final ValueNotifier<Offset> offset = ValueNotifier<Offset>(Offset.zero);
    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      child: GestureDetector(
        onPanEnd: (details) {
          offset.value = Offset.zero;
        },
        onPanUpdate: (details) {
          offset.value = details.localPosition;
        },
        child: Paper(painter: PanPreviewPainter(offset)),
      ),
    );
  }

  // 垂直拖拽
  Widget buildVerticalDragPreview() {
    final VerticalDragNotifier verticalDragNotifier = VerticalDragNotifier(_animationController);
    return Container(
      padding: const EdgeInsets.all(10),
      height: 400,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (verticalDragNotifier.animating) return;
          verticalDragNotifier.animating = false;
          verticalDragNotifier.offset = details.localPosition;
        },
        onVerticalDragEnd: (details) {
          if (verticalDragNotifier.animating) return;
          verticalDragNotifier.animating = true;
          verticalDragNotifier.startFallAnimation(400);
        },
        child: Paper(painter: VerticalDragPreviewPainter(verticalDragNotifier)),
      ),
    );
  }
}

class BuildScalePreview extends StatelessWidget {
  final ValueNotifier<Matrix4> matrix = ValueNotifier(Matrix4.identity());
  final ui.Image image;

  BuildScalePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    Matrix4 recodeMatrix = Matrix4.identity(); // 记录上一次的Matrix
    Offset offset = Offset.zero;
    return Scaffold(
      appBar: AppBar(title: const Text("图片缩放、旋转、平移")),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: 600,
        child: GestureDetector(
          onScaleStart: (details) {
            offset = details.focalPoint;
          },
          onScaleUpdate: (details) {
            // 单指平移画布
            if (details.pointerCount == 1) {
              matrix.value = recodeMatrix.multiplied(
                  Matrix4.translationValues((details.focalPoint.dx - offset.dx), (details.focalPoint.dy - offset.dy), 1));
            } else {
              // 旋转角度超过20度时，更新旋转矩阵
              if ((details.rotation * 180 / pi).abs() > 20) {
                matrix.value = recodeMatrix.multiplied(Matrix4.rotationZ(details.rotation));
              } else {
                // 处理缩放手势 (x、y轴等比例缩放，z轴保持不变缩放因子为1)
                if (details.scale == 1.0) return;
                matrix.value = recodeMatrix.multiplied(Matrix4.diagonal3Values(details.scale, details.scale, 1));
              }
            }
          },
          onScaleEnd: (details) {
            // 结束时记录当前Matrix
            recodeMatrix = matrix.value;
          },
          child: Paper(painter: ScalePreviewPainter(matrix, image)),
        ),
      ),
    );
  }
}

class TapPreviewPainter extends CustomPainter {
  final ValueNotifier<TapDownDetails> _tapDownDetails;

  TapPreviewPainter(this._tapDownDetails) : super(repaint: _tapDownDetails);

  @override
  void paint(Canvas canvas, Size size) {
    // 裁剪绘制区域，避免绘制超出区域
    canvas.clipRect(Offset.zero & size);
    // 绘制灰色背景区域便于区分绘制区域
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(30));
    // 如果触点在左上角(0,0)不绘制
    if (_tapDownDetails.value.localPosition != Offset.zero) {
      // 根据传入的触点位置绘制圆形
      canvas.drawCircle(_tapDownDetails.value.localPosition, 40, Paint()..color = Colors.red);
      // 在圆中间绘制坐标信息，保留一位小数
      TextPainter textPainter = fastTextPainter(
          "(${_tapDownDetails.value.localPosition.dx.toStringAsFixed(1)}, "
          "${_tapDownDetails.value.localPosition.dy.toStringAsFixed(1)})",
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold));
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(_tapDownDetails.value.localPosition.dx - textPainter.width / 2,
              _tapDownDetails.value.localPosition.dy - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(TapPreviewPainter oldDelegate) => false;
}

class DoubleTapPreviewPainter extends CustomPainter {
  final ValueNotifier<TapDownDetails> _tapDownDetails;
  Color? paintColor;

  DoubleTapPreviewPainter(this._tapDownDetails) : super(repaint: _tapDownDetails);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(30));
    final circleCenterPoint = Offset(size.width / 2, size.height / 2);
    const radius = 50.0;
    String hintText = '';
    Offset localPosition = _tapDownDetails.value.localPosition;
    Paint paint = Paint()
      ..color = paintColor ?? Colors.red
      ..style = PaintingStyle.fill;
    // 💡 只需判断「触点到圆心的距离」是否小于「半径」即可知道是否在范围内
    // 通过Offset提供的distance方法计算两点之间的距离，原理是三角函数计算两点之间的距离：math.sqrt(dx * dx + dy * dy)
    if ((_tapDownDetails.value.localPosition - circleCenterPoint).distance < radius) {
      hintText = "双击触点在圆内（${localPosition.dx.toStringAsFixed(1)},${localPosition.dy.toStringAsFixed(1)}）";
      paintColor = randomColor;
      paint.color = paintColor!;
    } else {
      hintText = "双击触点不在圆内（${localPosition.dx.toStringAsFixed(1)},${localPosition.dy.toStringAsFixed(1)}）";
    }
    // 绘制圆
    canvas.drawCircle(circleCenterPoint, radius, paint);
    // 绘制文字
    TextPainter textPainter = fastTextPainter(hintText);
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - 30));
  }

  @override
  bool shouldRepaint(DoubleTapPreviewPainter oldDelegate) => false;
}

class LongPressNotifier extends ChangeNotifier {
  bool _showPopup = false;
  LongPressStartDetails _details = const LongPressStartDetails();

  bool get showPopup => _showPopup;

  LongPressStartDetails get details => _details;

  void updateDetails(LongPressStartDetails details) {
    _details = details;
    notifyListeners();
  }

  void setShowPopup(bool value) {
    _showPopup = value;
    notifyListeners();
  }
}

class LongPressPreviewPainter extends CustomPainter {
  final LongPressNotifier notifier;

  LongPressPreviewPainter(this.notifier) : super(repaint: notifier);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(30));
    const radius = 30.0;
    final centerPoint = Offset(size.width / 2, size.height / 2 + 20);
    Rect rect = Rect.fromCircle(center: centerPoint, radius: radius);
    canvas.drawRect(rect, Paint()..color = Colors.red);
    Offset localPosition = notifier.details.localPosition;
    // 如果显示弹窗 & 判断长按点是否在矩形区域内，绘制弹窗
    if (notifier.showPopup && rect.contains(localPosition)) {
      final popupRect = Rect.fromCenter(center: Offset(centerPoint.dx, centerPoint.dy - 80), width: 100, height: 40);
      final radius = RRect.fromRectAndRadius(popupRect, const Radius.circular(5));
      canvas.drawRRect(radius, Paint()..color = Colors.black.withAlpha(100));
      TextPainter textPainter = fastTextPainter("长按触发",
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold));
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(popupRect.center.dx - textPainter.width / 2, popupRect.center.dy - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(LongPressPreviewPainter oldDelegate) => oldDelegate.notifier.details != notifier.details;
}

class PanPreviewPainter extends CustomPainter {
  final ValueNotifier<Offset> offset;

  PanPreviewPainter(this.offset) : super(repaint: offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(30));
    final centerPoint = Offset(size.width / 2, size.height / 2);
    const bgRadius = 80.0;
    const handleRadius = 25.0;
    canvas.drawCircle(centerPoint, bgRadius, Paint()..color = Colors.blue.withAlpha(50));
    Offset handlePoint = Offset.zero;
    if (offset.value == Offset.zero) {
      handlePoint = centerPoint;
    } else {
      // 判断距离是否大于半径
      final distance = (offset.value - centerPoint).distance;
      if (distance > bgRadius) {
        // 求弧度
        final radian = (offset.value - centerPoint).direction;
        // 根据弧度计算新的坐标
        handlePoint = centerPoint + Offset.fromDirection(radian, bgRadius);
      } else {
        // 如果距离小于半径，直接使用触点坐标
        handlePoint = offset.value;
      }
    }
    // 画圆
    canvas.drawCircle(handlePoint, handleRadius, Paint()..color = Colors.red.withAlpha(200));
    // 画连线
    canvas.drawLine(
        centerPoint,
        handlePoint,
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(PanPreviewPainter oldDelegate) => false;
}

class VerticalDragNotifier extends ChangeNotifier {
  Offset _offset = Offset.zero; // 触点位置
  bool animating = false; // 动画是否正在运行
  late final AnimationController _animationController; // 动画控制器

  VerticalDragNotifier(this._animationController);

  Offset get offset => _offset;

  AnimationController get animationController => _animationController;

  set offset(Offset value) {
    _offset = value;
    notifyListeners();
  }

  void startFallAnimation(double end) {
    _animationController.reset();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 动画结束，重置状态
        animating = false;
        offset = Offset.zero;
      }
    });
    // 监听动画值变化通知刷新
    _animationController.addListener(() {
      notifyListeners();
    });
    // 使用GravitySimulation模拟重力加速度，用它来驱动动画
    // 参数依次为：加速度、初始位置、结束位置、初始速度
    // 初始位置需要做下判断，如果小于等于0说明触点在绘制区域以外，设置一个初始值20(圆半径)
    // 结束为止直接传的绘制区域的高度
    _animationController.animateWith(GravitySimulation(98, _offset.dy <= 0 ? 20.0 : _offset.dy, end, 0.0));
  }
}

class VerticalDragPreviewPainter extends CustomPainter {
  final VerticalDragNotifier repaint;
  double width = 0;
  double height = 0;
  final ballRadius = 20.0;
  final ballPaint = Paint()..color = Colors.red;

  VerticalDragPreviewPainter(this.repaint) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.grey.withAlpha(30));
    // 动画没有在执行，直接根据触点绘制圆，否则按照动画值绘制圆
    if (!repaint.animating) {
      drawBall(canvas, repaint.offset.dy);
    } else {
      drawBall(canvas, repaint.animationController.value);
    }
  }

  // 绘制小球，做下边界值处理
  void drawBall(Canvas canvas, double dy) {
    if (dy == 0) {
      dy = height - ballRadius;
    } else if (dy < 0 || dy - ballRadius < 0) {
      dy = ballRadius;
    } else if (dy > height - ballRadius) {
      dy = height - ballRadius;
    }
    canvas.drawCircle(Offset(width / 2, dy), ballRadius, ballPaint);
  }

  @override
  bool shouldRepaint(VerticalDragPreviewPainter oldDelegate) => false;
}

class ScalePreviewPainter extends CustomPainter {
  final ValueNotifier<Matrix4> matrix4;
  final ui.Image image;

  ScalePreviewPainter(this.matrix4, this.image) : super(repaint: matrix4);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final center = Offset(size.width / 2, size.height / 2);
    final grayPaint = Paint()..color = Colors.grey.withAlpha(30);
    canvas.drawRect(Offset.zero & size, grayPaint);
    // 绘制灰色坐标轴
    grayPaint.color = Colors.grey;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), grayPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), grayPaint);
    // 保存画布状态再进行变换
    canvas.save();
    // 移动画布到中心点，使得绘制的图片以中心点为中心
    canvas.translate(center.dx, center.dy);
    canvas.transform(matrix4.value.storage);
    // 绘制图片
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromCircle(center: Offset.zero, radius: 50);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
    // 恢复画布状态
    canvas.restore();
  }

  @override
  bool shouldRepaint(ScalePreviewPainter oldDelegate) => false;
}

// 加载图片数据解码为图片对象
Future<ui.Image>? loadImageFromAssets(String path) async {
  ByteData data = await rootBundle.load(path);
  return decodeImageFromList(data.buffer.asUint8List());
}
