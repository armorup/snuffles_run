import 'package:flame/flame.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:snuffles_run/screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  runApp(
    MaterialApp(
      title: 'Snuffles Run',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
      home: App(),
    ),
  );
}
