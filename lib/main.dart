import 'dart:convert';

import 'package:flame/flame.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuffles_run/player_data.dart';
import 'package:snuffles_run/screens/achievements.dart';
import 'package:snuffles_run/screens/endless.dart';
import 'package:snuffles_run/screens/main_menu.dart';
import 'package:snuffles_run/screens/options.dart';
import 'package:snuffles_run/screens/playmode.dart';

import 'game.dart';

// Single instance of player data here
PlayerData playerData = PlayerData();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  // Load saved data
  String prefs = await SharedPreferences.getInstance()
      .then((info) => info.get('data').toString());
  playerData = PlayerData.fromJson(jsonDecode(prefs));

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

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainMenu(),
      ),
      GoRoute(
        path: '/mode',
        builder: (context, state) => const PlayMode(),
      ),
      GoRoute(
        path: '/game',
        pageBuilder: (context, state) => Page(const GameLoader()),
      ),
      GoRoute(
        path: '/endless',
        pageBuilder: (context, state) => Page(const Endless()),
      ),
      GoRoute(
        path: '/options',
        builder: (context, state) => const OptionsMenu(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const Achievements(),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

/// Custom Fade transistion
class Page extends CustomTransitionPage {
  Page(child)
      : super(
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}
