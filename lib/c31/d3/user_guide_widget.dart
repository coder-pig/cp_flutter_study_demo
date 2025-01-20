import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UserGuideWidget extends StatefulWidget {
  final List<GuidePage> guidePages; // 引导页列表
  final VoidCallback onGuideEnd; // 引导结束回调

  const UserGuideWidget(this.guidePages, this.onGuideEnd, {super.key});

  @override
  State<StatefulWidget> createState() => UserGuideWidgetState();
}

class UserGuideWidgetState extends State<UserGuideWidget> {
  final ValueNotifier<int> _guideIndex = ValueNotifier(0); // 当前引导页索引
  final ValueNotifier<Offset> tapPosition = ValueNotifier(Offset.zero); // 用户点击位置
  late final UserGuideController _controller; // 暴露给外部调用的控制器

  @override
  void initState() {
    _controller = UserGuideController(this);
    super.initState();
  }

  @override
  void dispose() {
    _guideIndex.dispose();
    tapPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: _guideIndex, builder: (context, index, child) => buildGuidePage(widget.guidePages[index]));

  // 下一页
  nextGuide() {
    if (_guideIndex.value < widget.guidePages.length - 1) {
      _guideIndex.value++;
    } else {
      widget.onGuideEnd();
    }
  }

  // 上一页
  previousGuide() {
    if (_guideIndex.value > 0) _guideIndex.value--;
  }

  // 构建引导页
  Widget buildGuidePage(GuidePage page) {
    // 获取高亮组件的宽高、位置信息、中点坐标
    final renderBox = page.lightItem.lightKey.currentContext!.findRenderObject() as RenderBox;
    final widgetSize = renderBox.size;
    double widgetWidth = widgetSize.width;
    double widgetHeight = widgetSize.height;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero); // 这里获取到原始坐标

    // 根据Padding计算高亮区域的位置和大小
    if (page.lightItem.padding is EdgeInsets) {
      final padding = page.lightItem.padding as EdgeInsets;
      if (padding.left > 0) {
        widgetWidth += padding.left;
        widgetPosition = Offset(widgetPosition.dx - padding.left, widgetPosition.dy);
      }
      if (padding.right > 0) widgetWidth += padding.right;
      if (padding.top > 0) {
        widgetHeight += padding.top;
        widgetPosition = Offset(widgetPosition.dx, widgetPosition.dy - padding.top);
      }
      if (padding.bottom > 0) widgetHeight += padding.bottom;
    }

    // 根据形状和前面计算的位置和大小计算出高亮区域的Path
    Path lightPath = Path();
    switch (page.lightItem.shape) {
      case LightShape.rect:
        lightPath.addRect(Rect.fromLTWH(widgetPosition.dx, widgetPosition.dy, widgetWidth, widgetHeight));
        break;
      case LightShape.rRect:
        lightPath.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(widgetPosition.dx, widgetPosition.dy, widgetWidth, widgetHeight),
            Radius.circular(page.lightItem.radius == -1 ? widgetHeight / 2 : page.lightItem.radius)));
        break;
      case LightShape.circle:
        final circleRadius = widgetWidth > widgetHeight ? widgetWidth / 2 : widgetHeight / 2;
        lightPath.addOval(Rect.fromCircle(
            center: Offset(widgetPosition.dx + widgetWidth / 2, widgetPosition.dy + widgetHeight / 2),
            radius: circleRadius));
        break;
    }
    return GestureDetector(
      onTapUp: (details) => tapPosition.value = details.globalPosition,
      child: CustomPaint(
        painter: LightPainter(lightPath, page.tipItem.tip, page.stepItem.stepButton, tapPosition, _controller),
        child: Container(),
      ),
    );
  }
}

// 具体绘制
class LightPainter extends CustomPainter {
  // 外部传入参数
  final Path _lightPath;
  final String tip;
  final List<Map<String, UserGuideCallback>> stepButton;
  final ValueNotifier<Offset> _tapPosition;
  final UserGuideController _controller;

  // 画布宽高
  double width = 0;
  double height = 0;

  // 画笔
  final Paint redPaint = Paint()..color = Colors.red; // 红色
  final Paint highLightPaint = Paint() // 高亮
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;

  // 文字提示框内外边距
  final tipVerticalMargin = 10.0;
  final tipHorizontalMargin = 10.0;
  final tipVerticalPadding = 10.0;
  final tipHorizontalPadding = 10.0;

  // 按钮相关
  final buttonHeight = 50.0; // 按钮高度
  final spaceBetweenButton = 20.0; // 按钮间距
  final buttonVerticalMargin = 20.0; // 按钮垂直间距 (和提示框的间距)
  final Paint buttonPaint = Paint() // 按钮画笔
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  // 高亮区域是否在顶部
  bool isHighLightTop = true;

  LightPainter(this._lightPath, this.tip, this.stepButton, this._tapPosition, this._controller)
      : super(repaint: _tapPosition);

  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    height = size.height;
    paintHighLight(canvas);
    paintButtons(canvas, paintTips(canvas));
  }

  // 绘制高亮区域
  paintHighLight(Canvas canvas) {
    // 混合模式需要在单独图层上绘制才会生效，保存新图层后依次绘制半透明遮罩和高亮区域，最后恢复图层
    canvas.saveLayer(Offset.zero & Size(width, height), Paint());
    canvas.drawRect(Offset.zero & Size(width, height), Paint()..color = Colors.black.withOpacity(0.5));
    canvas.drawPath(_lightPath, highLightPaint);
    canvas.restore();
  }

  // 绘制文字提示
  double paintTips(Canvas canvas) {
    // 获取高亮区域的位置和大小，求出文本绘制的最大宽度 (换行用到)
    Rect lightRect = _lightPath.getBounds();
    double maxTipTextWidth = width - (tipHorizontalMargin + tipHorizontalPadding) * 2; // 文本最大高度
    // 文本测量
    final textPainter = TextPainter(
        text: TextSpan(text: tip, style: const TextStyle(color: Colors.white, fontSize: 14)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: maxTipTextWidth);
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // 判断高亮组件是否显示在上方 (底下剩余空间是否足够显示提示文本和按钮)
    isHighLightTop = height - lightRect.center.dy - lightRect.height / 2 >
        textHeight + buttonHeight + (tipVerticalMargin + tipVerticalPadding * 2) + buttonVerticalMargin;

    // 绘制三角形
    const triangleWidth = 15.0; // 三角形宽度
    Path trianglePath = Path();
    if (isHighLightTop) {
      trianglePath.moveTo(
          lightRect.left + (lightRect.width - triangleWidth) / 2, lightRect.bottom + tipVerticalMargin + triangleWidth);
      trianglePath.relativeLineTo(triangleWidth / 2, -triangleWidth);
      trianglePath.relativeLineTo(triangleWidth / 2, triangleWidth);
    } else {
      trianglePath.moveTo(
          lightRect.left + (lightRect.width - triangleWidth) / 2, lightRect.top - tipVerticalMargin - triangleWidth);
      trianglePath.relativeLineTo(triangleWidth / 2, triangleWidth);
      trianglePath.relativeLineTo(triangleWidth / 2, -triangleWidth);
    }
    trianglePath.close();
    canvas.drawPath(trianglePath, redPaint);

    // 绘制提示框和文字
    Rect tipRect;
    if (textWidth < maxTipTextWidth) {
      tipRect = Rect.fromLTWH(
          lightRect.left + (lightRect.width - textWidth) / 2 - tipHorizontalPadding,
          isHighLightTop
              ? lightRect.bottom + tipVerticalMargin + triangleWidth
              : lightRect.top - tipVerticalMargin - triangleWidth - textHeight - tipVerticalPadding * 2,
          textWidth + tipHorizontalPadding * 2,
          textHeight + tipVerticalPadding * 2);
      // 需要对右侧边缘进行判断，超出宽度要往前挪
      if (tipRect.right > width) {
        tipRect = tipRect.translate(-(tipRect.right - width + tipHorizontalMargin), 0);
      }
      // 需要对左侧边缘进行判断，超出宽度要往后挪
      if (tipRect.left < 0) {
        tipRect = tipRect.translate(-tipRect.left + tipHorizontalMargin, 0);
      }
      canvas.drawRRect(RRect.fromRectAndRadius(tipRect, const Radius.circular(10)), redPaint);
      textPainter.paint(canvas, Offset(tipRect.left + tipHorizontalPadding, tipRect.top + tipVerticalPadding));
    } else {
      tipRect = Rect.fromLTWH(
          tipHorizontalPadding,
          isHighLightTop
              ? lightRect.bottom + tipVerticalMargin + triangleWidth
              : lightRect.top - tipVerticalMargin - triangleWidth - textHeight - tipVerticalPadding * 2,
          maxTipTextWidth + tipHorizontalPadding * 2,
          textHeight + tipVerticalPadding * 2);
      canvas.drawRRect(RRect.fromRectAndRadius(tipRect, const Radius.circular(10)), redPaint);
      textPainter.paint(canvas, Offset(tipRect.left + tipHorizontalPadding, tipRect.top + tipVerticalPadding));
    }
    return isHighLightTop ? tipRect.bottom : tipRect.top;
  }

  // 绘制按钮
  paintButtons(Canvas canvas, double startY) {
    if (stepButton.isEmpty) return;
    List<Rect> buttonRectList = [];
    // 按钮宽度
    double buttonWidth =
        (width - (stepButton.length + 1) * spaceBetweenButton) / (stepButton.length == 1 ? 2 : stepButton.length);

    // 如果只有一个按钮，居中绘制
    if (stepButton.length == 1) {
      Rect buttonRect = Rect.fromLTWH(
          (width - buttonWidth) / 2,
          (isHighLightTop ? startY + buttonVerticalMargin : startY - buttonHeight - buttonVerticalMargin),
          buttonWidth,
          buttonHeight);
      buttonRectList.add(buttonRect);
      canvas.drawRRect(RRect.fromRectAndRadius(buttonRect, Radius.circular(buttonHeight / 2)), buttonPaint);
      // 文字测量
      final textPainter = TextPainter(
          text: TextSpan(text: stepButton.first.keys.first, style: const TextStyle(color: Colors.white, fontSize: 14)),
          textDirection: TextDirection.ltr,
          maxLines: 1,
          ellipsis: '...')
        ..layout(maxWidth: buttonWidth);
      final textWidth = textPainter.width;
      final textHeight = textPainter.height;
      textPainter.paint(
          canvas, Offset(buttonRect.left + (buttonWidth - textWidth) / 2, buttonRect.center.dy - textHeight / 2));
    } else {
      for (int i = 0; i < stepButton.length; i++) {
        Rect buttonRect = Rect.fromLTWH(
            spaceBetweenButton + i * (buttonWidth + spaceBetweenButton),
            (isHighLightTop ? startY + buttonVerticalMargin : startY - buttonHeight - buttonVerticalMargin),
            buttonWidth,
            buttonHeight);
        buttonRectList.add(buttonRect);
        canvas.drawRRect(RRect.fromRectAndRadius(buttonRect, Radius.circular(buttonHeight / 2)), buttonPaint);
        TextPainter textPainter = TextPainter(
            text: TextSpan(text: stepButton[i].keys.first, style: const TextStyle(color: Colors.white, fontSize: 14)),
            textDirection: TextDirection.ltr,
            maxLines: 1,
            ellipsis: '...')
          ..layout(maxWidth: buttonWidth);
        final textWidth = textPainter.width;
        final textHeight = textPainter.height;
        textPainter.paint(
            canvas, Offset(buttonRect.left + (buttonWidth - textWidth) / 2, buttonRect.center.dy - textHeight / 2));
      }
    }
    // 点击事件
    if (_tapPosition.value != Offset.zero) {
      for (int i = 0; i < stepButton.length; i++) {
        if (buttonRectList[i].contains(_tapPosition.value)) {
          // 帧结束后再执行，避免在构建widget树时调用报错
          SchedulerBinding.instance.addPostFrameCallback((_) {
            stepButton[i].values.first(_controller);
            _tapPosition.value = Offset.zero;
          });
          return;
        }
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _controller.nextGuide();
        _tapPosition.value = Offset.zero;
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => _lightPath != (oldDelegate as LightPainter)._lightPath;
}

// 引导页控制器
class UserGuideController {
  final UserGuideWidgetState _state;

  UserGuideController(this._state);

  nextGuide() => _state.nextGuide();

  previousGuide() => _state.previousGuide();
}

class GuidePage {
  final LightItem lightItem; // 高亮项
  final TipItem tipItem; // 提示文本项
  final StepItem stepItem; // 控制按钮项

  GuidePage({required this.lightItem, required this.tipItem, required this.stepItem});
}

// 高亮项
class LightItem {
  final GlobalKey lightKey; // 高亮组件Key
  final LightShape shape; // 高亮形状
  final double radius; // 圆角半径
  final EdgeInsetsGeometry padding; // 内边距

  LightItem(this.lightKey, {this.shape = LightShape.rect, this.radius = -1, this.padding = EdgeInsets.zero});
}

// 提示文本项
class TipItem {
  final String tip; // 提示文本
  TipItem(this.tip);
}

// 控制按钮项
class StepItem {
  final List<Map<String, UserGuideCallback>> stepButton;  // 控制按钮
  StepItem(this.stepButton);
}

// 高亮形状
enum LightShape {
  rect,
  rRect,
  circle,
}

// 暴露给外部调用的回调
typedef UserGuideCallback = void Function(UserGuideController controller);

// 弹出用户引导
showUserGuide(BuildContext context, List<GuidePage> guidePages, {VoidCallback? onGuideEnd}) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
      builder: (context) => UserGuideWidget(guidePages, () {
            overlayEntry?.remove();
            onGuideEnd?.call();
          }));
  Overlay.of(context).insert(overlayEntry);
}
