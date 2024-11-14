import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: MaterialApp(
      home: PopupPreview(),
    ));
  }
}

class PopupPreview extends StatelessWidget {
  const PopupPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('各种Flutter弹窗预览'),
          actions: [
            PopupMenuButton<int>(
              onSelected: (value) {
                // Handle the selected value
                print("Selected value: $value");
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Option 1"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Option 2"),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text("Option 3"),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              children: [
                buildButton('showDialog()', () => testShowDialog(context)),
                buildButton('showGeneralDialog()', () => testShowGeneralDialog(context)),
                buildButton('showCupertinoDialog()', () => testShowCupertinoDialog(context)),
                buildButton('showAboutDialog()', () => testShowAboutDialog(context)),
                buildButton('showTimePicker()', () => testShowTimePicker(context)),
                buildButton('showDatePicker()', () => testShowDatePicker(context)),
                buildButton('showSearch()', () => testShowSearch(context)),
                buildButton('showModalBottomSheet()', () => testShowModalBottomSheet(context)),
                buildButton('showSnackBar()', () => testShowSnackBar(context)),
                buildButton('showLicensePage()', () => testShowLicensePage(context)),
                buildButton('showMenu()', () => testShowMenu(context)),
                Tooltip(message: '长按显示提示', child: buildButton('Tooltip', () {})),
              ],
            )));
  }

  // 生成按钮
  Widget buildButton(String text, VoidCallback onTap) => ElevatedButton(onPressed: onTap, child: Text(text));

  testShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("showDialog"),
          content: const Text("这是一个AlertDialog"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  testShowGeneralDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: 200,
            height: 100,
            color: Colors.white,
            child: Column(
              children: [
                const Text("showGeneralDialog", style: TextStyle(fontSize: 14)),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("确定"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  testShowCupertinoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("showCupertinoDialog"),
          content: const Text("这是一个CupertinoAlertDialog"),
          actions: [
            CupertinoDialogAction(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: const Text("确定"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  testShowAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Flutter Demo",
      applicationVersion: "1.0.0",
      applicationIcon: const FlutterLogo(),
      applicationLegalese: "© 2021 Flutter Demo",
    );
  }

  testShowTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) => print("选择的时间为：$value"));
  }

  testShowDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    ).then((value) => print("选择的日期为：$value"));
  }

  testShowSearch(BuildContext context) {
    // 需要自定义SearchDelegate类
    showSearch(context: context, delegate: _SearchDelegate());
  }

  testShowModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              const Text("showModalBottomSheet", style: TextStyle(fontSize: 14)),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("确定"),
              ),
            ],
          ),
        );
      },
    );
  }

  testShowSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("showSnackBar"),
        action: SnackBarAction(
          label: "确定",
          onPressed: () {
            // do something
          },
        ),
      ),
    );
  }

  testShowLicensePage(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: "Flutter Demo",
      applicationVersion: "1.0.0",
      applicationIcon: const FlutterLogo(),
    );
  }

  testShowMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 405, 0, 0),
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text("菜单1"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("菜单2"),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text("菜单3"),
        ),
      ],
    ).then((value) {
      print("选择的菜单值为：$value");
    });
  }
}

// 自定义搜索代理类
class _SearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // 应用栏中的操作按钮，通常包含清楚搜索查询的按钮
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 显示在搜索查询前面的控件。通常是一个返回按钮或关闭按钮，用于退出搜索
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 根据搜索查询构建搜索结果。当用户提交查询时显示搜索结果。
    return Center(
      child: Text(
        query,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 根据当前的搜索查询构建建议。当用户在搜索字段中输入时显示建议。
    final suggestions = ['apple', 'banana', 'orange', 'grape'].where((element) => element.contains(query)).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
