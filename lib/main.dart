import 'dart:convert';

import 'package:flame/flame.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuffles_run/data.dart';
import 'package:snuffles_run/screens/main_menu.dart';
import 'package:snuffles_run/screens/options.dart';

import 'game.dart';

// Single instance of player data here
// TODO: use a provider?
Data playerData = Data();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  // Load saved data
  String prefs = await SharedPreferences.getInstance()
      .then((info) => info.get('data').toString());
  playerData = Data.fromJson(jsonDecode(prefs));

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

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenu(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameLoader(),
    ),
    GoRoute(
      path: '/options',
      builder: (context, state) => const OptionsMenu(),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
