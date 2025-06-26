import 'package:flutter/material.dart';

void main() {
  runApp(const ThemeUseDemoApp());
} 

/// 主题使用演示应用
class ThemeUseDemoApp extends StatelessWidget {
  const ThemeUseDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeUseDemo();
  }
}

/// 主题使用演示
/// 包含多种主题切换、主题自定义、自定义主题扩展
class ThemeUseDemo extends StatefulWidget {
  const ThemeUseDemo({super.key});

  @override
  State<ThemeUseDemo> createState() => _ThemeUseDemoState();
}

class _ThemeUseDemoState extends State<ThemeUseDemo> {
  // 当前选择的主题模式
  ThemeMode _themeMode = ThemeMode.system;
  
  // 当前选择的自定义主题
  CustomThemeStyle _customThemeStyle = CustomThemeStyle.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 应用标题
      title: 'Flutter Theme Demo',
      // 主题模式：跟随系统/强制浅色/强制深色
      themeMode: _themeMode,
      // 浅色模式主题配置
      theme: _buildTheme(false, _customThemeStyle),
      // 深色模式主题配置
      darkTheme: _buildTheme(true, _customThemeStyle),
      // 应用主页面
      home: _ThemeHomePage(
        // 主题模式变化回调
        onThemeModeChanged: (themeMode) => setState(() => _themeMode = themeMode),
        // 自定义主题风格变化回调
        onCustomThemeStyleChanged: (style) => setState(() => _customThemeStyle = style),
        // 当前主题模式
        themeMode: _themeMode,
        // 当前自定义主题风格
        customThemeStyle: _customThemeStyle,
      ),
    );
  }

  /// 构建主题
  ThemeData _buildTheme(bool isDark, CustomThemeStyle customThemeStyle) {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    final colorScheme = _getColorScheme(isDark, customThemeStyle);
    
    return baseTheme.copyWith(
      // 颜色方案配置
      colorScheme: colorScheme,
      // AppBar样式主题
      appBarTheme: _buildAppBarTheme(colorScheme),
      // 悬浮按钮样式主题
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      // 卡片样式主题
      cardTheme: _buildCardTheme(colorScheme),
      // 输入框装饰主题
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      // 文本样式主题
      textTheme: _buildTextTheme(baseTheme.textTheme, colorScheme),
      // 自定义主题扩展
      extensions: [_buildCustomThemeExtension(customThemeStyle, colorScheme)],
    );
  }

  /// 构建 AppBar 主题
  AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      // AppBar背景颜色
      backgroundColor: colorScheme.primary,
      // AppBar前景色（图标、文字颜色）
      foregroundColor: colorScheme.onPrimary,
      // AppBar阴影高度
      elevation: 4,
      // AppBar阴影颜色
      shadowColor: colorScheme.shadow,
      // AppBar标题文字样式
      titleTextStyle: TextStyle(
        // 标题字体大小
        fontSize: 20,
        // 标题字体粗细
        fontWeight: FontWeight.bold,
        // 标题文字颜色
        color: colorScheme.onPrimary,
      ),
    );
  }

  /// 构建按钮主题
  ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // 按钮背景颜色
        backgroundColor: colorScheme.primary,
        // 按钮前景色（文字、图标颜色）
        foregroundColor: colorScheme.onPrimary,
        // 按钮阴影高度
        elevation: 8,
        // 按钮阴影颜色
        shadowColor: colorScheme.shadow,
        // 按钮形状（圆角边框）
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // 按钮内边距
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  /// 构建卡片主题
  CardTheme _buildCardTheme(ColorScheme colorScheme) {
    return CardTheme(
      // 卡片阴影高度
      elevation: 8,
      // 卡片阴影颜色
      shadowColor: colorScheme.shadow,
      // 卡片形状（圆角边框）
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // 卡片背景颜色
      color: colorScheme.surface,
    );
  }

  /// 构建输入框主题
  InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      // 默认边框样式
      border: OutlineInputBorder(
        // 边框圆角
        borderRadius: BorderRadius.circular(12),
        // 边框线条样式
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      // 启用状态边框样式
      enabledBorder: OutlineInputBorder(
        // 边框圆角
        borderRadius: BorderRadius.circular(12),
        // 边框线条样式
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      // 聚焦状态边框样式
      focusedBorder: OutlineInputBorder(
        // 边框圆角
        borderRadius: BorderRadius.circular(12),
        // 聚焦时边框线条（颜色+宽度）
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      // 是否填充背景
      filled: true,
      // 填充背景颜色
      fillColor: colorScheme.surfaceVariant,
    );
  }

  /// 构建文本主题
  TextTheme _buildTextTheme(TextTheme baseTextTheme, ColorScheme colorScheme) {
    return baseTextTheme.copyWith(
      // 大标题样式（32px）
      headlineLarge: TextStyle(
        // 字体大小
        fontSize: 32,
        // 字体粗细
        fontWeight: FontWeight.bold,
        // 文字颜色
        color: colorScheme.onSurface,
      ),
      // 中标题样式（24px）
      headlineMedium: TextStyle(
        // 字体大小
        fontSize: 24,
        // 字体粗细
        fontWeight: FontWeight.w600,
        // 文字颜色
        color: colorScheme.onSurface,
      ),
      // 大正文样式（16px）
      bodyLarge: TextStyle(
        // 字体大小
        fontSize: 16,
        // 文字颜色
        color: colorScheme.onSurface,
      ),
      // 中正文样式（14px）
      bodyMedium: TextStyle(
        // 字体大小
        fontSize: 14,
        // 文字颜色
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// 构建自定义主题扩展
  CustomThemeExtension _buildCustomThemeExtension(
    CustomThemeStyle customThemeStyle, 
    ColorScheme colorScheme,
  ) {
    return CustomThemeExtension(
      // 渐变色配置（用于渐变容器）
      gradientColors: _getGradientColors(customThemeStyle),
      // 自定义阴影效果
      customShadow: BoxShadow(
        // 阴影颜色（带透明度）
        color: colorScheme.shadow.withOpacity(0.3),
        // 阴影模糊半径
        blurRadius: 12,
        // 阴影偏移量（x, y）
        offset: const Offset(0, 6),
      ),
      // 自定义圆角半径
      customBorderRadius: BorderRadius.circular(20),
      // 自定义强调色
      accentColor: _getAccentColor(customThemeStyle),
    );
  }

  /// 获取颜色方案
  ColorScheme _getColorScheme(bool isDark, CustomThemeStyle customThemeStyle) {
    final themeColors = _getThemeColors(customThemeStyle);
    
    return isDark
        ? ColorScheme.dark(
            // 主色调（按钮、AppBar等主要元素颜色）
            primary: themeColors.primary,
            // 主色调上的文字/图标颜色
            onPrimary: themeColors.onPrimary,
            // 次要色调（辅助元素颜色）
            secondary: themeColors.secondary,
            // 次要色调上的文字/图标颜色
            onSecondary: Colors.black,
            // 表面颜色（卡片、对话框背景等）
            surface: const Color(0xFF121212),
            // 表面上的文字/图标颜色
            onSurface: Colors.white,
          )
        : ColorScheme.light(
            // 主色调（按钮、AppBar等主要元素颜色）
            primary: themeColors.primary,
            // 主色调上的文字/图标颜色
            onPrimary: themeColors.onPrimary,
            // 次要色调（辅助元素颜色）
            secondary: themeColors.secondary,
            // 次要色调上的文字/图标颜色
            onSecondary: Colors.black,
            // 表面颜色（卡片、对话框背景等）
            surface: Colors.white,
            // 表面上的文字/图标颜色
            onSurface: Colors.black,
          );
  }

  /// 获取主题颜色
  _ThemeColors _getThemeColors(CustomThemeStyle customThemeStyle) {
    switch (customThemeStyle) {
      case CustomThemeStyle.blue:
        return const _ThemeColors(
          primary: Color(0xFF1976D2),
          onPrimary: Colors.white,
          secondary: Color(0xFF03DAC6),
        );
      case CustomThemeStyle.purple:
        return const _ThemeColors(
          primary: Color(0xFF7B1FA2),
          onPrimary: Colors.white,
          secondary: Color(0xFFE1BEE7),
        );
      case CustomThemeStyle.green:
        return const _ThemeColors(
          primary: Color(0xFF388E3C),
          onPrimary: Colors.white,
          secondary: Color(0xFFC8E6C9),
        );
      case CustomThemeStyle.orange:
        return const _ThemeColors(
          primary: Color(0xFFFF9800),
          onPrimary: Colors.black,
          secondary: Color(0xFFFFE0B2),
        );
    }
  }

  /// 获取渐变色
  List<Color> _getGradientColors(CustomThemeStyle customThemeStyle) {
    switch (customThemeStyle) {
      case CustomThemeStyle.blue:
        return [const Color(0xFF0D47A1), const Color(0xFF42A5F5), const Color(0xFF81D4FA)];
      case CustomThemeStyle.purple:
        return [const Color(0xFF4A148C), const Color(0xFF7B1FA2), const Color(0xFFBA68C8)];
      case CustomThemeStyle.green:
        return [const Color(0xFF1B5E20), const Color(0xFF388E3C), const Color(0xFF81C784)];
      case CustomThemeStyle.orange:
        return [const Color(0xFFE65100), const Color(0xFFFF9800), const Color(0xFFFFCC02)];
    }
  }

  /// 获取强调色
  Color _getAccentColor(CustomThemeStyle customThemeStyle) {
    switch (customThemeStyle) {
      case CustomThemeStyle.blue:
        return const Color(0xFF03DAC6);
      case CustomThemeStyle.purple:
        return const Color(0xFFE1BEE7);
      case CustomThemeStyle.green:
        return const Color(0xFFC8E6C9);
      case CustomThemeStyle.orange:
        return const Color(0xFFFFE0B2);
    }
  }
}

/// 主题首页
class _ThemeHomePage extends StatelessWidget {
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<CustomThemeStyle> onCustomThemeStyleChanged;
  final ThemeMode themeMode;
  final CustomThemeStyle customThemeStyle;

  const _ThemeHomePage({
    required this.onThemeModeChanged,
    required this.onCustomThemeStyleChanged,
    required this.themeMode,
    required this.customThemeStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 主题演示'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showThemeSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCurrentThemeInfo(context),
            const SizedBox(height: 16),
            _buildThemeControls(context),
            const SizedBox(height: 16),
            _buildComponentShowcase(context),
            const SizedBox(height: 16),
            _buildCustomExtensionDemo(context),
          ],
        ),
      ),
    );
  }

  /// 构建当前主题信息
  Widget _buildCurrentThemeInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('当前主题信息', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            _InfoRow(label: '主题模式', value: _getThemeModeText()),
            _InfoRow(label: '亮度', value: isDark ? '深色' : '浅色'),
            _InfoRow(label: '自定义风格', value: _getCustomThemeStyleText()),
            const _InfoRow(label: '主色调', value: ''),
            Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(left: 80, top: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${theme.colorScheme.primary.toString()} (${customThemeStyle.name})',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建主题控制器
  Widget _buildThemeControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('主题控制', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            
            const Text('主题模式:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ThemeMode.values.map((mode) {
                return ChoiceChip(
                  label: Text(_getThemeModeText(mode)),
                  selected: themeMode == mode,
                  onSelected: (selected) {
                    if (selected) onThemeModeChanged(mode);
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            const Text('主题风格:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: CustomThemeStyle.values.map((style) {
                return ChoiceChip(
                  label: Text(_getCustomThemeStyleText(style)),
                  selected: customThemeStyle == style,
                  onSelected: (selected) {
                    if (selected) onCustomThemeStyleChanged(style);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建组件展示
  Widget _buildComponentShowcase(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('组件展示', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            
            const Text('按钮:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _showSnackBar(context, 'ElevatedButton 被点击'),
                  child: const Text('ElevatedButton'),
                ),
                OutlinedButton(
                  onPressed: () => _showSnackBar(context, 'OutlinedButton 被点击'),
                  child: const Text('OutlinedButton'),
                ),
                TextButton(
                  onPressed: () => _showSnackBar(context, 'TextButton 被点击'),
                  child: const Text('TextButton'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            const Text('输入框:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: '用户名',
                hintText: '请输入用户名',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text('控件:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                Switch(value: true, onChanged: (_) {}),
                const SizedBox(width: 16),
                Expanded(child: Slider(value: 0.5, onChanged: (_) {})),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建自定义扩展演示
  Widget _buildCustomExtensionDemo(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('自定义主题扩展', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            
            // 渐变容器
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: customTheme?.gradientColors ?? [Colors.blue, Colors.lightBlue, Colors.cyan],
                  stops: const [0.0, 0.5, 1.0], // 渐变停止点，让渐变更明显
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: customTheme?.customBorderRadius ?? BorderRadius.circular(8),
                boxShadow: [customTheme?.customShadow ?? const BoxShadow()],
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🎨 自定义渐变容器',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '主题: ${customThemeStyle.name}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 强调色展示
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: customTheme?.accentColor ?? Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '自定义强调色 (${customTheme?.accentColor.toString() ?? "默认"})',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示主题设置对话框
  void _showThemeSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('主题设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return ListTile(
              title: Text(_getThemeModeText(mode)),
              leading: Radio<ThemeMode>(
                value: mode,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    onThemeModeChanged(value);
                    Navigator.pop(context);
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示 SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// 获取主题模式文本
  String _getThemeModeText([ThemeMode? mode]) {
    mode ??= themeMode;
    return switch (mode) {
      ThemeMode.system => '跟随系统',
      ThemeMode.light => '浅色',
      ThemeMode.dark => '深色',
    };
  }

  /// 获取自定义主题风格文本
  String _getCustomThemeStyleText([CustomThemeStyle? style]) {
    style ??= customThemeStyle;
    return switch (style) {
      CustomThemeStyle.blue => '蓝色',
      CustomThemeStyle.purple => '紫色',
      CustomThemeStyle.green => '绿色',
      CustomThemeStyle.orange => '橙色',
    };
  }
}

/// 信息行组件
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

/// 主题颜色数据类
class _ThemeColors {
  final Color primary;
  final Color onPrimary;
  final Color secondary;

  const _ThemeColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
  });
}

/// 自定义主题风格枚举
enum CustomThemeStyle { blue, purple, green, orange }

/// 自定义主题扩展
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  // 渐变色列表（用于LinearGradient）
  final List<Color> gradientColors;
  // 自定义阴影效果
  final BoxShadow customShadow;
  // 自定义圆角半径
  final BorderRadius customBorderRadius;
  // 自定义强调色
  final Color accentColor;

  const CustomThemeExtension({
    required this.gradientColors,
    required this.customShadow,
    required this.customBorderRadius,
    required this.accentColor,
  });

  @override
  CustomThemeExtension copyWith({
    List<Color>? gradientColors,
    BoxShadow? customShadow,
    BorderRadius? customBorderRadius,
    Color? accentColor,
  }) {
    return CustomThemeExtension(
      gradientColors: gradientColors ?? this.gradientColors,
      customShadow: customShadow ?? this.customShadow,
      customBorderRadius: customBorderRadius ?? this.customBorderRadius,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;

    return CustomThemeExtension(
      gradientColors: _lerpColorList(gradientColors, other.gradientColors, t),
      customShadow: BoxShadow.lerp(customShadow, other.customShadow, t) ?? customShadow,
      customBorderRadius: BorderRadius.lerp(customBorderRadius, other.customBorderRadius, t) ?? customBorderRadius,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
    );
  }

  /// 颜色列表插值
  List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final result = <Color>[];
    final maxLength = a.length > b.length ? a.length : b.length;
    
    for (int i = 0; i < maxLength; i++) {
      final colorA = i < a.length ? a[i] : a.last;
      final colorB = i < b.length ? b[i] : b.last;
      result.add(Color.lerp(colorA, colorB, t) ?? colorA);
    }
    
    return result;
  }
}
