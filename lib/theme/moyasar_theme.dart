import 'package:flutter/material.dart';

class MoyasarTheme extends InheritedWidget {
  final ThemeData data;

  const MoyasarTheme({super.key, required this.data, required super.child});

  static MoyasarTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MoyasarTheme>();
  }

  @override
  bool updateShouldNotify(covariant MoyasarTheme oldWidget) {
    return oldWidget.data != data;
  }
}
