import 'package:cp_flutter_study_demo/c28/d2/list_model.dart';
import 'package:cp_flutter_study_demo/c28/d4/pop_menu_route.dart';
import 'package:cp_flutter_study_demo/utils/dialog_util.dart';
import 'package:cp_flutter_study_demo/utils/state_ext.dart';
import 'package:dio/dio.dart';
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
        appBar: AppBar(title: const Text('自定义弹窗Route使用示例')),
        body: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Dio dio = Dio();
  final ListReq _req = ListReq();
  ListRes? _res;

  @override
  Widget build(BuildContext context) {
    GlobalKey anchorKey = GlobalKey();
    return Column(
      children: [
        ElevatedButton(
          key: anchorKey,
          onPressed: () async {
            // 💡 弹窗，接收返回值
            var newReq = await showPopMenu(
              anchorKey,
              (BuildContext context) {
                return SingleChildScrollView(
                  child: SortPopupContent(req: _req),
                );
              },
            );
            if(newReq != null) {
                _req.sortType = newReq.sortType;
                _loadRequest();
            }
          },
          child: const Text('显示弹出菜单'),
        ),
        Expanded(child: Center(child: Text('请求返回结果：\n\n${_res?.toString()}', textAlign: TextAlign.center))),
      ],
    );
  }

  // 请求接口
  _loadRequest() async {
    try {
      showLoadingDialog(context);
      Response response =
      await dio.post('https://apifoxmock.com/m1/4081539-3719383-default/flutter/c28/list', data: _req.toJson());
      safeSetState(() {
        _res = ListRes.fromJson(response.data);
      });
    } catch (e) {
      safeSetState(() {
        _res = null;
      });
    } finally {
      if (mounted) hideLoadingDialog(context);
    }
  }
}

// 弹窗的主体内容
class SortPopupContent extends StatelessWidget {
  final ListReq req;
  final List<Map<String, Object>> menuItems = [
    {'title': '综合排序', 'sortType': 0},
    {'title': '销量优先', 'sortType': 1},
    {'title': '价格从低到高', 'sortType': 2},
    {'title': '价格从高到低', 'sortType': 3},
  ];

  SortPopupContent({super.key, required this.req});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: menuItems.map((item) {
          return GestureDetector(
            onTap: () {
              print('点击了：$item');
              req.sortType = item['sortType'] as int;
              // 💡 参数回传
              Navigator.of(context).pop(req);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5))),
              ),
              child: Center(
                  child: Text(item['title'] as String,
                      style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          color: req.sortType == item['sortType'] ? Colors.red : Colors.black,
                          fontWeight: FontWeight.normal))),
            ),
          );
        }).toList(),
      ),
    );
  }
}
