import 'package:cp_flutter_study_demo/utils/dialog_util.dart';
import 'package:cp_flutter_study_demo/utils/state_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'list_model.dart';
import 'filter_menu_stack.dart';

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
          title: const Text('基于Stack实现下拉菜单筛选框'),
        ),
        body: const MenuPage(),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Dio dio = Dio();
  final ListReq _req = ListReq();
  ListRes? _res;
  List<MenuItemConfig> menuItems = []; // 菜单项配置
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    menuItems = [
      MenuItemConfig('排序', sortPopMenu),
      MenuItemConfig('输入', inputPopMenu),
      MenuItemConfig('筛选3', (controller) {
        return Container(color: Colors.green, height: 200);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FilterMenuStack(
      menuItems,
      content: Center(child: Text('请求返回结果：\n\n${_res?.toString()}', textAlign: TextAlign.center)),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // 排序弹窗
  Widget sortPopMenu(FilterMenuController controller) {
    List<Map<String, Object>> menuItems = [
      {'title': '综合排序', 'sortType': 0},
      {'title': '销量优先', 'sortType': 1},
      {'title': '价格从低到高', 'sortType': 2},
      {'title': '价格从高到低', 'sortType': 3},
    ];
    return IntrinsicHeight(
      child: Column(
        children: menuItems.map((item) {
          return GestureDetector(
            onTap: () {
              controller.closeMenu();
              _req.sortType = item['sortType'] as int;
              if (item['sortType'] == 0) {
                controller.setTitle(0, '排序');
                controller.setSelect(0, false);
              } else {
                controller.setTitle(0, item['title'].toString());
                controller.setSelect(0, true);
              }
              _loadRequest();
            },
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(item['title'].toString()),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 输入弹窗
  Widget inputPopMenu(FilterMenuController controller) {
    _textController.text = _req.searchKey ?? '';
    return SingleChildScrollView(child: Container(
      color: Colors.white,
      child: IntrinsicHeight(
          child: Column(
            children: [
              const SizedBox(height: 300),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: '请输入搜索关键字'),
                    onChanged: (value) {
                      _req.searchKey = value;
                    },
                  )),
              ElevatedButton(
                onPressed: () {
                  controller.closeMenu();
                  _loadRequest();
                },
                child: const Text('搜索'),
              ),
            ],
          )),
    ));
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
