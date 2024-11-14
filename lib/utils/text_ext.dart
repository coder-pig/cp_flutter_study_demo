import 'package:flutter/material.dart';

/// 字体相关的扩展

/// 字体样式，最后一项有设置Color不用调build()
///
/// 调用示例：
///
/// 默认样式：HBTextStyle.build();
///
/// 常规调用：HBTextStyle.s12.bold.c(Colors.white)、 HBTextStyle.s14.c(Colors.white)、HBTextStyle.c(Colors.white)
///
/// 其它调用：TextStyleBuilder(fontSize: 14, color: Colors.red).build()、TextStyleBuilder(fontSize: 16).bold.build();
class CPTextStyle {
  static final TextStyleBuilder s10 = TextStyleBuilder(fontSize: 10);
  static final TextStyleBuilder s11 = TextStyleBuilder(fontSize: 11);
  static final TextStyleBuilder s12 = TextStyleBuilder(fontSize: 12);
  static final TextStyleBuilder s13 = TextStyleBuilder(fontSize: 13);
  static final TextStyleBuilder s14 = TextStyleBuilder(fontSize: 14);
  static final TextStyleBuilder s15 = TextStyleBuilder(fontSize: 15);
  static final TextStyleBuilder s16 = TextStyleBuilder(fontSize: 16);
  static final TextStyleBuilder s17 = TextStyleBuilder(fontSize: 17);
  static final TextStyleBuilder s18 = TextStyleBuilder(fontSize: 18);
  static final TextStyleBuilder s19 = TextStyleBuilder(fontSize: 19);
  static final TextStyleBuilder s20 = TextStyleBuilder(fontSize: 20);
  static final TextStyleBuilder s21 = TextStyleBuilder(fontSize: 21);
  static final TextStyleBuilder s22 = TextStyleBuilder(fontSize: 22);
  static final TextStyleBuilder s23 = TextStyleBuilder(fontSize: 23);
  static final TextStyleBuilder s24 = TextStyleBuilder(fontSize: 24);

  static build({double? fontSize, Color? color, FontWeight? fontWeight}) =>
      TextStyleBuilder(fontSize: fontSize, color: color, fontWeight: fontWeight);
}

class TextStyleBuilder {
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;

  TextStyleBuilder({this.fontSize, this.color, this.fontWeight});

  TextStyle c(Color color) {
    this.color = color;
    return build();
  }

  TextStyleBuilder get bold {
    fontWeight = FontWeight.bold;
    return this;
  }

  TextStyleBuilder get normal {
    fontWeight = FontWeight.normal;
    return this;
  }

  // 不传参返回默认样式
  TextStyle build() => TextStyle(
    color: color ?? Colors.black,
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? FontWeight.normal,
    decoration: TextDecoration.none,
  );
}