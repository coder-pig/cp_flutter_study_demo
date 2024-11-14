// 显示Loading弹窗
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 显示Loading弹窗
showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

// 隐藏Loading弹窗
hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
