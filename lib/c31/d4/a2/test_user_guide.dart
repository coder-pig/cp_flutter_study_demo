import 'package:cp_flutter_study_demo/c31/d4/a2/user_guide_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('用于引导弹出测试页面'),
          ),
          body: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey firstKey = GlobalKey();
    GlobalKey secondKey = GlobalKey();
    GlobalKey thirdKey = GlobalKey();
    GlobalKey forthKey = GlobalKey();
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          ElevatedButton(
              key: firstKey,
              onPressed: () {
                // 💡 弹出用户引导页
                showUserGuide(context, [
                  // ① 默认
                  GuidePage(
                    lightItem: LightItem(firstKey),
                    tipItem: TipItem("这是一句提示这是一句提示这是一句提示这是一句提示这是一句提示这是一句提示这是一句提示这是一句提示"),
                    stepItem: StepItem([
                      {"下一步": (controller) => controller.nextGuide()},
                    ]),
                  ),
                  // ② 设置内边距 + 圆角
                  GuidePage(
                    lightItem: LightItem(secondKey,
                        padding: const EdgeInsets.all(30), shape: LightShape.rRect),
                    tipItem: TipItem("这是第二句提示这是第二句提示这是第二句提示这是第二句提示这是第二句提示这是第二句提示这是第二句提示这是第二句提示这是第二句提示"),
                    stepItem: StepItem([
                      {"上一步": (controller) => controller.previousGuide()},
                      {"知道了": (controller) => controller.nextGuide()},
                    ]),
                  ),
                  // ③ 设置内边距 + 圆形
                  GuidePage(
                    lightItem: LightItem(thirdKey, padding: const EdgeInsets.all(10), shape: LightShape.circle),
                    tipItem: TipItem("这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示这是第三句提示"),
                    stepItem: StepItem([
                      {"上一步": (controller) => controller.previousGuide()},
                      {"好的": (controller) => controller.nextGuide()},
                    ]),
                  ),
                  GuidePage(
                    lightItem: LightItem(forthKey),
                    tipItem: TipItem("这是第四句提示12345678这是第四句提示12345678"),
                    stepItem: StepItem([
                      {"上一步": (controller) => controller.previousGuide()},
                      {"完成": (controller) => controller.nextGuide()},
                    ]),
                  ),
                ], onGuideEnd: () {
                  print("用户引导结束");
                });
              },
              child: const Text("弹出用户引导")),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(key: secondKey, width: 100, height: 200, color: Colors.red),
              ElevatedButton(key: thirdKey, onPressed: () {}, child: const Text("弹出用户引导")),
            ],
          ),
          const SizedBox(height: 300),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(key: forthKey, onPressed: () {}, child: const Text("弹出用户引导")))),
        ],
      ),
    );
  }
}
