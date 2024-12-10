import 'dart:math';

import 'package:cp_flutter_study_demo/c29/paper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 横屏+全屏
  Future.any([
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]),
  ]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const SimpleClock();
}

class SimpleClock extends StatefulWidget {
  const SimpleClock({super.key});

  @override
  State<StatefulWidget> createState() => _SimpleClockState();
}

class _SimpleClockState extends State<SimpleClock> with TickerProviderStateMixin {
  late final Ticker _ticker;
  late ValueNotifier<DateTime> _datetime;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _datetime = ValueNotifier(DateTime.now());
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _ticker = createTicker((duration) {
      _tick(duration);
    });
    _ticker.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Paper(painter: SimpleClockPainter(_datetime, _animation));
  }

  @override
  void dispose() {
    _datetime.dispose();
    _controller.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    // Ticker在每帧刷新时都会回调(16ms)，这里做下过滤，每隔1s才刷新一次，减少不必要的重绘
    if (DateTime.now().millisecondsSinceEpoch - _datetime.value.millisecondsSinceEpoch > 1000) {
      _datetime.value = DateTime.now();
      // 每次刷新时间都重新执行
      _controller.forward(from: 0);
    }
  }
}

class SimpleClockPainter extends CustomPainter {
  final ValueNotifier<DateTime> datetime;
  final Animation<double> animation;
  final List<List<SimpleClockModel>> models = [
    // 第一组
    [
      SimpleClockModel(0, 0, 1, 90, 90, 1, 1, 1),
      SimpleClockModel(0, 90, 1, 90, 150, 1, 1, 0),
      SimpleClockModel(150, 0, 1, 150, 0, 1, 0, 1),
      SimpleClockModel(0, 0, 1, 0, 0, 1, 1, 1),
      SimpleClockModel(0, 90, 1, 0, 90, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 90, 0, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 0, 0, 1, 1, 1),
      SimpleClockModel(90, 0, 1, 90, 0, 1, 1, 1),
      SimpleClockModel(0, 0, 1, 0, 90, 1, 1, 1),
      SimpleClockModel(0, 0, 1, 90, 90, 1, 1, 1),
    ],
    // 第二组
    [
      SimpleClockModel(90, 90, 1, 180, 180, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 180, 135, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 135, 180, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 180, 180, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 180, 90, 1, 1, 1),
      SimpleClockModel(90, 180, 1, 90, 180, 1, 1, 1),
      SimpleClockModel(180, 180, 1, 180, 180, 1, 1, 1),
      SimpleClockModel(180, 180, 1, 180, 90, 1, 1, 1),
      SimpleClockModel(180, 180, 1, 90, 90, 1, 1, 1),
      SimpleClockModel(180, 180, 1, 90, 90, 1, 1, 1),
    ],
    // 第三组
    [
      SimpleClockModel(-90, 90, 1, 0, -90, 1, 1, 1),
      SimpleClockModel(90, 120, 1, -90, 0, 1, 1, 0),
      SimpleClockModel(120, 90, 1, 120, 0, 1, 0, 1),
      SimpleClockModel(0, 0, 1, 90, 0, 1, 1, 1),
      SimpleClockModel(0, 0, 1, 0, -90, 1, 1, 1),
      SimpleClockModel(0, 0, 1, -90, -90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 0, 90, 1, 1, 1),
      SimpleClockModel(-90, -45, 1, 90, 120, 1, 1, 0),
      SimpleClockModel(150, 0, 1, 150, 0, 1, 0, 1),
      SimpleClockModel(0, 0, 1, 0, -90, 1, 1, 1),
    ],
    // 第四组
    [
      SimpleClockModel(-90, -90, 1, 90, 90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 90, 90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 90, 180, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 180, 90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 90, 90, 1, 1, 1),
      SimpleClockModel(-90, 90, 1, 90, 180, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 180, 180, 1, 1, 1),
      SimpleClockModel(90, 90, 1, 180, -90, 1, 1, 1),
      SimpleClockModel(90, 180, 1, -90, 180, 1, 1, 1),
      SimpleClockModel(180, 90, 1, 180, -90, 1, 1, 1),
    ],
    // 第五组
    [
      SimpleClockModel(0, 0, 1, 0, -90, 1, 1, 1),
      SimpleClockModel(0, 90, 1, -90, -90, 1, 1, 0),
      SimpleClockModel(150, 0, 1, 150, -90, 1, 0, 1),
      SimpleClockModel(0, 0, 1, -90, 0, 1, 1, 1),
      SimpleClockModel(0, 60, 1, 0, 60, 1, 1, 0),
      SimpleClockModel(150, 0, 1, 150, 0, 1, 0, 1),
      SimpleClockModel(0, 0, 1, 0, -90, 1, 1, 1),
      SimpleClockModel(-90, 0, 1, 0, 90, 1, 1, 0),
      SimpleClockModel(120, 0, 1, 120, -90, 1, 0, 1),
      SimpleClockModel(0, 0, 1, -90, 0, 1, 1, 1),
    ],
    // 第六组
    [
      SimpleClockModel(180, 180, 1, -90, -90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 180, -90, 1, 1, 1),
      SimpleClockModel(-90, 180, 1, -90, 180, 1, 1, 1),
      SimpleClockModel(180, 180, 1, 180, -90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 180, -90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, -90, 180, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 180, 180, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 180, -90, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, -90, 180, 1, 1, 1),
      SimpleClockModel(-90, -90, 1, 180, 180, 1, 1, 1),
    ]
  ];

  // 画布宽高
  double width = 0.0;
  double height = 0.0;

  // 指针半径
  final int circleCountHorizontal = 14; // 水平圆圈数
  final int circleCountVertical = 3; // 垂直圆圈数
  final double paddingHorizontal = 50; // 两侧留白间距
  double circleRadius = 0.0; // 圆圈半径
  double circleBetween = 4.0; // 圆圈之间的间距
  double circleCenterDistance = 0.0; // 圆圈之间的距离
  double _pointerRadius = 0.0; // 指针半径
  double pointerStrokeWidth = 5.0; // 指针笔触宽度

  // 时分秒
  int hourBefore = 0;
  int hourAfter = 0;
  int minuteBefore = 0;
  int minuteAfter = 0;
  int secondBefore = 0;
  int secondAfter = 0;

  // 旧的时分秒
  int oldHourBefore = -1;
  int oldHourAfter = -1;
  int oldMinuteBefore = -1;
  int oldMinuteAfter = -1;
  int oldSecondBefore = -1;
  int oldSecondAfter = -1;

  // 画笔

  final Paint _greyCirclePaint = Paint()..color = Colors.grey.withAlpha(100);
  final Paint _whiteCirclePaint = Paint()..color = Colors.white;
  final Paint _pointerDefaultPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  SimpleClockPainter(this.datetime, this.animation) : super(repaint: Listenable.merge([datetime, animation]));

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    _pointerDefaultPaint.strokeWidth = pointerStrokeWidth;
    _pointerRadius = circleRadius - pointerStrokeWidth / 2;
    circleCenterDistance = circleRadius * 2 + circleBetween;
    // 求出每个圆圈的半径
    circleRadius =
        (size.width - paddingHorizontal * 2 - circleBetween * (circleCountHorizontal - 1)) / circleCountHorizontal / 2;
    // 获取时分秒
    hourBefore = datetime.value.hour ~/ 10;
    hourAfter = datetime.value.hour % 10;
    minuteBefore = datetime.value.minute ~/ 10;
    minuteAfter = datetime.value.minute % 10;
    secondBefore = datetime.value.second ~/ 10;
    secondAfter = datetime.value.second % 10;

    // 从左到右依次绘制
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0XFFD9D9D9));
    canvas.clipRect(Offset.zero & size);
    canvas.save();
    canvas.translate(paddingHorizontal, (height - 3 * circleRadius - 2 * circleCenterDistance) / 2);
    // 当前绘制到的起点
    Offset currentOffset = Offset.zero;
    // 绘制时
    bool hourBeforeNeedAnimation = oldHourBefore != hourBefore;
    // 判断动画结束时才更新旧的值
    if (hourBeforeNeedAnimation && animation.value == 1) oldHourBefore = hourBefore;
    paintNumber(canvas, currentOffset, hourBefore, hourBeforeNeedAnimation);
    currentOffset += Offset(circleRadius * 4 + circleBetween * 2, 0);
    bool hourAfterNeedAnimation = oldHourAfter != hourAfter;
    if (hourAfterNeedAnimation && animation.value == 1) oldHourAfter = hourAfter;
    paintNumber(canvas, currentOffset, hourAfter, hourAfterNeedAnimation);
    // 绘制一排圆
    currentOffset += Offset(circleRadius * 4 + circleBetween * 2, 0);
    paintRowCircle(canvas, currentOffset);
    // 绘制分
    currentOffset += Offset(circleRadius * 2 + circleBetween, 0);
    bool minuteBeforeNeedAnimation = oldMinuteBefore != minuteBefore;
    if (minuteBeforeNeedAnimation && animation.value == 1) oldMinuteBefore = minuteBefore;
    paintNumber(canvas, currentOffset, minuteBefore, minuteBeforeNeedAnimation);
    currentOffset += Offset(circleRadius * 4 + circleBetween * 2, 0);
    bool minuteAfterNeedAnimation = oldMinuteAfter != minuteAfter;
    if (minuteAfterNeedAnimation && animation.value == 1) oldMinuteAfter = minuteAfter;
    paintNumber(canvas, currentOffset, minuteAfter, minuteAfterNeedAnimation);
    // 绘制一排圆
    currentOffset += Offset(circleRadius * 4 + circleBetween * 2, 0);
    paintRowCircle(canvas, currentOffset);
    // 绘制秒的前一位
    currentOffset += Offset(circleRadius * 2 + circleBetween, 0);
    bool secondBeforeNeedAnimation = oldSecondBefore != secondBefore;
    if (secondBeforeNeedAnimation && animation.value == 1) oldSecondBefore = secondBefore;
    paintNumber(canvas, currentOffset, secondBefore, secondBeforeNeedAnimation);
    // 绘制秒的后一位
    currentOffset += Offset(circleRadius * 4 + circleBetween * 2, 0);
    bool secondAfterNeedAnimation = oldSecondAfter != secondAfter;
    if (secondAfterNeedAnimation && animation.value == 1) oldSecondAfter = secondAfter;
    paintNumber(canvas, currentOffset, secondAfter, secondAfterNeedAnimation);
    canvas.restore();
  }

  // 绘制一个数字
  paintNumber(Canvas canvas, Offset start, int pos, bool needAnimation) {
    paintUnit(canvas, start, models[0][pos], needAnimation);
    paintUnit(canvas, Offset(start.dx + circleCenterDistance, start.dy), models[1][pos], needAnimation);
    paintUnit(canvas, Offset(start.dx, start.dy + circleCenterDistance), models[2][pos], needAnimation);
    paintUnit(canvas, Offset(start.dx + circleCenterDistance, start.dy + circleCenterDistance), models[3][pos],
        needAnimation);
    paintUnit(canvas, Offset(start.dx, start.dy + circleCenterDistance * 2), models[4][pos], needAnimation);
    paintUnit(canvas, Offset(start.dx + circleCenterDistance, start.dy + circleCenterDistance * 2), models[5][pos],
        needAnimation);
  }

  // 绘制单元
  paintUnit(Canvas canvas, Offset start, SimpleClockModel model, bool needAnimation) {
    Offset centerPoint = Offset(start.dx + circleRadius, start.dy + circleRadius);
    // 绘制灰色圆圈和白色原点
    paintCircle(canvas, centerPoint);
    double firstPointAngle = 0;
    Offset firstPoint = Offset.zero;
    double secondPointAngle = 0;
    Offset secondPoint = Offset.zero;
    Paint paint = _pointerDefaultPaint..color = model.toIsAlpha == 1 ? Colors.black : Colors.transparent;
    if (needAnimation) {
      firstPointAngle =
          (model.firstStartAngle + (model.firstEndAngle - model.firstStartAngle) * model.firstSpeed * animation.value);
      firstPoint =
          Offset(_pointerRadius * cos(firstPointAngle * pi / 180), _pointerRadius * sin(firstPointAngle * pi / 180));
      secondPointAngle = (model.secondStartAngle +
          (model.secondEndAngle - model.secondStartAngle) * model.secondSpeed * animation.value);
      secondPoint =
          Offset(_pointerRadius * cos(secondPointAngle * pi / 180), _pointerRadius * sin(secondPointAngle * pi / 180));
      paint = createPointerAlphaPaint(model.fromIsAlpha, model.toIsAlpha);
    } else {
      firstPointAngle = model.firstEndAngle;
      firstPoint =
          Offset(_pointerRadius * cos(firstPointAngle * pi / 180), _pointerRadius * sin(firstPointAngle * pi / 180));
      secondPointAngle = model.secondEndAngle;
      secondPoint =
          Offset(_pointerRadius * cos(secondPointAngle * pi / 180), _pointerRadius * sin(secondPointAngle * pi / 180));
    }
    canvas.drawLine(centerPoint, firstPoint + centerPoint, paint);
    canvas.drawLine(centerPoint, secondPoint + centerPoint, paint);
  }

  // 绘制黑白圆圈
  paintCircle(Canvas canvas, Offset center, {Color centerColor = Colors.white}) {
    canvas.drawCircle(center, circleRadius, _greyCirclePaint);
    canvas.drawCircle(center, 2, _whiteCirclePaint..color = centerColor);
  }

  // 绘制一排黑白圆圈
  paintRowCircle(Canvas canvas, Offset start) {
    paintCircle(canvas, Offset(start.dx + circleRadius, start.dy + circleRadius));
    paintCircle(canvas, Offset(start.dx + circleRadius, start.dy + circleRadius + circleCenterDistance),
        centerColor: Colors.black);
    paintCircle(canvas, Offset(start.dx + circleRadius, start.dy + circleRadius + 2 * circleCenterDistance));
  }

  // 创建指针画笔
  createPointerAlphaPaint(int fromIsAlpha, int toIsAlpha) {
    Color color;
    if (fromIsAlpha == 1) {
      if (toIsAlpha == 1) {
        color = Colors.black;
      } else {
        color = Color.lerp(Colors.black, Colors.transparent, animation.value)!;
      }
    } else {
      if (toIsAlpha == 1) {
        color = Color.lerp(Colors.transparent, Colors.black, animation.value)!;
      } else {
        color = Colors.transparent;
      }
    }
    return Paint()
      ..color = color
      ..strokeWidth = pointerStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SimpleClockModel {
  final double firstStartAngle; // 第一个指针的起始角度
  final double firstEndAngle; // 第一个指针的结束角度
  final double firstSpeed; // 第一个指针的速度
  final double secondStartAngle; // 第二个指针的起始角度
  final double secondEndAngle; // 第二个指针的结束角度
  final double secondSpeed; // 第二个指针的速度
  final int fromIsAlpha; // 起始时是否透明
  final int toIsAlpha; // 结束时是否透明

  SimpleClockModel(this.firstStartAngle, this.firstEndAngle, this.firstSpeed, this.secondStartAngle,
      this.secondEndAngle, this.secondSpeed, this.fromIsAlpha, this.toIsAlpha);
}
